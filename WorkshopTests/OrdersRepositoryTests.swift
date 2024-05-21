import FoodTruckKit
@testable import Workshop
import XCTest

final class OrdersRepositoryTests: XCTestCase {
    var sut: OrdersRepository!

    override func setUp() {
        super.setUp()
        sut = OrdersRepository()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testPlaceOrder() async {
        // Given
        let order: [Donut.ID: UInt] = [Donut.blackRaspberry.id: 2]

        // When
        let result = await sut.placeOrder(order)

        // Then
        XCTAssertEqual(result.donuts.map(\.id), order.keys.map { $0 })
    }
}
