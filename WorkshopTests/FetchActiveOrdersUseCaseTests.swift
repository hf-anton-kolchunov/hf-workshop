import Combine
import FoodTruckKit
@testable import Workshop
import XCTest

final class FetchActiveOrdersUseCaseTests: XCTestCase {
    var repository: OrdersRepository!
    var sut: FetchActiveOrdersUseCase!

    var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        repository = OrdersRepository()
        sut = FetchActiveOrdersUseCase(repository: repository)
    }

    override func tearDown() {
        sut = nil
        repository = nil
        cancellables.removeAll()
        super.tearDown()
    }

    func testFetchActiveOrders() async {
        // Implement me
    }
}
