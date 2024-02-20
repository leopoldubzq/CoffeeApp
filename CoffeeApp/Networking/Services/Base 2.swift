import Foundation
import Combine
import FirebaseCore
import GoogleSignIn
import FirebaseAuth

class BaseService {
    var cancellables = Set<AnyCancellable>()
    
    func getResults<T: Codable>(for model: T.Type, collectionReference: FirestoreCollection) -> AnyPublisher<[T]?, CAError> {
        return Future { promise in
            FirestoreUtility
                .collectionReference(collectionReference)
                .addSnapshotListener { documentShapshot, error in
                    if let error { promise(.failure(.basicError(error.localizedDescription))) }
                    guard let documents = documentShapshot?.documents else {
                        print("No documents")
                        promise(.success(nil))
                        return
                    }
                    let results = documents.compactMap { queryDocSnapshot in
                        return try? queryDocSnapshot.data(as: T.self)
                    }
                    promise(.success(results))
                }
        }
        .subscribe(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func getResult<T: Codable>(for model: T.Type, withUid uid: String?, collectionReference: FirestoreCollection) -> AnyPublisher<T?, CAError> {
        return Future { promise in
            guard let uid else { return }
            FirestoreUtility
                .collectionReference(collectionReference)
                .document(uid)
                .getDocument(completion: { snapshot, error in
                    if let error { promise(.failure(.basicError(error.localizedDescription))) }
                    guard let snapshot else { return }
                    if !snapshot.exists {
                        promise(.success(nil))
                    }
                    guard let result = try? snapshot.data(as: T.self) else { return }
                    promise(.success(result))
                })
        }
        .subscribe(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func update<T: FirestoreProtocol>(_ model: FirestoreProtocol, type: T.Type) -> AnyPublisher<T, CAError> {
        return Future { promise in
            do {
                try FirestoreUtility
                    .collectionReference(.users)
                    .document(model.uid)
                    .setData(from: model) { error in
                        if let error { promise(.failure(CAError.basicError(error.localizedDescription))) }
                        if let model = model as? T {
                            promise(.success((model)))
                        }
                    }
            } catch {
                promise(.failure(.basicError(error.localizedDescription)))
            }
        }
        .subscribe(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    
    func create<T: FirestoreProtocol>(_ model: FirestoreProtocol, type: T.Type, reference: FirestoreCollection = .users) -> AnyPublisher<T, CAError> {
        return Future { promise in
            do {
                try FirestoreUtility
                    .collectionReference(reference)
                    .document(model.uid)
                    .setData(from: model) { error in
                        if let error { promise(.failure(.basicError(error.localizedDescription))) }
                        if let model = model as? T {
                            promise(.success(model))
                        }
                    }
            } catch {
                promise(.failure(.failedToCreateFirestoreDocument))
            }
        }
        .subscribe(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
