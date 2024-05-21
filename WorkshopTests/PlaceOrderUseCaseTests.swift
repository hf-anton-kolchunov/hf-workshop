import FoodTruckKit
@testable import Workshop
import XCTest

final class PlaceOrderUseCaseTests: XCTestCase {
    var repository: OrdersRepository!
    var sut: PlaceOrderUseCase!

    override func setUp() {
        super.setUp()
        repository = OrdersRepository()
        sut = PlaceOrderUseCase(repository: repository)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testPlaceOrder() async throws {
        // Given
        let order: [Donut.ID: UInt] = [Donut.blackRaspberry.id: 2]

        // When
        try await sut.placeOrder(order)
        let result = await repository.orders.last

        // Then
        XCTAssertEqual(result?.donuts.map(\.id), order.keys.map { $0 })
    }
}
