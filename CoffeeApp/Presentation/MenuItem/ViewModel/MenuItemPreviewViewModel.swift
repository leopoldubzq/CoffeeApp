import SwiftUI
import Combine

final class MenuItemPreviewViewModel: BaseViewModel {
    
    //MARK: - PUBLIC PROPERTIES
    @Published var coffeeAccesories: [any CoffeeAccessoryTypeProtocol] = []
    @Published var selectedCoffeeAccessories: [any CoffeeAccessoryTypeProtocol] = []
    @Published var allSelectedCoffeeAccessories: [any CoffeeAccessoryTypeProtocol] = []
    
    //MARK: - PUBLIC METHODS
    func performCoffeeAccessoryAction(for accessory: any CoffeeAccessoryTypeProtocol) {
        switch accessory.substitute {
        case true:
            if isMilk(accessory) {
                selectedCoffeeAccessories.removeAll(where: { $0.substitute && isMilk($0) })
            }
            selectedCoffeeAccessories.append(accessory)
        case false:
            if isSyrup(accessory) {
                selectedCoffeeAccessories.removeAll(where: { !$0.substitute && isSyrup($0) })
            }
            selectedCoffeeAccessories.append(accessory)
        }
    }
    
    func getCoffeeAccessoriesExtraPrice() -> Double {
        selectedCoffeeAccessories
            .map(\.extraPrice)
            .reduce(0) { $0 + $1 }
    }
    
    //MARK: - PRIVATE METHODS
    private func isMilk(_ accessory: any CoffeeAccessoryTypeProtocol) -> Bool {
        accessory.title == MockDataCoffeeAccessories().oatMilk.title || accessory.title == MockDataCoffeeAccessories().vanillaMilk.title || accessory.title == MockDataCoffeeAccessories().lactoseFreeMilk.title
    }
    
    private func isSyrup(_ accessorry: any CoffeeAccessoryTypeProtocol) -> Bool {
        accessorry.title == MockDataCoffeeAccessories().caramelSyrup.title || accessorry.title == MockDataCoffeeAccessories().vanillaSyrup.title || accessorry.title == MockDataCoffeeAccessories().saltCaramelSyrup.title
    }
}
