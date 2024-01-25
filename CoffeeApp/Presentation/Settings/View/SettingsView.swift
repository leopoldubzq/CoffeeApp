import SwiftUI
enum Settings {
    enum General: String, CaseIterable {
        case orderHistory
        
        var title: String {
            switch self {
            case .orderHistory:
                return "Historia zamówień"
            }
        }
        
        var imageName: String {
            switch self {
            case .orderHistory:
                return "clock.fill"
            }
        }
    }
    
    enum Account: String, CaseIterable {
        case changePassword
        case changeEmail
        
        var title: String {
            switch self {
            case .changePassword:
                return "Zmień hasło"
            case .changeEmail:
                return "Zmień email"
            }
        }
        
        var imageName: String {
            switch self {
            case .changePassword:
                return "key.fill"
            case .changeEmail:
                return "mail.fill"
            }
        }
    }
    
    enum Support: String, CaseIterable {
        case contact
        case termsOfUse
        case privacyPolicy
        case rateApp
        case rateCafe
        
        var title: String {
            switch self {
            case .contact:
                return "Kontakt"
            case .termsOfUse:
                return "Regulamin"
            case .privacyPolicy:
                return "Polityka prywatności"
            case .rateApp:
                return "Oceń aplikację"
            case .rateCafe:
                return "Oceń kawiarnię"
            }
        }
    }
    
    enum RemoveAccount: String {
        case removeAccount
        
        var title: String {
            switch self {
            case .removeAccount:
                return "Usuń konto"
            }
        }
        
        var imageName: String {
            switch self {
            case .removeAccount:
                return "minus.circle"
            }
        }
    }
    
    enum Logout: String {
        case logout
        
        var title: String {
            switch self {
            case .logout:
                return "Wyloguj"
            }
        }
        
        var imageName: String {
            switch self {
            case .logout:
                return "door.left.hand.open"
            }
        }
    }
}

enum SelectedIPadSetting: String {
    case orderHistory
    case changePassword
    case changeEmail
    case contact
    case termsOfUse
    case privacyPolicy
    case rateApp
    case rateCafe
    case removeAccount
    case logout
}

struct SettingsView: View {
    
    @Binding var shouldPresentLoginView: Bool
    @Binding var selectedTab: TabPage
    @State private var route: [String] = []
    @State private var selectedSetting: SelectedIPadSetting = .termsOfUse
    @State private var columnVisibility = NavigationSplitViewVisibility.all
    
    var body: some View {
        if UIDevice.isIPad {
            NavigationSplitView(columnVisibility: $columnVisibility) {
                SettingsContentView()
            } detail: {
                switch selectedSetting {
                case .termsOfUse:
                    Text("Terms of use")
                case .privacyPolicy:
                    HomeView(shouldPresentLoginView: .constant(false))
                default:
                    Text("Settings screen")
                }
            }
            .navigationSplitViewStyle(.balanced)
        } else {
            NavigationStack(path: $route) {
                SettingsContentView()
            }
        }
        
    }
    
    @ViewBuilder
    private func SafeAreaTopView(proxy: GeometryProxy) -> some View {
        Rectangle()
            .fill(Color.init(uiColor: .systemBackground))
            .frame(maxWidth: .infinity)
            .frame(height: proxy.safeAreaInsets.top)
            .ignoresSafeArea(.all)
    }
    
    @ViewBuilder
    private func SettingsContentView() -> some View {
        GeometryReader { proxy in
            VStack {
                List {
                    Section("Ogólne") {
                        ForEach(Settings.General.allCases, id: \.self) { setting in
                            Button {} label: {
                                HStack {
                                    Text(setting.title)
                                    Spacer()
                                    Image(systemName: setting.imageName)
                                }
                            }
                            .foregroundStyle(Color.primary)
                        }
                    }
                    Section("Konto") {
                        ForEach(Settings.Account.allCases, id: \.self) { setting in
                            Button {} label: {
                                HStack {
                                    Text(setting.title)
                                    Spacer()
                                    Image(systemName: setting.imageName)
                                }
                            }
                            .foregroundStyle(Color.primary)
                        }
                    }
                    
                    Section("Wsparcie") {
                        ForEach(Settings.Support.allCases, id: \.self) { setting in
                            Button {
                                selectIPadSetting(with: setting.rawValue)
                                route.append(setting.title)
                            } label: {
                                HStack {
                                    Text(setting.title)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                }
                            }
                            .foregroundStyle(Color.primary)
                        }
                    }
                    
                    Section {
                        Button {} label: {
                            HStack {
                                Text(Settings.RemoveAccount.removeAccount.title)
                                Spacer()
                                Image(systemName: Settings.RemoveAccount.removeAccount.imageName)
                            }
                            .foregroundStyle(Color.red)
                        }
                    }
                    
                    Section {
                        Button {
                            shouldPresentLoginView.toggle()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                selectedTab = .home
                            }
                        } label: {
                            HStack {
                                Text(Settings.Logout.logout.title)
                                Spacer()
                                Image(systemName: Settings.Logout.logout.imageName)
                            }
                            .foregroundStyle(Color.primary)
                        }
                    }
                }
                .navigationTitle("Ustawienia")
            }
            .navigationDestination(for: String.self) { title in
                Text(title)
            }
        }
    }
    
    private func selectIPadSetting(with settingRawValue: String) {
        guard let selectedSetting = SelectedIPadSetting(rawValue: settingRawValue) else { return }
        self.selectedSetting = selectedSetting
    }
}

#Preview {
    MainView(selectedTab: .settings)
}
