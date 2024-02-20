import Firebase
import FirebaseFirestoreSwift

protocol FirestoreProtocol: Codable {
    var uid: String { get }
}

struct UserDto: FirestoreProtocol, Hashable, Equatable {
    var uid: String
    var email: String
    var name: String?
    var currentCafe: CafeDto?
    var loyalityPoints: Int?
    var accountConfigured: Bool? = false
    var cafeStamps: [String : Int] = [:]
    @ServerTimestamp var createdAt: Timestamp? = Timestamp(date: .now)
    
    static func == (lhs: UserDto, rhs: UserDto) -> Bool {
        lhs.uid == rhs.uid
    }
}
