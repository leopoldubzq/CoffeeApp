import Foundation

enum TabPage: CaseIterable {
    case home
    case menu
    case settings
    
    var title: String {
        switch self {
        case .home:
            return "start"
        case .menu:
            return "menu"
        case .settings:
            return "ustawienia"
        }
    }
    
    var imageName: String {
        switch self {
        case .home:
            return "house.fill"
        case .menu:
            return "menucard"
        case .settings:
            return "gearshape.fill"
        }
    }
}
