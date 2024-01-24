import Foundation

final class PriceFormatter {
    static func formatToPLN(price: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale(identifier: "pl_PL")
        numberFormatter.minimumFractionDigits = price.truncatingRemainder(dividingBy: 1) == 0 ? 0 : 2
        numberFormatter.maximumFractionDigits = price.truncatingRemainder(dividingBy: 1) == 0 ? 0 : 2
        
        if let formattedPrice = numberFormatter.string(from: NSNumber(value: price)) {
            return formattedPrice
        } else {
            return "Invalid Price"
        }
    }
}
