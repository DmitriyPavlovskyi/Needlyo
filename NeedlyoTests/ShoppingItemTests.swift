import XCTest
@testable import Needlyo

final class ShoppingItemTests: XCTestCase {

    func testItemEncodesAndDecodes() throws {
        let item = ShoppingItem(title: "молоко", isCompleted: true)
        let encoded = try JSONEncoder().encode(item)
        let decoded = try JSONDecoder().decode(ShoppingItem.self, from: encoded)

        XCTAssertEqual(decoded, item)
    }

    func testEqualityUsesAllStoredProperties() {
        let base = ShoppingItem(id: UUID(), title: "хліб", isCompleted: false)
        let same = ShoppingItem(id: base.id, title: "хліб", isCompleted: false)
        let different = ShoppingItem(id: base.id, title: "хліб", isCompleted: true)

        XCTAssertEqual(base, same)
        XCTAssertNotEqual(base, different)
    }

}
