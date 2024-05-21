/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The orders table.
*/

import SwiftUI
import Combine
import FoodTruckKit

final class OrdersViewModel: ObservableObject {

    @Published
    var orders: [Order]

    var repository: OrdersRepository?

    var cancellabels = Set<AnyCancellable>()

    init(orders: [Order] = []) {
        self.orders = orders
    }

    func fetchActiveOrders() {
        guard let repository = repository else { return }
        FetchActiveOrdersUseCase(repository: repository)
            .fetchActiveOrders()
            .sink { completion in
                return
            } receiveValue: { orders in
                self.orders = orders
            }
            .store(in: &cancellabels)

    }

}

struct OrdersTable: View {
    @ObservedObject var model: FoodTruckModel
    @EnvironmentObject var repository: OrdersRepository
    var viewModel = OrdersViewModel()

    @State private var sortOrder = [KeyPathComparator(\Order.status, order: .reverse)]
    @Binding var selection: Set<Order.ID>
    @Binding var completedOrder: Order?
    @Binding var searchText: String
    
    var orders: [Order] {
        viewModel.orders.filter { order in
            order.matches(searchText: searchText) || order.donuts.contains(where: { $0.matches(searchText: searchText) })
        }
        .sorted(using: sortOrder)
    }
    
    var body: some View {
        Table(selection: $selection, sortOrder: $sortOrder) {
            TableColumn("Order", value: \.id) { order in
                OrderRow(order: order)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .layoutPriority(1)
            }
            
            TableColumn("Donuts", value: \.totalSales) { order in
                Text(order.totalSales.formatted())
                    .monospacedDigit()
                    #if os(macOS)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .foregroundStyle(.secondary)
                    #endif
            }
            
            TableColumn("Status", value: \.status) { order in
                order.status.label
                    #if os(macOS)
                    .foregroundStyle(.secondary)
                    #endif
            }
            
            TableColumn("Date", value: \.creationDate) { order in
                Text(order.formattedDate)
                    #if os(macOS)
                    .foregroundStyle(.secondary)
                    #endif
            }
            
            TableColumn("Details") { order in
                Menu {
                    NavigationLink(value: order.id) {
                        Label("View Details", systemImage: "list.bullet.below.rectangle")
                    }
                    
                    if !order.isComplete {
                        Section {
                            Button {
//                                model.markOrderAsCompleted(id: order.id)
                                completedOrder = order
                            } label: {
                                Label("Complete Order", systemImage: "checkmark")
                            }
                        }
                    }
                } label: {
                    Label("Details", systemImage: "ellipsis.circle")
                        .labelStyle(.iconOnly)
                        .contentShape(Rectangle())
                }
                .menuStyle(.borderlessButton)
                .menuIndicator(.hidden)
                .fixedSize()
                .foregroundColor(.secondary)
            }
            .width(60)
        } rows: {
            Section {
                ForEach(orders) { order in
                    TableRow(order)
                }
            }
        }
        .onAppear(perform: {
            viewModel.repository = repository
            viewModel.fetchActiveOrders()
        })
    }
}

struct OrdersTable_Previews: PreviewProvider {
    
    @State private var sortOrder = [KeyPathComparator(\Order.status, order: .reverse)]
    
    struct Preview: View {
        @StateObject private var model = FoodTruckModel.preview
        @StateObject private var repository = OrdersRepository()

        var body: some View {
            OrdersTable(
                model: FoodTruckModel.preview,
                selection: .constant([]),
                completedOrder: .constant(nil),
                searchText: .constant("")
            )
        }
    }
    
    static var previews: some View {
        Preview()
    }
}

//struct OrdersTable_Previews: PreviewProvider {
//    static var previews: some View {
//        OrdersTable()
//    }
//}
