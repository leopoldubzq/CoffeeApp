import SwiftUI
import Firebase

final class ChooseCafeViewModel: BaseViewModel, AuthProtocol {
    
    //MARK: - PUBLIC PROPERTIES
    @Published var searchText: String = ""
    @Published var selectedCafe: CafeDto?
    @Published var cafes: [CafeDto] = []
    
    //MARK: - PRIVATE PROPERTIES
    private let cafeService = CafeService()
    
    override init() {
        super.init()
        cafes = CafeDto.mock
    }
    
    //MARK: - PUBLIC METHODS
    func getCafes() {
        guard isLoggedIn() else { return }
        isLoading = true
        cafeService.getCafes()
            .sink { [weak self] _ in
                self?.isLoading = false
            } receiveValue: { [weak self] cafes in
                guard let cafes else { return }
                self?.cafes = cafes
            }
            .store(in: &cancellables)

    }
    
    
}
