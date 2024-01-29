import SwiftUI
import Firebase

final class LoginViewModel: BaseViewModel {
    
    @Published var shouldPresentLogin: Bool = true
    
    private let service = SessionService()
    
    func loginWithGoogle() {
        isLoading = true
        service.loginWithGoogle()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }) { [weak self] user, _ in
                self?.isLoading = false
                self?.shouldPresentLogin = Auth.auth().currentUser == nil
            }
            .store(in: &cancellables)
    }
}
