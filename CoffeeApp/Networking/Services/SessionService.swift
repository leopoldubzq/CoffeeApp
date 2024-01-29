import Foundation
import Combine
import FirebaseCore
import GoogleSignIn
import FirebaseAuth

final class SessionService {
    
    // MARK: - PRIVATE PROPERTIES
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - PUBLIC METHODS
    func logout() -> AnyPublisher<Void, Error> {
        return Future { promise in
            do {
                try Auth.auth().signOut()
                promise(.success(()))
            } catch {
                print("Could not sign user out...\(error.localizedDescription)")
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func loginWithGoogle() -> AnyPublisher<(GIDGoogleUser, AuthDataResult?), CAError> {
        return Future { promise in
            guard let clientID = FirebaseApp.app()?.options.clientID else { return }
            let config = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = config
            let rootVC = ApplicationUtility.rootViewController
            GIDSignIn.sharedInstance.signIn(withPresenting: rootVC) { [weak self] signInResult, error in
                if let error { promise(.failure(CAError.basicError(error.localizedDescription))) }
                if let token = signInResult?.user.idToken, let accessToken = signInResult?.user.accessToken {
                    let credentials = GoogleAuthProvider.credential(withIDToken: token.tokenString, 
                                                                    accessToken: accessToken.tokenString)
                    self?.signUserIn(with: credentials) { result, error in
                        if let error { promise(.failure(CAError.basicError(error.localizedDescription))) }
                        guard let user = signInResult?.user else { return }
                        promise(.success((user, result)))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    // MARK: - PRIVATE METHODS
    private func signUserIn(with credentials: AuthCredential,
                            completion: @escaping (AuthDataResult?, Error?) -> Void) {
        Auth.auth().signIn(with: credentials) { result, error in
            completion(result, error)
        }
    }
}
