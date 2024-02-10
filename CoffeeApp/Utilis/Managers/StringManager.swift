import Foundation

class StringManager {
    static func pluralize(count: Int, forms: [String]) -> String {
        guard count >= 0 else { return forms[0] }
        let cases = [2, 0, 1, 1, 1, 2]
        let index = (count % 100 > 4 && count % 100 < 20 ||
                     (count > 1 && String(count).hasSuffix("1"))) ? 2 : cases[min(count % 10, 5)]
        return forms[index]
    }
}
