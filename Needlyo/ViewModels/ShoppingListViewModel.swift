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

    private let speechRecognitionService: any SpeechRecognitionServicing
    private let persistenceService: ShoppingListPersistenceService
    private let itemParsingService: ShoppingItemParsingService

    var visibleItems: [ShoppingItem] {
        items
    }

    init(
        speechRecognitionService: (any SpeechRecognitionServicing)? = nil,
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

    func updateTitle(for item: ShoppingItem, to newTitle: String) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else {
            return
        }

        let trimmedTitle = newTitle.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedTitle.isEmpty else {
            return
        }

        guard items[index].title != trimmedTitle else {
            return
        }

        items[index].title = trimmedTitle
        persistItems()
    }

    func deleteItems(at offsets: IndexSet) {
        let idsToDelete = offsets.map { visibleItems[$0].id }
        items.removeAll { item in
            idsToDelete.contains(item.id)
        }
        persistItems()
    }

    func clearAllItems() {
        guard !items.isEmpty else {
            return
        }

        items.removeAll()
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

        var existingNormalizedTitles = Set(items.map { normalizedTitle(for: $0.title) })
        let newItems = titles.compactMap { title -> ShoppingItem? in
            let normalizedTitle = normalizedTitle(for: title)

            guard !normalizedTitle.isEmpty, !existingNormalizedTitles.contains(normalizedTitle) else {
                return nil
            }

            existingNormalizedTitles.insert(normalizedTitle)
            return ShoppingItem(title: title)
        }

        guard !newItems.isEmpty else {
            return
        }

        items.append(contentsOf: newItems)
        persistItems()
    }

    private func normalizedTitle(for title: String) -> String {
        title
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
    }

    private func persistItems() {
        persistenceService.saveItems(items)
    }

}