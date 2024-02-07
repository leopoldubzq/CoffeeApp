import SwiftUI
import Firebase

enum LoginNetworkResult {
    case success
    case failure
}

final class LoginViewModel: BaseViewModel {
    
    @Published var shouldPresentLogin: Bool = true
    @Published var user: UserDto?
    
    private let sessionService = SessionService()
    private let userService = UserService()
    
    func loginWithGoogle(callback: ((LoginNetworkResult) -> ())? = nil) {
        isLoading = true
        sessionService.loginWithGoogle()
            .flatMap({ [unowned self] user, result in
                /// Creates new user only if Firestore snapshot doesn't exist
                return userService.createGoogleUser(user: user, result: result)
                    .flatMap { [unowned self] in userService.getUser(uid: result?.user.uid ?? "") }
            })
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                self?.shouldPresentLogin = Auth.auth().currentUser == nil
                switch completion {
                case .finished:
                    callback?(.success)
                case .failure(let error):
                    callback?(.failure)
                    print(error.localizedDescription)
                }
            }, receiveValue: { [weak self] user in
                self?.user = user
            })
            .store(in: &cancellables)
    }
}
