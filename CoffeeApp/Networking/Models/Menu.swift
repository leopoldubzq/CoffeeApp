import Foundation

enum Menu: CaseIterable {
    case coffees
    case snacks
    case breakfastSets
    
    var title: String {
        switch self {
        case .coffees:
            return "Kawy"
        case .snacks:
            return "Przekąski"
        case .breakfastSets:
            return "Zestawy śniadaniowe"
        }
    }
}
