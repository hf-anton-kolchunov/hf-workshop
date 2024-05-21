import FoodTruckKit
import Foundation
@testable import Workshop
import XCTest

final class GetHistoricalOrdersUseCaseTests: XCTestCase {
    var repository: OrdersRepository!
    var sut: GetHistoricalOrdersUseCase!

    override func setUp() {
        super.setUp()
        repository = OrdersRepository()
        sut = GetHistoricalOrdersUseCase(repository: repository)
    }

    override func tearDown() {
        sut = nil
        repository = nil
        super.tearDown()
    }

    func testGetHistoricalOrdersUseCase() async {
        // Implement me
    }
}
