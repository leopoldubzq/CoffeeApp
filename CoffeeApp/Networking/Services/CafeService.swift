import Foundation
import Combine
import FirebaseCore
import GoogleSignIn
import FirebaseAuth
import Firebase

final class CafeService: BaseService {
    
    func getCafes() -> AnyPublisher<[CafeDto]?, CAError> {
        getResults(for: CafeDto.self, collectionReference: .cafes)
    }
    
    func createCoupons(for cafe: CafeDto) -> AnyPublisher<CafeDto?, CAError> {
        let coupons = [CouponDto(uid: UUID().uuidString,
                                 title: "Rabat 5zł na Americano, Cappucino, Latte",
                                 code: "123456789",
                                 expirationDate: Timestamp(date: .now + 604800)),
                       CouponDto(uid: UUID().uuidString,
                                 title: "Rabat 5zł na Americano, Cappucino, Latte",
                                 code: "123456789",
                                 expirationDate: Timestamp(date: .now + 604800)),
                       CouponDto(uid: UUID().uuidString,
                                 title: "Rabat 5zł na Americano, Cappucino, Latte",
                                 code: "123456789",
                                 expirationDate: Timestamp(date: .now + 604800)),
                       CouponDto(uid: UUID().uuidString,
                                 title: "Rabat 5zł na Americano, Cappucino, Latte",
                                 code: "123456789",
                                 expirationDate: Timestamp(date: .now + 604800))]
        var cafeToUpdate = cafe
        cafeToUpdate.coupons = coupons
        return update(cafeToUpdate, collectionReference: .cafes, type: CafeDto.self)
    }
}
