import Foundation
 
protocol CoffeeAccessoryTypeProtocol: Codable, Hashable, Identifiable {
    var id: UUID {get set}
    var title: String { get }
    var extraPrice: Double { get }
    var substitute: Bool { get }
    var addedAt: Date { get }
}


struct CoffeeAccessoryFireModel: CoffeeAccessoryTypeProtocol {
    var id: UUID = UUID()
    var title: String
    var extraPrice: Double
    var substitute: Bool
    var addedAt: Date
}


struct MockDataCoffeeAccessories {
    var sugar : CoffeeAccessoryFireModel = .init(title: "Cukier", extraPrice: 0, substitute: false, addedAt: .now)
    var doubleEspresso : CoffeeAccessoryFireModel = .init(title: "Podwójne espresso", extraPrice: 3, substitute: false, addedAt: .now)
    var lactoseFreeMilk : CoffeeAccessoryFireModel = .init(title: "Mleko bez laktozy", extraPrice: 1.5, substitute: true, addedAt: .now)
    var oatMilk : CoffeeAccessoryFireModel = .init(title: "Mleko owsiane", extraPrice: 3, substitute: true, addedAt: .now)
    var vanillaMilk : CoffeeAccessoryFireModel = .init(title: "Mleko waniliowe", extraPrice: 3, substitute: true, addedAt: .now)
    var saltCaramelSyrup : CoffeeAccessoryFireModel = .init(title: "Syrop słony karmel", extraPrice: 2, substitute: false, addedAt: .now)
    var caramelSyrup : CoffeeAccessoryFireModel = .init(title: "Syrop karmelowy", extraPrice: 2, substitute: false, addedAt: .now)
    var vanillaSyrup : CoffeeAccessoryFireModel = .init(title: "Syrop waniliowy", extraPrice: 2, substitute: false, addedAt: .now)
    var honey : CoffeeAccessoryFireModel = .init(title: "Miód", extraPrice: 1.5, substitute: false, addedAt: .now)
    func allcases() -> [CoffeeAccessoryFireModel] {
        return [sugar, doubleEspresso, lactoseFreeMilk, oatMilk, vanillaMilk, saltCaramelSyrup,
     caramelSyrup, vanillaSyrup, honey ]
    }
}

let MockDataCoffeeAccessoriesTest = MockDataCoffeeAccessories()
