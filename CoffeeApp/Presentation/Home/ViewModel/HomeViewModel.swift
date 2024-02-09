import SwiftUI
import Firebase

final class HomeViewModel: BaseViewModel {
    @Published var activeVouchers: [VoucherDto] = VoucherDto.mocks
    @Published var user: UserDto?
    @Published var currentCafe: CafeDto?
    @Published var stamps: [StampDto] = []
    
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
                self?.stamps = user?.stamps ?? []
                self?.currentCafe = user?.currentCafe
            }
            .store(in: &cancellables)
    }
    
    func updateUser() {
        guard Auth.auth().currentUser != nil else { return }
        print("Update user")
        if let user {
            isLoading = true
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
