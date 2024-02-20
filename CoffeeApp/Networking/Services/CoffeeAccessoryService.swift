import Foundation
import Combine
import FirebaseCore
import GoogleSignIn
import FirebaseAuth

final class CoffeeAccessoryService: BaseService {
    
    func getCoffeeAccessory() -> AnyPublisher<[CoffeeAccessoryFireModel]?, CAError> {
        getResults(for: CoffeeAccessoryFireModel.self, collectionReference: .coffeeAccessory)
    }
    
    func createCoffeeAccessory(_ coffeeAccessory: CoffeeAccessoryFireModel) -> AnyPublisher<CoffeeAccessoryFireModel, CAError> {
        create(coffeeAccessory, type: CoffeeAccessoryFireModel.self, reference: .coffeeAccessory)
    }
    
//    func createCoffeeAccessory(coffeeAccessory: GIDGoogleUser?, result: AuthDataResult?) -> AnyPublisher<Void, CAError> {
//        return Future { promise in
//            guard let coffeeAccessory = coffeeAccessory,
//                  let uid = result?.user.uid else { return }
//            
//            let user = UserDto(uid: uid, email: googleUser.profile?.email ?? "")
//            
//            FirestoreUtility.collectionReference(.users)
//                .whereField("uid", isEqualTo: uid)
//                .getDocuments(completion: { snapshot, error in
//                    if let error { promise(.failure(CAError.basicError(error.localizedDescription))) }
//                    guard let snapshot else { return }
//                    if snapshot.documents.isEmpty {
//                        do {
//                            try FirestoreUtility
//                                .collectionReference(.users)
//                                .document(user.uid)
//                                .setData(from: user) { error in
//                                    if let error { promise(.failure(CAError.basicError(error.localizedDescription))) }
//                                    promise(.success(()))
//                                }
//                        } catch {
//                            promise(.failure(.basicError(error.localizedDescription)))
//                        }
//                    } else {
//                        promise(.success(()))
//                    }
//                })
//        }
//        .subscribe(on: DispatchQueue.main)
//        .eraseToAnyPublisher()
//    }
}
