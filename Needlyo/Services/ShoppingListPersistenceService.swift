import Foundation

protocol ShoppingListPersistenceService {
    func loadItems() -> [ShoppingItem]
    func saveItems(_ items: [ShoppingItem])
}

final class UserDefaultsShoppingListPersistenceService: ShoppingListPersistenceService {

    private let userDefaults: UserDefaults
    private let storageKey: String

    init(
        userDefaults: UserDefaults = .standard,
        storageKey: String = "shopping_list_items_v1"
    ) {
        self.userDefaults = userDefaults
        self.storageKey = storageKey
    }

    func loadItems() -> [ShoppingItem] {
        guard let data = userDefaults.data(forKey: storageKey) else {
            return []
        }

        do {
            return try JSONDecoder().decode([ShoppingItem].self, from: data)
        } catch {
            return []
        }
    }

    func saveItems(_ items: [ShoppingItem]) {
        do {
            let data = try JSONEncoder().encode(items)
            userDefaults.set(data, forKey: storageKey)
        } catch {
            // Intentionally ignore persistence failures to keep the UI responsive.
        }
    }

}
