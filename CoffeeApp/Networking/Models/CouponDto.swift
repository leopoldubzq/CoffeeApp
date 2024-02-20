import Foundation
import Firebase
import FirebaseFirestoreSwift

struct CouponDto: FirestoreProtocol, Hashable, Equatable {
    let uid: String
    let title: String
    let code: String
    @ServerTimestamp var expirationDate: Timestamp?
    
    static var mock: Self {
        .init(uid: UUID().uuidString, title: "Rabat 5zł na Americaon, Cappucino, Latte", code: "123456789", expirationDate: nil)
    }
}
