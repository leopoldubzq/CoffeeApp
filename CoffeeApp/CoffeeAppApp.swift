import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct CoffeeAppApp: App {
    
    @State private var splashVisible: Bool = true
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            showInitialScreen()
        }
    }
    
    @ViewBuilder
    private func showInitialScreen() -> some View {
        MainView()
//            .overlay {
//                if splashVisible {
//                    SplashView()
//                        .frame(maxWidth: .infinity, maxHeight: .infinity)
//                        .background(Color.init(uiColor: .systemBackground))
//                        .opacity(splashVisible ? 1 : 0)
//                }
//            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation(.easeInOut(duration: 0.35)) { splashVisible.toggle() }
                }
            }
    }
}
