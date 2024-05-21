import FoodTruckKit
import SwiftUI

@main
struct WorkshopApp: App {
    @StateObject private var foodTruckModel = FoodTruckModel()
    @StateObject private var cartModel = CartModel()
    @StateObject private var repository = OrdersRepository()

    var body: some Scene {
        WindowGroup {
            ContentView(model: foodTruckModel, cartModel: cartModel)
        }
        .environmentObject(repository)
        .environmentObject(cartModel)
    }
}
