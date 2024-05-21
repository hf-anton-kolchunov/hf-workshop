import FoodTruckKit
import Foundation

struct GetHistoricalOrdersUseCase {
    let repository: OrdersRepository

    /**
     Task: Implement function to use `repository` to fetch data about
     all historical orders. This function uses completion block to return
     value wrapped in `Result<[Order], Error>`.
     */
    func getHistoricalOrders(
        since date: Date = (Date() - 5),
        _ completionQueue: DispatchQueue = .main,
        completionBlock: @escaping (Result<[[Donut.ID: Int]], Error>) -> Void
    ) {
        fatalError("To implement")
    }
}
