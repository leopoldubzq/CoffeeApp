import SwiftUI

struct MenuItemPreview: View {
    
    @StateObject private var viewModel = MenuItemPreviewViewModel()
    @Binding var coffeePreviewVisible: Bool
    @State private var scrollOffsetY: CGFloat = 0
    @State private var headerHeight: CGFloat = 0
    @State private var userInteractionEnabled: Bool = true
    var coffee: CoffeeDto
    var coffeeImageNamespace: Namespace.ID
    var coffeeTitleNamespace: Namespace.ID
    var coffeePriceNamespace: Namespace.ID
    
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .center, spacing: 0) {
                HStack {
                    Spacer()
                    CancelButton()
                }
                .padding()
                .overlay(alignment: .center) {
                    Text("Zamówienie")
                        .fontWeight(.semibold)
                }
                
                ScrollView {
                    LazyVStack(pinnedViews: [.sectionHeaders]) {
                        Section {
                            TagLayout(alignment: .leading) {
                                ForEach(viewModel.selectedCoffeeAccessories, id: \.uid ) { accessory in
                                    SelectedCoffeeAccessoryButton(accessory: accessory) {
                                        blockUserInteraction()
                                        withAnimation(.snappy(duration: 0.35, extraBounce: 0.1)) {
                                            viewModel.selectedCoffeeAccessories.removeAll(where: { $0.title == accessory.title })
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, viewModel.selectedCoffeeAccessories.isEmpty ? 0 : 8)
                            .allowsHitTesting(userInteractionEnabled)
                            if !getCoffeeAccessories().isEmpty {
                                SectionText(title: "Dodatki", paddingTop: 0)
                                ForEach(getCoffeeAccessories(), id: \.uid) { accessory in
                                    CoffeeAccessoryButton(title: accessory.title,
                                                          extraPrice: accessory.extraPrice) {
                                        blockUserInteraction()
                                        withAnimation(.snappy(duration: 0.35, extraBounce: 0.08)) {
                                            viewModel.performCoffeeAccessoryAction(for: accessory)
                                        }
                                    }
                                    .padding(.horizontal)
                                    .allowsHitTesting(userInteractionEnabled)
                                }
                            }
                            if !getCoffeeSubstitutes().isEmpty {
                                SectionText(title: "Zamienniki", paddingTop: 16)
                                ForEach(getCoffeeSubstitutes(), id: \.uid) { substitute in
                                    CoffeeAccessoryButton(title: substitute.title,
                                                          extraPrice: substitute.extraPrice) {
                                        withAnimation(.snappy(duration: 0.35, extraBounce: 0.08)) {
                                            viewModel.performCoffeeAccessoryAction(for: substitute)
                                        }
                                    }.allowsHitTesting(userInteractionEnabled)
                                }
                            }
                        } header: {
                            OrderedCoffeeHeader()
                        }
                    }
                }
                
                .scrollBounceBehavior(.basedOnSize)
                .scrollIndicators(.hidden)
                .zIndex(0)
                

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("Background"))
        }
        .onAppear {
            viewModel.coffeeAccesories = coffee.accessories
        }
    }
    
    private func blockUserInteraction() {
        userInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            userInteractionEnabled = true
        }
    }
    
    private func getCoffeeAccessories() -> [any CoffeeAccessoryTypeProtocol] {
        var a = viewModel.coffeeAccesories.filter { accessory in
            !viewModel.selectedCoffeeAccessories
                .filter({ !$0.substitute })
                .contains(where: { accessory.title == $0.title})
            && !accessory.substitute
           
        }
        return a
    }
    
    private func getCoffeeSubstitutes() -> [any CoffeeAccessoryTypeProtocol] {
        var a = viewModel.coffeeAccesories.filter { accessory in
            !viewModel.selectedCoffeeAccessories
                .filter(\.substitute)
                .contains(where: { accessory.title == $0.title })
            && accessory.substitute
        }
         return a
    }
    
    private func getCoffeeFullPrice() -> Double {
        coffee.price + viewModel.getCoffeeAccessoriesExtraPrice()
    }
    
    private func getExtraPrice(from accessory: any CoffeeAccessoryTypeProtocol) -> String {
        accessory.extraPrice > 0 ? " (+\(PriceFormatter.formatToPLN(price: accessory.extraPrice)))" : ""
    }
    
    @ViewBuilder
    private func CancelButton() -> some View {
        Button {
            HapticManager.shared.impact(.soft)
            withAnimation(.snappy(duration: 0.3, extraBounce: 0.03)) {
                coffeePreviewVisible = false
            }
        } label: {
            Text("Anuluj")
        }
    }
    
    @ViewBuilder
    private func addToCartButton() -> some View {
        Button {} label: {
            Image(systemName: "cart.badge.plus")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 28, height: 28)
        }
    }
    
    @ViewBuilder
    private func SectionText(title: String, paddingTop: CGFloat) -> some View {
        Text(title.uppercased())
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading)
            .foregroundStyle(.secondary)
            .font(.system(size: 14))
            .padding(.top, paddingTop)
    }
    
    @ViewBuilder
    private func OrderedCoffeeHeader() -> some View {
        HStack(alignment: .center) {
            Image(coffee.imageName)
                .resizable()
                .matchedGeometryEffect(id: coffee.imageMatchedGeometryID, in: coffeeImageNamespace)
                .aspectRatio(contentMode: .fit)
                .frame(width: 120, height: 120)
            VStack(alignment: .leading, spacing: 4) {
                Text(coffee.title)
                    //.matchedGeometryEffect(id: coffee.titleMatchedGeometryID, in: coffeeTitleNamespace)
                    .fontWeight(.semibold)
                    .minimumScaleFactor(0.8)
                HStack {
                    Text(PriceFormatter.formatToPLN(price: getCoffeeFullPrice()))
                        .contentTransition(.numericText())
                        //.matchedGeometryEffect(id: coffee.priceMatchedGeometryID, in: coffeePriceNamespace)
                        .minimumScaleFactor(0.8)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .frame(height: 120)
        .padding(.horizontal)
        .padding(.top, -16)
        .zIndex(1)
        .scrollClipDisabled()
    }
}

#Preview {
    @Namespace var coffeeImageNamespace
    @Namespace var coffeeTitleNamespace
    @Namespace var coffeePriceNamespace
    return MenuItemPreview(coffeePreviewVisible: .constant(true),
                         coffee: CoffeeDto(title: "Cappuccino", 
                                           price: 18.00,
                                           imageName: "cappuccino",
                                           accessories: MockDataCoffeeAccessoriesTest.allcases()),
                         coffeeImageNamespace: coffeeImageNamespace,
                         coffeeTitleNamespace: coffeeTitleNamespace,
                         coffeePriceNamespace: coffeePriceNamespace)
}
