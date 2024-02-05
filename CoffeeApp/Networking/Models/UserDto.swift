import Firebase
import FirebaseFirestoreSwift

struct UserDto: Codable, Equatable {
    var uid: String
    var email: String
    var name: String?
    var currentCafe: CafeDto?
    var loyalityPoints: Int?
    var accountConfigured: Bool?
    
    static func == (lhs: UserDto, rhs: UserDto) -> Bool {
        lhs.uid == rhs.uid
    }
}
