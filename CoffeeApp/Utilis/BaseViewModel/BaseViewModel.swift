import SwiftUI
import Combine

class BaseViewModel: ObservableObject {
    var cancellables = Set<AnyCancellable>()
    @Published var isLoading: Bool = false
}
