import SwiftUI

@main
struct CoffeeAppApp: App {
    
    @State private var splashVisible: Bool = true
    
    var body: some Scene {
        WindowGroup {
            MainView()
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
//            .onAppear {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                    withAnimation(.easeInOut(duration: 0.35)) { splashVisible.toggle() }
//                }
//            }
    }
}
