import SwiftUI
import Firebase

final class ChooseCafeViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var cafes: [CafeDto] = []
    
    init() {
        cafes = CafeDto.mock
    }
}
