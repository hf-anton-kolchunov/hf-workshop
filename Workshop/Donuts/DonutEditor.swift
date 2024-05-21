/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The donut editor view.
*/

import SwiftUI
import FoodTruckKit

struct DonutEditor: View {
    @Binding var donut: Donut
    @EnvironmentObject var cartModel: CartModel

    var body: some View {
        ZStack {
            WidthThresholdReader { proxy in
                if proxy.isCompact {
                    Form {
                        donutViewer
                        editorContent
                    }
                } else {
                    HStack(spacing: 0) {
                        donutViewer
                        Divider().ignoresSafeArea()
                        Form {
                            editorContent
                        }
                        .formStyle(.grouped)
                        .frame(width: 350)
                    }
                }
            }
        }
        .toolbar {
            ToolbarTitleMenu {
                Button {
                    cartModel.add(donut)
                } label: {
                    Label("Add to cart", systemImage: "plus.circle")
                }
                Button {
                    cartModel.remove(donut)
                } label: {
                    Label("Remove from", systemImage: "minus.circle")
                }
            }
        }
        .navigationTitle(donut.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarRole(.editor)
        // We don't want store messages to interrupt any donut editing.
        .storeMessagesDeferred(true)
    }

    var donutViewer: some View {
        DonutView(donut: donut)
            .frame(minWidth: 100, maxWidth: .infinity, minHeight: 100, maxHeight: .infinity)
            .listRowInsets(.init())
            .padding(.horizontal, 40)
            .padding(.vertical)
            .background()
    }

    @ViewBuilder
    var editorContent: some View {
        Section("Donut") {
            TextField("Name", text: $donut.name, prompt: Text("Donut Name"))
        }

        Section("Flavor Profile") {
            Grid {
                let (topFlavor, topFlavorValue) = donut.flavors.mostPotent
                ForEach(Flavor.allCases) { flavor in
                    let isTopFlavor = topFlavor == flavor
                    let flavorValue = max(donut.flavors[flavor], 0)
                    GridRow {
                        flavor.image
                            .foregroundStyle(isTopFlavor ? .primary : .secondary)

                        Text(flavor.name)
                            .gridCellAnchor(.leading)
                            .foregroundStyle(isTopFlavor ? .primary : .secondary)

                        Gauge(value: Double(flavorValue), in: 0...Double(topFlavorValue)) {
                            EmptyView()
                        }
                        .tint(isTopFlavor ? Color.accentColor : Color.secondary)
                        .labelsHidden()

                        Text(flavorValue.formatted())
                            .gridCellAnchor(.trailing)
                            .foregroundStyle(isTopFlavor ? .primary : .secondary)
                    }
                }
            }
        }
        /*
        Section("Ingredients") {
            Picker("Dough", selection: $donut.dough) {
                ForEach(Donut.Dough.all) { dough in
                    Text(dough.name)
                        .tag(dough)
                }
            }

            Picker("Glaze", selection: $donut.glaze) {
                Section {
                    Text("None")
                        .tag(nil as Donut.Glaze?)
                }
                ForEach(Donut.Glaze.all) { glaze in
                    Text(glaze.name)
                        .tag(glaze as Donut.Glaze?)
                }
            }

            Picker("Topping", selection: $donut.topping) {
                Section {
                    Text("None")
                        .tag(nil as Donut.Topping?)
                }
                Section {
                    ForEach(Donut.Topping.other) { topping in
                        Text(topping.name)
                            .tag(topping as Donut.Topping?)
                    }
                }
                Section {
                    ForEach(Donut.Topping.lattices) { topping in
                        Text(topping.name)
                            .tag(topping as Donut.Topping?)
                    }
                }
                Section {
                    ForEach(Donut.Topping.lines) { topping in
                        Text(topping.name)
                            .tag(topping as Donut.Topping?)
                    }
                }
                Section {
                    ForEach(Donut.Topping.drizzles) { topping in
                        Text(topping.name)
                            .tag(topping as Donut.Topping?)
                    }
                }
            }
        }
        */
    }
}

struct DonutEditor_Previews: PreviewProvider {
    struct Preview: View {
        @State private var donut = Donut.preview
        @StateObject private var cartModel = CartModel()

        var body: some View {
            DonutEditor(donut: $donut)
        }
    }

    static var previews: some View {
        NavigationStack {
            Preview()
        }
    }
}
