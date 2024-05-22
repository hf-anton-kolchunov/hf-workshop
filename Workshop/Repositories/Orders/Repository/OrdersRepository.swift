import Combine
import FoodTruckKit
import Foundation
import SwiftUI

actor OrdersRepository: ObservableObject {
    var currentInvoiceNumber: Int = 24
    let orderGenerator = OrderGenerator()
    let networkService = SomeNetworkService()

    @Published
    var orders: [Order] = {
        let generator = OrderGenerator()
        return generator.todaysOrders()
    }()

    init() { /* Empty initializer */ }

    func placeOrder(_ sales: [Donut.ID: UInt]) -> Order {
        let number = nextNumber()
        return placeOrder(sales, number: number)
    }

    func placeOrder(_ sales: [Donut.ID: UInt], number: Int) -> Order {
        let donuts = Donut.all.filter { sales.keys.contains($0.id) }
        let order = orderGenerator.generateOrder(
            number: number,
            date: Date(),
            donuts: donuts,
            sales: sales.mapValues { Int($0) }
        )
        orders.append(order)
        return order
    }

    func alternativePlaceOrder(_ sales: [Donut.ID: UInt]) async -> Order {
        // !!! Order of the execution should be preserved !!!
        let number = currentInvoiceNumber
        let order = placeOrder(sales, number: number)
        await networkService.performNetworkRequest()
        currentInvoiceNumber += 1
        return order
    }

    func fetchActiveOrders() -> [Order] {
        orders
    }

    func getHistoricalOrders(since: Date) throws -> [OrderSummary] {
        orderGenerator.historicalDailyOrders(
            since: since,
            cityID: City.sanFrancisco.id
        )
    }

    func nextNumber() -> Int {
        currentInvoiceNumber += 1
        return currentInvoiceNumber
    }
}


final class SomeNetworkService {
    func performNetworkRequest() async {
        _ = await Task.detached {
            try? await Task.sleep(nanoseconds: 1_000_000 * UInt64.random(in: 1..<5))
        }.value
    }
}
