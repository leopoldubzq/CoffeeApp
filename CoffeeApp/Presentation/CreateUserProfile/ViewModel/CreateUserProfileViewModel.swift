import SwiftUI

final class CreateUserProfileViewModel: BaseViewModel {
    
    //MARK: - PUBLIC PROPERTIES
    @Published var user: UserDto?
    @Published var selectedCafe: CafeDto?
    
    //MARK: - PRIVATE PROPERTIES
    private let userService = UserService()
    
    //MARK: - PUBLIC METHODS
    func updateUser(completion: @escaping VoidCallback) {
        isLoading = true
        if let user {
            userService.updateUser(user: user)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] result in
                    self?.isLoading = false
                    switch result {
                    case .finished:
                        completion()
                    case .failure(let error):
                        print("Failed to update user: \(error.localizedDescription)")
                    }
                } receiveValue: { _ in }
                .store(in: &cancellables)

        }
    }
    
    
}
