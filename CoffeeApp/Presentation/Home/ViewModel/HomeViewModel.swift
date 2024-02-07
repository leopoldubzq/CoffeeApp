import SwiftUI
import Firebase

final class HomeViewModel: BaseViewModel {
    @Published var activeVouchers: [VoucherDto] = VoucherDto.mocks
    @Published var user: UserDto?
    @Published var currentCafe: CafeDto?
    
    private let userService = UserService()
    
    func getUser() {
        guard Auth.auth().currentUser != nil else { return }
        print("Fetch data")
        isLoading = true
        userService.getUser(uid: Auth.auth().currentUser?.uid)
            .sink { [weak self] _ in
                self?.isLoading = false
            } receiveValue: { [weak self] user in
                self?.user = user
                self?.currentCafe = user?.currentCafe
            }
            .store(in: &cancellables)
    }
    
    func updateUser() {
        guard Auth.auth().currentUser != nil else { return }
        print("Update user")
        isLoading = true
        if let user {
            userService.updateUser(user: user)
                .sink { [weak self] _ in
                    self?.isLoading = false
                } receiveValue: { [weak self] user in
                    self?.user = user
                    self?.currentCafe = user.currentCafe
                }
                .store(in: &cancellables)

        }
        
    }
    
}
