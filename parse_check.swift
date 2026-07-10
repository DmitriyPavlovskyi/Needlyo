import Foundation

@main
struct ParseCheckRunner {

    static func main() {
        let service = ShoppingItemParsingService()

        let samples: [(String, [String])] = [
            ("додай молоко хліб яйця", ["молоко", "хліб", "яйця"]),
            ("додай молоко, хліб і яйця", ["молоко", "хліб", "яйця"]),
            ("додай чорний хліб", ["чорний хліб"]),
            ("додай куряче філе та рис", ["куряче філе", "рис"])
        ]

        for (input, expected) in samples {
            let snapshot = SpeechRecognitionSnapshot(
                text: input,
                segments: [SpeechRecognitionSegment(text: input, timestamp: 0, duration: 1)]
            )
            let result = service.parseItemTitles(from: snapshot)
            print("INPUT: \(input)")
            print("RESULT: \(result)")
            print("EXPECTED: \(expected)")
            print(result == expected ? "PASS" : "FAIL")
            print("---")
        }
    }

}
