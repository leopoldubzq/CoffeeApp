import SwiftUI

struct CoffeeAccessoriesList: View {
    
    @StateObject var viewModel: MenuItemPreviewViewModel
    
    var coffeeAccessories: [any CoffeeAccessoryTypeProtocol]
    var coffeeSubstitutes: [any CoffeeAccessoryTypeProtocol]
    
    var body: some View {
        List {
            if !coffeeAccessories.isEmpty {
                Section("Dodatki") {
                    ForEach(coffeeAccessories, id: \.uid) { accessory in
                        CoffeeAccessoryButton(title: accessory.title,
                                              extraPrice: accessory.extraPrice) {
                            withAnimation(.snappy(duration: 0.3, extraBounce: 0.08)) {
                                viewModel.performCoffeeAccessoryAction(for: accessory)
                            }
                        }
                    }
                }
            }
            if !coffeeSubstitutes.isEmpty {
                Section("Zamienniki") {
                    ForEach(coffeeSubstitutes, id: \.uid) { substitute in
                        CoffeeAccessoryButton(title: substitute.title,
                                              extraPrice: substitute.extraPrice) {
                            withAnimation(.snappy(duration: 0.3, extraBounce: 0.08)) {
                                viewModel.performCoffeeAccessoryAction(for: substitute)
                            }
                        }
                    }
                }
            }
            
        }
        .scrollBounceBehavior(.basedOnSize)
        .zIndex(0)
    }
}

#Preview {
    CoffeeAccessoriesList(viewModel: MenuItemPreviewViewModel(),
                          coffeeAccessories: MockDataCoffeeAccessories().allcases().filter { !$0.substitute },
                          coffeeSubstitutes: MockDataCoffeeAccessories().allcases().filter { $0.substitute })
}
