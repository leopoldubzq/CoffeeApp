import Foundation

final class QRCodeGenerator {
    static func generate(length: Int = 10) -> String {
        var randomIntegers = [Int]()

        for _ in 1...length {
            let randomInteger = Int.random(in: 0...9)
            randomIntegers.append(randomInteger)
        }

        return randomIntegers
            .map { String($0) }
            .joined()
    }
}
