import SwiftUI

final class HomeViewModel: BaseViewModel {
    @Published var activeVouchers: [Voucher] = Voucher.mocks
    @Published var isLoggedIn: Bool = true
    
    override init() {
        super.init()
        setupActiveVouchersArray()
    }
    
    func fetchData() {
        guard isLoggedIn else { return }
        print("Fetch data")
    }
    
    private func setupActiveVouchersArray() {
        if isLoggedIn {
            activeVouchers = Voucher.mocks
        } else {
            activeVouchers = Voucher.mocks.count > 3 ? Array(Voucher.mocks[0...2]) : Voucher.mocks
        }
    }
    
    
}
