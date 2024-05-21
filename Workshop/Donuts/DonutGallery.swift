/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The donut gallery view.
*/

import SwiftUI
import FoodTruckKit

@MainActor
class CartModel: ObservableObject {
    @Published var order: [Donut.ID: UInt]

    init() {
        order = [:]
    }

    func add(_ donut: Donut) {
        order[donut.id, default: 0] += 1
        print("Added \(donut.name) | Current order: \(order)")
    }

    func remove(_ donut: Donut) {
        order[donut.id, default: 0] -= 1
        if order[donut.id] == 0 {
            order[donut.id] = nil
        }
        print("Removed \(donut.name) | Current order: \(order)")
    }

    func clear() {
        order = [:]
        print("Cleared order")
    }
}

struct DonutGallery: View {
    @ObservedObject var model: FoodTruckModel
    @EnvironmentObject var cartModel: CartModel
    var ordersRepository = OrdersRepository()

    @State private var layout = BrowserLayout.grid
    @State private var sort = DonutSortOrder.popularity(.week)
    @State private var popularityTimeframe = Timeframe.week
    @State private var sortFlavor = Flavor.sweet

    @State private var selection = Set<Donut.ID>()
    @State private var searchText = ""

    var filteredDonuts: [Donut] {
        model.donuts(sortedBy: sort).filter { $0.matches(searchText: searchText) }
    }

    var tableImageSize: Double {
        return 60
    }

    var body: some View {
        ZStack {
            if layout == .grid {
                grid
            } else {
                table
            }
        }
        .background()
        .toolbarRole(.browser)
        .toolbar {
            ToolbarItemGroup {
                toolbarItems
            }
        }
        .onChange(of: popularityTimeframe) { _, newValue in
            if case .popularity = sort {
                sort = .popularity(newValue)
            }
        }
        .onChange(of: sortFlavor) { _, newValue in
            if case .flavor = sort {
                sort = .flavor(newValue)
            }
        }
        .searchable(text: $searchText)
        .navigationTitle("Donuts")
        .navigationDestination(for: Donut.ID.self) { donutID in
            DonutEditor(donut: model.donutBinding(id: donutID))
        }
        .navigationDestination(for: String.self) { _ in
            DonutEditor(donut: $model.newDonut)
        }
    }

    var grid: some View {
        GeometryReader { geometryProxy in
            ScrollView {
                DonutGalleryGrid(donuts: filteredDonuts, width: geometryProxy.size.width)
            }
        }
    }

    var table: some View {
        Table(filteredDonuts, selection: $selection) {
            TableColumn("Name") { donut in
                NavigationLink(value: donut.id) {
                    HStack {
                        DonutView(donut: donut)
                            .frame(width: tableImageSize, height: tableImageSize)

                        Text(donut.name)
                    }
                }
            }
        }
    }

    @ViewBuilder
    var toolbarItems: some View {
        Button {
            cartModel.clear()
        } label: {
            Label("Place order", systemImage: "cart")
        }

        Menu {
            Picker("Layout", selection: $layout) {
                ForEach(BrowserLayout.allCases) { option in
                    Label(option.title, systemImage: option.imageName)
                        .tag(option)
                }
            }
            .pickerStyle(.inline)

            Picker("Sort", selection: $sort) {
                Label("Name", systemImage: "textformat")
                    .tag(DonutSortOrder.name)
                Label("Popularity", systemImage: "trophy")
                    .tag(DonutSortOrder.popularity(popularityTimeframe))
                Label("Flavor", systemImage: "fork.knife")
                    .tag(DonutSortOrder.flavor(sortFlavor))
            }
            .pickerStyle(.inline)

            if case .popularity = sort {
                Picker("Timeframe", selection: $popularityTimeframe) {
                    Text("Today")
                        .tag(Timeframe.today)
                    Text("Week")
                        .tag(Timeframe.week)
                    Text("Month")
                        .tag(Timeframe.month)
                    Text("Year")
                        .tag(Timeframe.year)
                }
                .pickerStyle(.inline)
            } else if case .flavor = sort {
                Picker("Flavor", selection: $sortFlavor) {
                    ForEach(Flavor.allCases) { flavor in
                        Text(flavor.name)
                            .tag(flavor)
                    }
                }
                .pickerStyle(.inline)
            }
        } label: {
            Label("Layout Options", systemImage: layout.imageName)
                .labelStyle(.iconOnly)
        }
    }
}

enum BrowserLayout: String, Identifiable, CaseIterable {
    case grid
    case list

    var id: String {
        rawValue
    }

    var title: LocalizedStringKey {
        switch self {
        case .grid: return "Icons"
        case .list: return "List"
        }
    }

    var imageName: String {
        switch self {
        case .grid: return "square.grid.2x2"
        case .list: return "list.bullet"
        }
    }
}

struct DonutBakery_Previews: PreviewProvider {
    struct Preview: View {
        @StateObject private var model = FoodTruckModel.preview
        @StateObject private var cartModel = CartModel()

        var body: some View {
            DonutGallery(model: model)
        }
    }

    static var previews: some View {
        NavigationStack {
            Preview()
        }
    }
}
