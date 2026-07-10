import Foundation
import XCTest
@testable import Needlyo

@MainActor
final class ShoppingListViewModelTests: XCTestCase {

    func testLoadsInitialItemsFromPersistence() {
        let initialItems = [ShoppingItem(title: "молоко")]
        let persistence = MockShoppingListPersistenceService(itemsToLoad: initialItems)

        let viewModel = ShoppingListViewModel(
            persistenceService: persistence,
            itemParsingService: ShoppingItemParsingService()
        )

        XCTAssertEqual(viewModel.visibleItems, initialItems)
    }

    func testToggleListeningRequestsAuthorizationBeforeStarting() async {
        let speech = MockSpeechRecognitionService()
        speech.authorizationResult = false
        let viewModel = ShoppingListViewModel(
            speechRecognitionService: speech,
            persistenceService: MockShoppingListPersistenceService(),
            itemParsingService: ShoppingItemParsingService()
        )

        await viewModel.toggleListening()

        XCTAssertEqual(speech.startRecognitionCallCount, 0)
        XCTAssertEqual(viewModel.errorMessage, "Please allow microphone and speech recognition access in Settings.")
    }

    func testToggleListeningAppendsParsedItemsWhenRecognitionFinishes() async {
        let speech = MockSpeechRecognitionService()
        speech.snapshotToDeliver = SpeechRecognitionSnapshot(
            text: "додай молоко, хліб і яйця",
            segments: [SpeechRecognitionSegment(text: "додай молоко, хліб і яйця", timestamp: 0, duration: 1)]
        )
        let persistence = MockShoppingListPersistenceService()
        let viewModel = ShoppingListViewModel(
            speechRecognitionService: speech,
            persistenceService: persistence,
            itemParsingService: ShoppingItemParsingService()
        )

        await viewModel.toggleListening()
        await waitForCondition {
            speech.stopRecognitionCallCount == 1
        }

        XCTAssertEqual(viewModel.visibleItems.map(\.title), ["молоко", "хліб", "яйця"])
        XCTAssertEqual(persistence.lastSavedItems?.map(\.title), ["молоко", "хліб", "яйця"])
        XCTAssertEqual(speech.startRecognitionCallCount, 1)
        XCTAssertEqual(speech.stopRecognitionCallCount, 1)
    }

    func testToggleCompletionUpdatesItemAndPersists() {
        let item = ShoppingItem(title: "молоко")
        let persistence = MockShoppingListPersistenceService(itemsToLoad: [item])
        let viewModel = ShoppingListViewModel(
            persistenceService: persistence,
            itemParsingService: ShoppingItemParsingService()
        )

        viewModel.toggleCompletion(for: item)

        XCTAssertEqual(viewModel.visibleItems.first?.isCompleted, true)
        XCTAssertEqual(persistence.lastSavedItems?.first?.isCompleted, true)
    }

    func testDeleteItemsRemovesCorrectRowAndPersists() {
        let items = [ShoppingItem(title: "молоко"), ShoppingItem(title: "хліб")]
        let persistence = MockShoppingListPersistenceService(itemsToLoad: items)
        let viewModel = ShoppingListViewModel(
            persistenceService: persistence,
            itemParsingService: ShoppingItemParsingService()
        )

        viewModel.deleteItems(at: IndexSet(integer: 0))

        XCTAssertEqual(viewModel.visibleItems.map(\.title), ["хліб"])
        XCTAssertEqual(persistence.lastSavedItems?.map(\.title), ["хліб"])
    }

    func testVisibleItemsReflectsCurrentItemsArray() {
        let persistence = MockShoppingListPersistenceService(itemsToLoad: [])
        let viewModel = ShoppingListViewModel(
            persistenceService: persistence,
            itemParsingService: ShoppingItemParsingService()
        )

        viewModel.items = [ShoppingItem(title: "молоко")]

        XCTAssertEqual(viewModel.visibleItems.map(\.title), ["молоко"])
    }

    func testFinishListeningWithNoSnapshotDoesNotAppendItems() async {
        let speech = MockSpeechRecognitionService()
        speech.snapshotToDeliver = nil
        let persistence = MockShoppingListPersistenceService()
        let viewModel = ShoppingListViewModel(
            speechRecognitionService: speech,
            persistenceService: persistence,
            itemParsingService: ShoppingItemParsingService()
        )

        await viewModel.toggleListening()
        await waitForCondition {
            speech.stopRecognitionCallCount == 1
        }

        XCTAssertEqual(viewModel.visibleItems, [])
        XCTAssertEqual(persistence.savedItems.count, 0)
    }

    private func waitForCondition(
        timeout: TimeInterval = 1,
        condition: @escaping () -> Bool
    ) async {
        let deadline = Date().addingTimeInterval(timeout)

        while Date() < deadline {
            if condition() {
                return
            }

            await Task.yield()
        }

        XCTFail("Timed out waiting for the recognition flow to finish.")
    }

}
