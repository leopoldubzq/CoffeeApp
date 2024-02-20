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
    
    
    //TEMP
    @Published var selectedCafeeAccesory: CoffeeAccessoryFireModel?
    @Published var cafeeAccesory: [CoffeeAccessoryFireModel] = []
    
    //MARK: - PRIVATE PROPERTIES
    private let coffeeAccessoryService = CoffeeAccessoryService()
    
    //MARK: - PUBLIC METHODS
    func getCafeeAccesory() {
        guard selectedCafeeAccesory == nil else { return }
        isLoading = true
        coffeeAccessoryService.getCoffeeAccessory()
            .sink { [weak self] _ in
                self?.isLoading = false
            } receiveValue: { [weak self] cafeeAccesory in
                guard let cafeeAccesory else { return }
                self?.cafeeAccesory = cafeeAccesory
                print("-----")
                print(cafeeAccesory)
                print("-----")
            }
            .store(in: &cancellables)

    }
    
    func createCafeeAccesory() {
  //      coffeeAccessoryService.createCoffeeAccessory(CoffeeAccessoryFireModel(uid: "AAECABFC-D42C-4412-B715-655CB3F58F82", title: "Podwójne espresso2", extraPrice: 3, substitute: false))
    }
    
    
    //TEMP
    
}
