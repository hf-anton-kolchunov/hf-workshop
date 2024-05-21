import FoodTruckKit

struct PlaceOrderUseCase {
    let repository: OrdersRepository
    
    /**
     Task: Implement this function to use `repository` to execute request
     of placing order by using `placeOrder` function of the `OrdersRepository`.
     */
    func placeOrder(_ order: [Donut.ID: UInt]) async throws {
    
    }
}
