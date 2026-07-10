import XCTest
@testable import Needlyo

final class ShoppingListPersistenceServiceTests: XCTestCase {

    private var suiteName = "NeedlyoTests.UserDefaults.\(UUID().uuidString)"

    override func tearDown() {
        UserDefaults.standard.removePersistentDomain(forName: suiteName)
        UserDefaults(suiteName: suiteName)?.removePersistentDomain(forName: suiteName)
        super.tearDown()
    }

    func testSaveAndLoadRoundTrip() throws {
        let defaults = try makeUserDefaults()
        let service = UserDefaultsShoppingListPersistenceService(
            userDefaults: defaults,
            storageKey: "items"
        )
        let items = [
            ShoppingItem(title: "молоко"),
            ShoppingItem(title: "хліб", isCompleted: true)
        ]

        service.saveItems(items)

        XCTAssertEqual(service.loadItems(), items)

        let newService = UserDefaultsShoppingListPersistenceService(
            userDefaults: defaults,
            storageKey: "items"
        )
        XCTAssertEqual(newService.loadItems(), items)
    }

    func testLoadReturnsEmptyArrayForInvalidStoredData() throws {
        let defaults = try makeUserDefaults()
        defaults.set(Data([0x00, 0x01, 0x02]), forKey: "items")

        let service = UserDefaultsShoppingListPersistenceService(
            userDefaults: defaults,
            storageKey: "items"
        )

        XCTAssertEqual(service.loadItems(), [])
    }

    private func makeUserDefaults() throws -> UserDefaults {
        guard let defaults = UserDefaults(suiteName: suiteName) else {
            throw NSError(domain: "NeedlyoTests", code: 1)
        }
        defaults.removePersistentDomain(forName: suiteName)
        return defaults
    }

}
