import Foundation

struct CoffeeDto: Codable, Hashable, Identifiable {
    var id: UUID = UUID()
    var title: String
    var price: Double
    var imageName: String
    var index: Int = 0
    var accessories: [CoffeeAccessoryType] = []
    var imageMatchedGeometryID = UUID().uuidString
    var titleMatchedGeometryID = UUID().uuidString
    var priceMatchedGeometryID = UUID().uuidString
}
