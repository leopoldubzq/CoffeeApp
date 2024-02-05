import SwiftUI

struct LoginView: View {
    
    @Binding var shouldPresentLoginView: Bool
    @State private var imageAnimationTrigger: Bool = false
    @Environment(\.colorScheme) var colorScheme
    @AppStorage(AppStorageKeys.isLoggedIn.rawValue) private var isLoggedIn: Bool = false
    @StateObject private var viewModel = LoginViewModel()
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            ZStack {
                Image("onboarding_page_1")
                    .resizable()
                    .scaledToFill()
                    .frame(width: size.width, height: size.height)
                    .clipped()
                    .overlay {
                        VisualEffectView(effect: UIBlurEffect(style: colorScheme == .dark ? .dark : .light))
                    }
                VStack(spacing: 16) {
                    Spacer()
                    LoginWithGoogleButton(size: size) { viewModel.loginWithGoogle() }
                    LoginWithEmailButton(size: size) {
                        shouldPresentLoginView.toggle()
                    }
                }
                .safeAreaPadding(.bottom)
                .padding(.bottom, 32)
                .frame(maxWidth: .infinity)
                .overlay {
                    HStack(spacing: 12) {
                        Image(systemName: "cup.and.saucer.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 44, height: 44)
                            .symbolEffect(.pulse, value: imageAnimationTrigger)
                            .onAppear { imageAnimationTrigger.toggle() }
                        VStack {
                            Text("CoffeeApp")
                                .fontWeight(.semibold)
                                .font(.system(size: 32))
                            Text("Just drink and enjoy")
                                .foregroundStyle(.secondary)
                                .font(.system(size: 14))
                        }
                    }
                    .onReceive(timer, perform: { _ in
                        imageAnimationTrigger.toggle()
                    })
                }
            }
            .onChange(of: viewModel.shouldPresentLogin) { _, newValue in
                isLoggedIn = newValue
                shouldPresentLoginView = newValue
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView("Wczytywanie danych")
                        .foregroundStyle(.white)
                        .offset(y: 80)
                }
            }
        }
        .ignoresSafeArea(.all)
    }
}

#Preview {
    LoginView(shouldPresentLoginView: .constant(false))
}
