import Foundation

enum PluralizedString {
    case voucher(Int)
    case active(Int)
    
    var pluralized: String {
        switch self {
        case .voucher(let count):
            return StringManager.pluralize(count: count, forms: ["voucher", "vouchery", "voucherów"])
        case .active(let count):
            return StringManager.pluralize(count: count, forms: ["aktywny", "aktywne", "aktywnych"])
        }
    }
}
