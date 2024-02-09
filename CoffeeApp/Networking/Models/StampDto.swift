import Foundation
import FirebaseFirestoreSwift
import Firebase

struct StampDto: FirestoreProtocol, Hashable, Equatable {
    let uid: String
    @ServerTimestamp var createdAt: Timestamp? = Timestamp(date: .now)
    
    static func == (lhs: StampDto, rhs: StampDto) -> Bool {
        lhs.uid == rhs.uid
    }
    
    static var mock: Self {
        return .init(uid: UUID().uuidString)
    }
}
