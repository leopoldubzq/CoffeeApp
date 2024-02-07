import Foundation
import Combine
import FirebaseCore
import GoogleSignIn
import FirebaseAuth

final class CafeService: BaseService {
    
    func getCafes() -> AnyPublisher<[CafeDto]?, CAError> {
        getResults(for: CafeDto.self, collectionReference: .cafes)
    }
}
