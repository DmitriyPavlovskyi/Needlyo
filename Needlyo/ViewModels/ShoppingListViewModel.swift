import Observation
import Foundation

@Observable
@MainActor
final class ShoppingListViewModel {

    var items: [ShoppingItem] = []
    var searchText = ""
    var dictatedText = ""
    var isListening = false
    var errorMessage: String?
    private var dictatedSnapshot: SpeechRecognitionSnapshot?

    private let speechRecognitionService: SpeechRecognitionService

    var visibleItems: [ShoppingItem] {
        let trimmedSearchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedSearchText.isEmpty else {
            return items
        }

        return items.filter { item in
            item.title.localizedCaseInsensitiveContains(trimmedSearchText)
        }
    }

    init(speechRecognitionService: SpeechRecognitionService? = nil) {
        self.speechRecognitionService = speechRecognitionService ?? SpeechRecognitionService()
    }

    func toggleListening() async {
        if isListening {
            finishListening()
            return
        }

        let isAuthorized = await speechRecognitionService.requestAuthorization()

        guard isAuthorized else {
            errorMessage = "Please allow microphone and speech recognition access in Settings."
            return
        }

        do {
            dictatedText = ""
            dictatedSnapshot = nil
            errorMessage = nil

            isListening = true

            try speechRecognitionService.startRecognition { [weak self] snapshot in
                self?.dictatedText = snapshot.text
                self?.dictatedSnapshot = snapshot
            } onFinish: { [weak self] in
                self?.finishListening()
            }
        } catch {
            errorMessage = error.localizedDescription
            isListening = false
        }
    }

    func toggleCompletion(for item: ShoppingItem) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else {
            return
        }

        items[index].isCompleted.toggle()
    }

    func deleteItems(at offsets: IndexSet) {
        let idsToDelete = offsets.map { visibleItems[$0].id }
        items.removeAll { item in
            idsToDelete.contains(item.id)
        }
    }

    private func finishListening() {
        guard isListening else {
            return
        }

        speechRecognitionService.stopRecognition()
        appendItems(from: dictatedSnapshot)
        dictatedText = ""
        dictatedSnapshot = nil
        isListening = false
    }

    private func appendItems(from snapshot: SpeechRecognitionSnapshot?) {
        let titles = parsedItemTitles(from: snapshot)

        guard !titles.isEmpty else {
            return
        }

        items.append(contentsOf: titles.map { ShoppingItem(title: $0) })
    }

    private func parsedItemTitles(from snapshot: SpeechRecognitionSnapshot?) -> [String] {
        guard let snapshot else {
            return []
        }

        let pauseSeparatedChunks = chunks(from: snapshot.segments)
        let sourceHasSeparatorHint = containsSeparatorHint(snapshot.text)

        return pauseSeparatedChunks.flatMap { chunk in
            normalizedItemTitles(
                from: chunk,
                sourceHasSeparatorHint: sourceHasSeparatorHint
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
        sourceHasSeparatorHint: Bool
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

        if sourceHasSeparatorHint {
            return explicitParts.flatMap { part in
                splitLooseItemCandidate(part)
            }
        }

        return explicitParts
    }

    private func splitLooseItemCandidate(_ candidate: String) -> [String] {
        let words = candidate
            .components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }

        guard words.count > 1 else {
            return [candidate]
        }

        return words
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
            "додай ",
            "додати ",
            "добав ",
            "добавь ",
            "будь ласка "
        ]

        for prefix in commandPrefixes {
            if trimmedText.localizedCaseInsensitiveHasPrefix(prefix) {
                return String(trimmedText.dropFirst(prefix.count))
            }
        }

        return trimmedText
    }

}

private extension String {

    func localizedCaseInsensitiveHasPrefix(_ prefix: String) -> Bool {
        range(
            of: prefix,
            options: [.caseInsensitive, .anchored]
        ) != nil
    }

}
