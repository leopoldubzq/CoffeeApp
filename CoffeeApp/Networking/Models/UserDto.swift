import Firebase
import FirebaseFirestoreSwift

protocol FirestoreProtocol: Codable {
    var uid: String { get }
}

struct UserDto: Equatable, Hashable, FirestoreProtocol {
    var uid: String
    var email: String
    var name: String?
    var currentCafe: CafeDto?
    var loyalityPoints: Int?
    var accountConfigured: Bool? = false
    var stamps: [StampDto] = []
    @ServerTimestamp var createdAt: Timestamp? = Timestamp(date: .now)
    
    static func == (lhs: UserDto, rhs: UserDto) -> Bool {
        lhs.uid == rhs.uid
    }
}
