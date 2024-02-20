import FirebaseFirestoreSwift
import Combine
import GoogleSignIn
import Firebase

final class UserService: BaseService {
    
    func createUser(_ user: UserDto) -> AnyPublisher<UserDto, CAError> {
        create(user, collectionReference: .users, type: UserDto.self)
    }
    
    func updateUser(user: UserDto) -> AnyPublisher<UserDto?, CAError> {
        update(user, collectionReference: .users, type: UserDto.self)
    }
    
    func getUsers() -> AnyPublisher<[UserDto]?, CAError> {
        getResults(for: UserDto.self, collectionReference: .users)
    }
    
    func getUser(_ user: UserDto) -> AnyPublisher<UserDto?, CAError> {
        getResult(for: user, collectionReference: .users, type: UserDto.self)
    }
    
    func getUser(uid: String) -> AnyPublisher<UserDto?, CAError> {
        getResult(for: UserDto.self, withUid: uid, collectionReference: .users)
    }
    
    func addStamps(count: Int, to cafe: CafeDto, for user: UserDto) -> AnyPublisher<[String : Int], CAError> {
        var cafeStamps = user.cafeStamps
        var userToUpdate = user
        cafeStamps.updateValue(count, forKey: cafe.uid)
        userToUpdate.cafeStamps = cafeStamps
        return update(userToUpdate, collectionReference: .users, type: UserDto.self)
            .compactMap { $0?.cafeStamps }
            .eraseToAnyPublisher()
    }
    
    func createGoogleUser(user: GIDGoogleUser?, result: AuthDataResult?) -> AnyPublisher<Void, CAError> {
        return Future { promise in
            guard let googleUser = user,
                  let uid = result?.user.uid else { return }
            
            let user = UserDto(uid: uid, email: googleUser.profile?.email ?? "")
            
            FirestoreUtility.collectionReference(.users)
                .whereField("uid", isEqualTo: uid)
                .getDocuments(completion: { snapshot, error in
                    if let error { promise(.failure(CAError.basicError(error.localizedDescription))) }
                    guard let snapshot else { return }
                    if snapshot.documents.isEmpty {
                        do {
                            try FirestoreUtility
                                .collectionReference(.users)
                                .document(user.uid)
                                .setData(from: user) { error in
                                    if let error { promise(.failure(CAError.basicError(error.localizedDescription))) }
                                    promise(.success(()))
                                }
                        } catch {
                            promise(.failure(.basicError(error.localizedDescription)))
                        }
                    } else {
                        promise(.success(()))
                    }
                })
        }
        .subscribe(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
