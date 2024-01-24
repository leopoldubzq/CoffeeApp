enum SyrupType {
    case saltCaramel
    case caramel
    case vanilla
    
    var title: String {
        switch self {
        case .saltCaramel:
            return "Słony karmel"
        case .caramel:
            return "Karmel"
        case .vanilla:
            return "Wanilia"
        }
    }
}

enum CoffeeAccessoryType: String, CaseIterable, Codable {
    case sugar
    case doubleEspresso
    case lactoseFreeMilk
    case oatMilk
    case vanillaMilk
    case saltCaramelSyrup
    case caramelSyrup
    case vanillaSyrup
    case honey
    
    var title: String {
        switch self {
        case .sugar:
            return "Cukier"
        case .doubleEspresso:
            return "Podwójne espresso"
        case .lactoseFreeMilk:
            return "Mleko bez laktozy"
        case .oatMilk:
            return "Mleko owsiane"
        case .vanillaMilk:
            return "Mleko waniliowe"
        case .saltCaramelSyrup:
            return "Syrop słony karmel"
        case .caramelSyrup:
            return "Sytop karmelowy"
        case .vanillaSyrup:
            return "Syrop waniliowy"
        case .honey:
            return "Miód"
        }
    }
    
    var extraPrice: Double {
        switch self {
        case .doubleEspresso:
            return 3
        case .lactoseFreeMilk, .honey:
            return 1.5
        case .oatMilk, .vanillaMilk:
            return 3.0
        case .saltCaramelSyrup, .caramelSyrup, .vanillaSyrup:
            return 2.0
        default:
            return 0.0
        }
    }
    
    var substitute: Bool {
        switch self {
        case .sugar, .doubleEspresso, .honey, .caramelSyrup, .saltCaramelSyrup, .vanillaSyrup:
            return false
        case .lactoseFreeMilk, .oatMilk, .vanillaMilk:
            return true
        }
    }
}
