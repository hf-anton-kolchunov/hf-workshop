import FoodTruckKit

struct AlternativePlaceOrderUseCase {
    let repository: OrdersRepository

    /**
     Task: Update implementation of this function and repository call to pass
     existing tests.
     */
    func placeOrder(_ order: [Donut.ID: UInt]) -> Task<Order, Never> {
        Task {
            await repository.alternativePlaceOrder(order)
        }
    }
}
