import Foundation

final class ShoppingItemParsingService {

    func parseItemTitles(from snapshot: SpeechRecognitionSnapshot?) -> [String] {
        guard let snapshot else {
            return []
        }

        let pauseSeparatedChunks = chunks(from: snapshot.segments)
        let sourceHasSeparatorHint = containsSeparatorHint(snapshot.text)

        return pauseSeparatedChunks.flatMap { chunk in
            normalizedItemTitles(
                from: chunk,
                forceLooseSplit: sourceHasSeparatorHint
            )
        }
    }

    private func chunks(from segments: [SpeechRecognitionSegment]) -> [String] {
        guard !segments.isEmpty else {
            return []
        }

        var chunks: [String] = []
        var currentChunk: [String] = []
        var previousEndTime: TimeInterval?

        for segment in segments {
            let segmentEndTime = segment.timestamp + segment.duration

            if let previousEndTime, segment.timestamp - previousEndTime > 0.35 {
                let chunk = currentChunk.joined(separator: " ")
                if !chunk.isEmpty {
                    chunks.append(chunk)
                }
                currentChunk.removeAll()
            }

            currentChunk.append(segment.text)
            previousEndTime = segmentEndTime
        }

        let finalChunk = currentChunk.joined(separator: " ")
        if !finalChunk.isEmpty {
            chunks.append(finalChunk)
        }

        return chunks
    }

    private func normalizedItemTitles(
        from text: String,
        forceLooseSplit: Bool
    ) -> [String] {
        let cleanedText = removeLeadingCommandWords(from: text)

        let normalizedText = cleanedText
            .replacingOccurrences(of: " and ", with: ",", options: .caseInsensitive)
            .replacingOccurrences(of: " та ", with: ",", options: .caseInsensitive)
            .replacingOccurrences(of: " і ", with: ",", options: .caseInsensitive)
            .replacingOccurrences(of: " й ", with: ",", options: .caseInsensitive)
            .replacingOccurrences(of: ";", with: ",")
            .replacingOccurrences(of: "/", with: ",")

        let explicitParts = normalizedText
            .components(separatedBy: CharacterSet(charactersIn: ",.\n"))
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        return explicitParts.flatMap { part in
            splitLooseItemCandidate(part, forceSplit: forceLooseSplit)
        }
    }

    private func splitLooseItemCandidate(
        _ candidate: String,
        forceSplit: Bool
    ) -> [String] {
        let words = candidate
            .components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }

        guard words.count > 1 else {
            return [candidate]
        }

        if forceSplit {
            if words.count == 2, looksLikeCompoundDescriptor(words[0]) {
                return [candidate]
            }

            return words
        }

        guard shouldSplitLooseCandidate(words) else {
            return [candidate]
        }

        return words
    }

    private func shouldSplitLooseCandidate(_ words: [String]) -> Bool {
        switch words.count {
        case 0, 1:
            return false
        case 2:
            // Do not split pairs where the first word looks like an
            // adjective/descriptor, a quantity word or a numeral.
            return !(looksLikeCompoundDescriptor(words[0]) || isQuantityOrNumeral(words[0]))
        default:
            return true
        }
    }

    private func looksLikeCompoundDescriptor(_ word: String) -> Bool {
        let lowercasedWord = word.lowercased()
        guard lowercasedWord.count > 2 else {
            return false
        }

        let adjectiveLikeSuffixes = [
            "ий",
            "ій",
            "а",
            "я",
            "е",
            "є",
            "ого",
            "ому",
            "ими",
            "их",
            "ою",
            "ею",
            "ові",
            "еві",
            "ова",
            "ева",
            "ове",
            "еве",
            "ний",
            "ній"
        ]

        if adjectiveLikeSuffixes.contains(where: { lowercasedWord.hasSuffix($0) }) {
            return true
        }

        // also treat common descriptor prefixes (e.g. "свіжий", "великий")
        let adjectivePrefixes = ["св", "вел", "мал", "сол", "сма", "черв"]
        if adjectivePrefixes.contains(where: { lowercasedWord.hasPrefix($0) }) {
            return true
        }

        return false
    }

    private func isQuantityOrNumeral(_ word: String) -> Bool {
        let lower = word.lowercased()

        // Arabic numerals or numbers with units (e.g. "2", "2л", "200г")
        if Int(lower) != nil { return true }
        if Double(lower) != nil { return true }

        // Words that indicate quantity/measure or spelled-out numbers in Ukrainian
        let quantityWords: Set<String> = [
            "кг", "г", "гр", "грам", "грамів", "літр", "л", "шт", "пачка", "пакет",
            "упаковка", "плитка", "банка", "стакан", "кілограм", "кіло",
            "один", "одна", "одне", "два", "дві", "три", "чотири", "п'ять",
            "шість", "сім", "вісім", "дев'ять", "девять", "десять"
        ]

        // strip trailing punctuation
        let stripped = lower.trimmingCharacters(in: .punctuationCharacters)

        return quantityWords.contains(stripped) || stripped.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil
    }

    // A small whitelist of known multi-word items that should never be split.
    // This can be expanded later or moved to user-editable storage.
    private var multiWordWhitelist: Set<String> {
        [
            "соняшникова олія",
            "олія оливкова",
            "захисні рукавички",
            "зубна паста",
            "пральний порошок"
        ]
    }

    private func containsSeparatorHint(_ text: String) -> Bool {
        let lowercasedText = text.lowercased()

        return lowercasedText.contains(",")
            || lowercasedText.contains(";")
            || lowercasedText.contains("/")
            || lowercasedText.contains("\n")
            || lowercasedText.contains(" та ")
            || lowercasedText.contains(" і ")
            || lowercasedText.contains(" й ")
    }

    private func removeLeadingCommandWords(from text: String) -> String {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        let commandPrefixes = [
            "додай",
            "додати",
            "добави",
            "добав",
            "добавь",
            "будь ласка"
        ]

        for prefix in commandPrefixes {
            guard let prefixRange = trimmedText.range(
                of: prefix,
                options: [.caseInsensitive, .anchored]
            ) else {
                continue
            }

            let remainder = String(trimmedText[prefixRange.upperBound...])
            if remainder.isEmpty || remainder.first?.isCommandSeparatorOrWhitespace == true {
                return stripLeadingDecoration(from: remainder)
            }
        }

        return stripLeadingDecoration(from: trimmedText)
    }

    private func stripLeadingDecoration(from text: String) -> String {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        let leadingCharacters = CharacterSet.whitespacesAndNewlines.union(
            CharacterSet(charactersIn: ":,-—–")
        )

        return trimmedText.trimmingCharacters(in: leadingCharacters)
    }

}

private extension Character {

    var isCommandSeparatorOrWhitespace: Bool {
        let scalar = unicodeScalars.first
        guard let scalar else { return false }

        return CharacterSet.whitespacesAndNewlines.contains(scalar)
            || CharacterSet(charactersIn: ":,-—–").contains(scalar)
    }

}
