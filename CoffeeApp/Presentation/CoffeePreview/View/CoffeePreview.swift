import SwiftUI

struct CoffeePreview: View {
    
    @StateObject private var viewModel = CoffeePreviewViewModel()
    @Binding var coffeePreviewVisible: Bool
    @State private var scrollOffsetY: CGFloat = 0
    var coffee: CoffeeDto
    var coffeeImageNamespace: Namespace.ID
    var coffeeTitleNamespace: Namespace.ID
    var coffeePriceNamespace: Namespace.ID
    
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .center) {
                HStack {
                    CancelButton()
                    Spacer()
                    addToCartButton()
                }
                .padding()
                .overlay(alignment: .center) {
                    Text("Zamówienie")
                        .fontWeight(.semibold)
                }
                
                ScrollView {
                    LazyVStack(spacing: 8, pinnedViews: [.sectionHeaders]) {
                        Section {
                            TagLayout(alignment: .leading) {
                                ForEach(Array(Set(viewModel.selectedCoffeeAccessories)), id: \.self) { accessory in
                                    SelectedCoffeeAccessoryButton(accessory: accessory) {
                                        withAnimation(.snappy(duration: 0.35, extraBounce: 0.1)) {
                                            viewModel.selectedCoffeeAccessories.removeAll(where: { $0.rawValue == accessory.rawValue })
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, viewModel.selectedCoffeeAccessories.isEmpty ? 0 : 8)
                            if !getCoffeeAccessories().isEmpty {
                                SectionText(title: "Dodatki", paddingTop: 0)
                                ForEach(getCoffeeAccessories(), id: \.self) { accessory in
                                    CoffeeAccessoryButton(title: accessory.title,
                                                          extraPrice: accessory.extraPrice) {
                                        withAnimation(.snappy(duration: 0.35, extraBounce: 0.08)) {
                                            viewModel.performCoffeeAccessoryAction(for: accessory)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                            if !getCoffeeSubstitutes().isEmpty {
                                SectionText(title: "Zamienniki", paddingTop: 16)
                                ForEach(getCoffeeSubstitutes(), id: \.self) { substitute in
                                    CoffeeAccessoryButton(title: substitute.title,
                                                          extraPrice: substitute.extraPrice) {
                                        withAnimation(.snappy(duration: 0.35, extraBounce: 0.08)) {
                                            viewModel.performCoffeeAccessoryAction(for: substitute)
                                        }
                                    }
                                    .padding(.horizontal)
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
                OrderCoffeeButton(coffeePreviewVisible: $coffeePreviewVisible,
                                  safeAreaBottom: proxy.safeAreaInsets.bottom)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.init(uiColor: .systemBackground))
            .ignoresSafeArea(edges: [.bottom, .leading, .trailing])
            .onAppear {
                viewModel.coffeeAccesories = coffee.accessories
            }
        }
    }
    
    private func getCoffeeAccessories() -> [CoffeeAccessoryType] {
        viewModel.coffeeAccesories.filter { accessory in
            !viewModel.selectedCoffeeAccessories
                .filter({ !$0.substitute })
                .contains(where: { accessory.rawValue == $0.rawValue })
            && !accessory.substitute
        }
    }
    
    private func getCoffeeSubstitutes() -> [CoffeeAccessoryType] {
        viewModel.coffeeAccesories.filter { accessory in
            !viewModel.selectedCoffeeAccessories
                .filter(\.substitute)
                .contains(where: { accessory.rawValue == $0.rawValue })
            && accessory.substitute
        }
    }
    
    private func getCoffeeFullPrice() -> Double {
        coffee.price + viewModel.getCoffeeAccessoriesExtraPrice()
    }
    
    private func getExtraPrice(from accessory: CoffeeAccessoryType) -> String {
        accessory.extraPrice > 0 ? " (+\(PriceFormatter.formatToPLN(price: accessory.extraPrice)))" : ""
    }
    
    private func getMaxOffsetYValue() -> CGFloat {
        max(120 + min(scrollOffsetY, 70), 70)
    }
    
    @ViewBuilder
    private func CancelButton() -> some View {
        Button {
            HapticManager.shared.impact(.soft)
            withAnimation(.snappy(duration: 0.3)) {
                coffeePreviewVisible.toggle()
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
                .aspectRatio(contentMode: .fit)
                .matchedGeometryEffect(id: coffee.imageMatchedGeometryID, in: coffeeImageNamespace)
                .frame(width: 120, height: 120)
            VStack(alignment: .leading, spacing: 4) {
                Text(coffee.title)
                    .matchedGeometryEffect(id: coffee.titleMatchedGeometryID, in: coffeeTitleNamespace)
                    .fontWeight(.semibold)
                    .minimumScaleFactor(0.8)
                HStack {
                    Text(PriceFormatter.formatToPLN(price: getCoffeeFullPrice()))
                        .contentTransition(.numericText())
                        .matchedGeometryEffect(id: coffee.priceMatchedGeometryID, in: coffeePriceNamespace)
                        .minimumScaleFactor(0.8)
                }
            }
        }
        .frame(height: 120)
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.horizontal)
        .padding(.top, -16)
        .zIndex(1)
        .background(Color.init(uiColor: .systemBackground))
        .scrollClipDisabled()
        
        
    }
}

#Preview {
    @Namespace var coffeeImageNamespace
    @Namespace var coffeeTitleNamespace
    @Namespace var coffeePriceNamespace
    return CoffeePreview(coffeePreviewVisible: .constant(true),
                         coffee: CoffeeDto(title: "Cappuccino", 
                                           price: 18.00,
                                           imageName: "cappuccino",
                                           accessories: CoffeeAccessoryType.allCases),
                         coffeeImageNamespace: coffeeImageNamespace,
                         coffeeTitleNamespace: coffeeTitleNamespace,
                         coffeePriceNamespace: coffeePriceNamespace)
}
