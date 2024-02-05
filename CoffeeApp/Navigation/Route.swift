import SwiftUI

enum Route: Hashable {
    case main
    case cafeDetails(CafeDto)
}

extension Route {
    @ViewBuilder
    func handleDestination(route: Binding<[Route]>) -> some View {
        switch self {
        case .main:
            Text("Main")
        case .cafeDetails(let cafe):
            CafeDetailsView(cafe: cafe)
        }
    }
}
