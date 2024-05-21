import FoodTruckKit
@testable import Workshop
import XCTest

final class AlternativePlaceOrderUseCaseTests: XCTestCase {
    var repository: OrdersRepository!
    var sut: AlternativePlaceOrderUseCase!

    override func setUp() {
        super.setUp()
        repository = OrdersRepository()
        sut = AlternativePlaceOrderUseCase(repository: repository)
    }

    override func tearDown() {
        sut = nil
        repository = nil
        super.tearDown()
    }

    func testPlaceOrderInParallel() async throws {
        // Given
        let order: [Donut.ID: UInt] = [Donut.blackRaspberry.id: 2]

        // WHen
        let task1 = sut.placeOrder(order)
        let task2 = sut.placeOrder(order)
        let (result1, result2) = await (task1.value, task2.value)

        XCTAssertNotEqual(result1.id, result2.id)
    }
}
