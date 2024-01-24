import SwiftUI
import Combine

final class CoffeePreviewViewModel: BaseViewModel {
    
    //MARK: - PUBLIC PROPERTIES
    @Published var coffeeAccesories: [CoffeeAccessoryType] = []
    @Published var selectedCoffeeAccessories: [CoffeeAccessoryType] = []
    @Published var allSelectedCoffeeAccessories: [CoffeeAccessoryProtocol] = []
    
    //MARK: - PUBLIC METHODS
    func performCoffeeAccessoryAction(for accessory: CoffeeAccessoryType) {
        switch accessory.substitute {
        case true:
            if isMilk(accessory) {
                selectedCoffeeAccessories.removeAll(where: { $0.substitute && isMilk($0) })
            }
            selectedCoffeeAccessories.insert(accessory, at: 0)
        case false:
            if isSyrup(accessory) {
                selectedCoffeeAccessories.removeAll(where: { !$0.substitute && isSyrup($0) })
            }
            selectedCoffeeAccessories.insert(accessory, at: 0)
        }
    }
    
    func getCoffeeAccessoriesExtraPrice() -> Double {
        selectedCoffeeAccessories
            .map(\.extraPrice)
            .reduce(0) { $0 + $1 }
    }
    
    //MARK: - PRIVATE METHODS
    private func isMilk(_ accessory: CoffeeAccessoryType) -> Bool {
        accessory == .oatMilk || accessory == .vanillaMilk || accessory == .lactoseFreeMilk
    }
    
    private func isSyrup(_ accessorry: CoffeeAccessoryType) -> Bool {
        accessorry == .caramelSyrup || accessorry == .vanillaSyrup || accessorry == .saltCaramelSyrup
    }
    
    
}
