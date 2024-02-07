import SwiftUI
import Firebase

final class HomeViewModel: BaseViewModel {
    @Published var activeVouchers: [Voucher] = Voucher.mocks
    @Published var user: UserDto?
    
    private let userService = UserService()
    
    override init() {
        super.init()
        activeVouchers = Voucher.mocks
    }
    
    func getUser() {
        guard Auth.auth().currentUser != nil else { return }
        print("Fetch data")
        isLoading = true
        userService.getUser(uid: Auth.auth().currentUser?.uid)
            .sink { [weak self] _ in
                self?.isLoading = false
            } receiveValue: { [weak self] user in
                self?.user = user
            }
            .store(in: &cancellables)
    }
    
}
