import FirebaseFirestoreSwift
import Combine
import GoogleSignIn
import Firebase

final class UserService {
    
    func createUser(_ user: UserDto) -> AnyPublisher<UserDto, CAError> {
        return Future { promise in
            
            do {
                try FirestoreUtility
                    .collectionReference(.users)
                    .document(user.uid)
                    .setData(from: user) { error in
                        if let error { promise(.failure(CAError.basicError(error.localizedDescription))) }
                        promise(.success(user))
                    }
            } catch {
                promise(.failure(.failedToCreateFirestoreDocument))
            }
        }
        .subscribe(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func updateUser(user: UserDto) -> AnyPublisher<UserDto, CAError> {
        return Future { promise in
            FirestoreUtility.collectionReference(.users)
                .whereField("uid", isEqualTo: user.uid)
                .getDocuments { snapshot, error in
                    if let error {
                        promise(.failure(CAError.basicError(error.localizedDescription)))
                        return
                    }
                    guard let snapshot, !snapshot.documents.isEmpty else {
                        promise(.failure(CAError.emptyFirestoreDocument))
                        return
                    }
                    if let document = snapshot.documents.first {
                        do {
                            try document.reference.setData(from: user)
                            promise(.success(user))
                        } catch {
                            promise(.failure(.basicError(error.localizedDescription)))
                        }
                    }
                }
        }
        .subscribe(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func getUsers() -> AnyPublisher<[UserDto]?, CAError> {
        return Future { promise in
            FirestoreUtility
                .collectionReference(.users)
                .addSnapshotListener { documentShapshot, error in
                    if let error { promise(.failure(CAError.basicError(error.localizedDescription))) }
                    guard let documents = documentShapshot?.documents else {
                        print("No documents")
                        promise(.success(nil))
                        return
                    }
                    
                    let users = documents.compactMap { queryDocSnapshot in
                        return try? queryDocSnapshot.data(as: UserDto.self)
                    }
                    promise(.success(users))
                }
        }
        .subscribe(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func getUser(uid: String?) -> AnyPublisher<UserDto?, CAError> {
        return Future { promise in
            guard let uid else { return }
            FirestoreUtility
                .collectionReference(.users)
                .document(uid)
                .getDocument(completion: { snapshot, error in
                    if let error { promise(.failure(.basicError(error.localizedDescription))) }
                    guard let snapshot else { return }
                    if !snapshot.exists {
                        promise(.success(nil))
                    }
                    guard let user = try? snapshot.data(as: UserDto.self) else { return }
                    promise(.success(user))
                })
        }
        .subscribe(on: DispatchQueue.main)
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
