import Foundation

enum PluralizedString {
    case voucher(Int)
    case active(Int)
    case stamps(Int)
    
    var pluralized: String {
        switch self {
        case .voucher(let count):
            return StringManager.pluralize(count: count, forms: ["nagrodę", "nagrody", "nagród"])
        case .active(let count):
            return StringManager.pluralize(count: count, forms: ["aktywna", "aktywne", "aktywnych"])
        case .stamps(let count):
            return StringManager.pluralize(count: count, forms: ["pieczątka", "pieczątki", "pieczątek"])
        }
    }
}
