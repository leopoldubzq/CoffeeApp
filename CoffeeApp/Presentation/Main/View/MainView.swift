import SwiftUI

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

struct MainView: View {
    
    @State var selectedTab: TabPage = .home
    @State private var imageAnimationTrigger: Bool = false
    @State private var shouldFinishOnboarding: Bool = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: TabPage.home.imageName)
                    Text(TabPage.home.title)
                }
                .tag(TabPage.home)
            CoffeesListView()
                .tabItem {
                    Image(systemName: TabPage.menu.imageName)
                    Text(TabPage.menu.title)
                }
                .tag(TabPage.menu)
            SettingsView()
                .tabItem {
                    Image(systemName: TabPage.settings.imageName)
                    Text(TabPage.settings.title)
                }
                .tag(TabPage.settings)
        }
        .onChange(of: selectedTab) { _, _ in
            HapticManager.shared.impact(.medium)
        }
//        .overlay {
//            if !shouldFinishOnboarding {
//                ZStack {
//                    VisualEffectView(effect: UIBlurEffect(style: colorScheme == .dark ? .dark : .light))
//                    OnboardingView(shouldFinishOnboarding: $shouldFinishOnboarding)
//                }
//                .ignoresSafeArea(.all)
//            }
//        }
    }
}

#Preview {
    MainView(selectedTab: .home)
}
