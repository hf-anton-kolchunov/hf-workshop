import Combine
import FoodTruckKit

struct FetchActiveOrdersUseCase {
    let repository: OrdersRepository

    /**
     Task: Implement function to use `repository` to fetch data about
     all active orders. This function should return publisher, which emits
     value once and ends after that.
     */
    func fetchActiveOrders() -> AnyPublisher<[Order], any Error> {
        fatalError("To implement")
    }
}
