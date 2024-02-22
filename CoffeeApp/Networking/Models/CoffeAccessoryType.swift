import Foundation
 
protocol CoffeeAccessoryTypeProtocol: FirestoreProtocol, Codable, Hashable {
    var title: String { get }
    var extraPrice: Double { get }
    var substitute: Bool { get }
}


struct CoffeeAccessoryFireModel: CoffeeAccessoryTypeProtocol {
    var uid: String
    var title: String
    var extraPrice: Double
    var substitute: Bool
    
    static func == (lhs: CoffeeAccessoryFireModel, rhs: CoffeeAccessoryFireModel) -> Bool {
        lhs.uid == rhs.uid
    }
}

struct MockDataCoffeeAccessories {
    var sugar : CoffeeAccessoryFireModel = .init(uid: UUID().uuidString, title: "Cukier", extraPrice: 0, substitute: false)
    var doubleEspresso : CoffeeAccessoryFireModel = .init(uid: UUID().uuidString, title: "Podwójne espresso", extraPrice: 3, substitute: false)
    var lactoseFreeMilk : CoffeeAccessoryFireModel = .init(uid: UUID().uuidString, title: "Mleko bez laktozy", extraPrice: 1, substitute: true)
    var oatMilk : CoffeeAccessoryFireModel = .init(uid: UUID().uuidString, title: "Mleko owsiane", extraPrice: 3, substitute: true)
    var vanillaMilk : CoffeeAccessoryFireModel = .init(uid: UUID().uuidString, title: "Mleko waniliowe", extraPrice: 3, substitute: true)
    var saltCaramelSyrup : CoffeeAccessoryFireModel = .init(uid: UUID().uuidString, title: "Syrop słony karmel", extraPrice: 2, substitute: false)
    var caramelSyrup : CoffeeAccessoryFireModel = .init(uid: UUID().uuidString, title: "Syrop karmelowy", extraPrice: 2, substitute: false)
    var vanillaSyrup : CoffeeAccessoryFireModel = .init(uid: UUID().uuidString, title: "Syrop waniliowy", extraPrice: 2, substitute: false)
    var honey : CoffeeAccessoryFireModel = .init(uid: UUID().uuidString, title: "Miód", extraPrice: 1, substitute: false)
    func allcases() -> [CoffeeAccessoryFireModel] {
        return [sugar, doubleEspresso, lactoseFreeMilk, oatMilk, vanillaMilk, saltCaramelSyrup,
     caramelSyrup, vanillaSyrup, honey ]
    }
}

let MockDataCoffeeAccessoriesTest = MockDataCoffeeAccessories()
