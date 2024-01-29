import SwiftUI
import Firebase

struct MainView: View {
    
    @State var selectedTab: TabPage = .home
    @State private var imageAnimationTrigger: Bool = false
    @State private var shouldFinishOnboarding: Bool = false
    @State private var viewModel = MainViewModel()
    @State private var shouldPresentLoginView: Bool = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(shouldPresentLoginView: $shouldPresentLoginView)
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
            SettingsView(shouldPresentLoginView: $shouldPresentLoginView,
                         selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: TabPage.settings.imageName)
                    Text(TabPage.settings.title)
                }
                .tag(TabPage.settings)
        }
        .onChange(of: selectedTab) { _, _ in
            HapticManager.shared.impact(.medium)
        }
        .fullScreenCover(isPresented: $shouldPresentLoginView, content: {
            LoginView(shouldPresentLoginView: $shouldPresentLoginView)
        })
        .onAppear {
            shouldPresentLoginView = Auth.auth().currentUser == nil
        }
        .overlay {
            if !shouldPresentLoginView && !shouldFinishOnboarding {
                ZStack {
                    VisualEffectView(effect: UIBlurEffect(style: colorScheme == .dark ? .dark : .light))
                    OnboardingView(shouldFinishOnboarding: $shouldFinishOnboarding)
                }
                .ignoresSafeArea(.all)
            }
        }
    }
}

#Preview {
    MainView(selectedTab: .home)
}
