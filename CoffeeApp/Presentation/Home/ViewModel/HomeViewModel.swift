import SwiftUI
import Firebase
import Combine

final class HomeViewModel: BaseViewModel, AuthProtocol {
    @Published var user: UserDto?
    @Published var currentCafe: CafeDto?
    @Published var stamps: [StampDto] = []
    @Published var coupons: [CouponDto] = []
    
    private let userService = UserService()
    private let cafeService = CafeService()
    
    func createCoupons() {
        if let cafe = currentCafe {
            isLoading = true
            cafeService.createCoupons(for: cafe)
                .receive(on: DispatchQueue.main)
                .compactMap(\.?.coupons)
                .sink { [weak self] _ in
                    HapticManager.shared.impact(.medium)
                    self?.isLoading = false
                } receiveValue: { [weak self] coupons in
                    self?.coupons = coupons
                }
                .store(in: &cancellables)
        }
    }
    
    func addStamps(count: Int) {
        guard isLoggedIn(), let currentCafe = user?.currentCafe, let user else { return }
        isLoading = true
        userService.addStamps(count: count, to: currentCafe, for: user)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.isLoading = false
                HapticManager.shared.impact(.medium)
            } receiveValue: { [weak self] cafeStamps in
                self?.user?.cafeStamps = cafeStamps
                if let self, let user = self.user {
                    stamps = getStamps(user: user)
                }
            }
            .store(in: &cancellables)
    }
    
    func getUser() {
        guard isLoggedIn() else { return }
        print("Fetch data")
        isLoading = true
        Publishers
            .Zip(userService.getUser(uid: getUserUid()), cafeService.getCafes())
            .flatMap { [weak self] user, cafes in
                guard let self, var user, let cafes else {
                    return Fail<UserDto?, CAError>(error: .basicError("Could not unwrap values"))
                        .eraseToAnyPublisher()
                }
                user.cafeStamps = getCafeStamps(cafes: cafes, user: user)
                return userService.updateUser(user: user)
            }
            .compactMap { $0 }
            .sink { [weak self] _ in
                self?.isLoading = false
                HapticManager.shared.impact(.medium)
            } receiveValue: { [weak self] user in
                guard let self else { return }
                self.user = user
                self.stamps = getStamps(user: user)
                self.currentCafe = user.currentCafe
                self.coupons = user.currentCafe?.coupons ?? []
            }
            .store(in: &cancellables)
    }
    
    func updateUser() {
        guard isLoggedIn() else { return }
        print("Update user")
        if let user {
            isLoading = true
            userService.updateUser(user: user)
                .compactMap { $0 }
                .sink { [weak self] _ in
                    self?.isLoading = false
                    HapticManager.shared.impact(.medium)
                } receiveValue: { [weak self] user in
                    guard let self else { return }
                    self.user = user
                    self.currentCafe = user.currentCafe
                    self.stamps = self.getStamps(user: user)
                    self.coupons = user.currentCafe?.coupons ?? []
                }
                .store(in: &cancellables)

        }
    }
    
    func getActiveVouchersCount() -> Int {
        let value = Int(CGFloat(stamps.count) / CGFloat(Constants.stampsPerVoucher))
        return stamps.count < Constants.stampsPerVoucher ? 0 : value
    }
    
    private func getStamps(user: UserDto) -> [StampDto] {
        let stampsCount = user.cafeStamps.first(where: { $0.0 == user.currentCafe?.uid })?.1 ?? 0
        return Array(repeating: StampDto(uid: UUID().uuidString), count: stampsCount)
    }
    
    private func getCafeStamps(cafes: [CafeDto], user: UserDto) -> [String : Int] {
        var cafeStamps: [String : Int] = user.cafeStamps
        for cafe in cafes {
            let cafeUid = cafe.uid
            let stampsCount = user.cafeStamps.first(where: { $0.0 == cafe.uid })?.1 ?? 0
            cafeStamps.updateValue(stampsCount, forKey: cafeUid)
        }
        return cafeStamps
    }
    
    
    //TEMP
    @Published var selectedCafeeAccesory: CoffeeAccessoryFireModel?
    @Published var cafeeAccesory: [CoffeeAccessoryFireModel] = []
    
    //MARK: - PRIVATE PROPERTIES
    private let coffeeAccessoryService = CoffeeAccessoryService()
    
    //MARK: - PUBLIC METHODS
    func getCafeeAccesory() {
        guard selectedCafeeAccesory == nil else { return }
        coffeeAccessoryService.getCoffeeAccessory()
            .sink { [weak self] _ in
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
