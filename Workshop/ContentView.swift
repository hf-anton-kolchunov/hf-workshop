import SwiftUI
import FoodTruckKit

struct ContentView: View {
    var model: FoodTruckModel
    var cartModel: CartModel

    @State private var selection: Panel? = Panel.donuts
    @State private var path = NavigationPath()

    var body: some View {
        NavigationSplitView {
            Sidebar(selection: $selection)
        } detail: {
            NavigationStack(path: $path) {
                DetailColumn(selection: $selection, model: model)
            }
        }
        .onChange(of: selection) { _, _ in
            path.removeLast(path.count)
        }

//
//        NavigationStack {
////            DonutGallery(model: foodTruckModel, cartModel: cartModel)
//            OrdersTable(
//                model: foodTruckModel,
//                selection: .constant([]),
//                completedOrder: .constant(nil),
//                searchText: .constant("")
//            )
//        }
    }
}

#Preview {
    ContentView(model: FoodTruckModel(), cartModel: CartModel())
}
