import Observation
import Foundation

@Observable
@MainActor
final class ShoppingListViewModel {

    var items: [ShoppingItem] = []
    var dictatedText = ""
    var isListening = false
    var errorMessage: String?
    private var dictatedSnapshot: SpeechRecognitionSnapshot?
    private var recognitionStartTask: Task<Void, Never>?

    private let speechRecognitionService: SpeechRecognitionService
    private let persistenceService: ShoppingListPersistenceService
    private let itemParsingService: ShoppingItemParsingService

    var visibleItems: [ShoppingItem] {
        items
    }

    init(
        speechRecognitionService: SpeechRecognitionService? = nil,
        persistenceService: ShoppingListPersistenceService? = nil,
        itemParsingService: ShoppingItemParsingService? = nil
    ) {
        self.speechRecognitionService = speechRecognitionService ?? SpeechRecognitionService()
        self.persistenceService = persistenceService ?? UserDefaultsShoppingListPersistenceService()
        self.itemParsingService = itemParsingService ?? ShoppingItemParsingService()
        self.items = self.persistenceService.loadItems()
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

        dictatedText = ""
        dictatedSnapshot = nil
        errorMessage = nil

        isListening = true

        recognitionStartTask?.cancel()
        let speechRecognitionService = self.speechRecognitionService

        recognitionStartTask = Task(priority: .userInitiated) { [weak self] in
            guard let self else { return }
            guard !Task.isCancelled else { return }

            do {
                try speechRecognitionService.startRecognition { [weak self] snapshot in
                    self?.dictatedText = snapshot.text
                    self?.dictatedSnapshot = snapshot
                } onFinish: { [weak self] in
                    self?.finishListening()
                }
            } catch {
                guard !Task.isCancelled else { return }

                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isListening = false
                    self.recognitionStartTask = nil
                }
            }
        }
    }

    func toggleCompletion(for item: ShoppingItem) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else {
            return
        }

        items[index].isCompleted.toggle()
        persistItems()
    }

    func deleteItems(at offsets: IndexSet) {
        let idsToDelete = offsets.map { visibleItems[$0].id }
        items.removeAll { item in
            idsToDelete.contains(item.id)
        }
        persistItems()
    }

    private func finishListening() {
        guard isListening else {
            return
        }

        recognitionStartTask?.cancel()
        recognitionStartTask = nil
        speechRecognitionService.stopRecognition()
        appendItems(from: dictatedSnapshot)
        dictatedText = ""
        dictatedSnapshot = nil
        isListening = false
    }

    private func appendItems(from snapshot: SpeechRecognitionSnapshot?) {
        let titles = itemParsingService.parseItemTitles(from: snapshot)

        guard !titles.isEmpty else {
            return
        }

        items.append(contentsOf: titles.map { ShoppingItem(title: $0) })
        persistItems()
    }

    private func persistItems() {
        persistenceService.saveItems(items)
    }

}