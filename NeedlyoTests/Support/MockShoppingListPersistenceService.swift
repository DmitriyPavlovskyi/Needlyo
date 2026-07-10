import Foundation
@testable import Needlyo

final class MockShoppingListPersistenceService: ShoppingListPersistenceService {

    var itemsToLoad: [ShoppingItem]
    private(set) var savedItems: [[ShoppingItem]] = []

    init(itemsToLoad: [ShoppingItem] = []) {
        self.itemsToLoad = itemsToLoad
    }

    func loadItems() -> [ShoppingItem] {
        itemsToLoad
    }

    func saveItems(_ items: [ShoppingItem]) {
        savedItems.append(items)
    }

    var lastSavedItems: [ShoppingItem]? {
        savedItems.last
    }

}
