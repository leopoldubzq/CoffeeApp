import SwiftUI

enum Route: Hashable {
    case main
    case cafeDetails(CafeDto)
    case createProfile(UserDto)
}

extension Route {
    @ViewBuilder
    func handleDestination(route: Binding<[Route]>, callback: (() -> Void)? = nil) -> some View {
        switch self {
        case .main:
            Text("Main")
        case .cafeDetails(let cafe):
            CafeDetailsView(cafe: cafe)
        case .createProfile(let user):
            CreateUserProfileView(user: user) { callback?() }
        }
    }
}
