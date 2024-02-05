import Firebase
import FirebaseFirestoreSwift

struct UserDto: Codable, Equatable {
    var uid: String
    var email: String
    var name: String?
    var currentCafe: CafeDto?
    var loyalityPoints: Int = 0
    var accountConfigured: Bool = false
    
    static func == (lhs: UserDto, rhs: UserDto) -> Bool {
        lhs.uid == rhs.uid
    }
}
