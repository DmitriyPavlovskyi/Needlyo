import XCTest
@testable import Needlyo

final class ShoppingItemParsingServiceTests: XCTestCase {

    private let service = ShoppingItemParsingService()

    func testParsesMultipleItemsFromSeparatorRichSpeech() {
        let snapshot = makeSnapshot(text: "додай молоко, хліб і яйця")

        XCTAssertEqual(service.parseItemTitles(from: snapshot), ["молоко", "хліб", "яйця"])
    }

    func testParsesCommandWithPunctuationAfterPrefix() {
        let snapshot = makeSnapshot(text: "добавь: молоко, хліб; сир")

        XCTAssertEqual(service.parseItemTitles(from: snapshot), ["молоко", "хліб", "сир"])
    }

    func testKeepsCompoundDescriptorAsSingleItem() {
        let snapshot = makeSnapshot(text: "додай чорний хліб")

        XCTAssertEqual(service.parseItemTitles(from: snapshot), ["чорний хліб"])
    }

    func testSplitsByPauseSeparatedSegments() {
        let snapshot = SpeechRecognitionSnapshot(
            text: "молоко хліб яйця",
            segments: [
                SpeechRecognitionSegment(text: "молоко", timestamp: 0.0, duration: 0.1),
                SpeechRecognitionSegment(text: "хліб", timestamp: 0.7, duration: 0.1),
                SpeechRecognitionSegment(text: "яйця", timestamp: 1.4, duration: 0.1)
            ]
        )

        XCTAssertEqual(service.parseItemTitles(from: snapshot), ["молоко", "хліб", "яйця"])
    }

    func testReturnsEmptyArrayForEmptySnapshot() {
        let snapshot = SpeechRecognitionSnapshot(text: "", segments: [])

        XCTAssertEqual(service.parseItemTitles(from: snapshot), [])
    }

    private func makeSnapshot(text: String) -> SpeechRecognitionSnapshot {
        SpeechRecognitionSnapshot(
            text: text,
            segments: [SpeechRecognitionSegment(text: text, timestamp: 0, duration: 1)]
        )
    }

}
