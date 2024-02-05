import SwiftUI

enum OnboardingPage: CaseIterable {
    case onboardingPage1
    case onboardingPage2
    case onboardingPage3
    case onboardingPage4
    
    var color: Color {
        switch self {
        case .onboardingPage1:
            return .orange
        case .onboardingPage2:
            return .red
        case .onboardingPage3:
            return .blue
        case .onboardingPage4:
            return .teal
        }
    }
    
    var title: String {
        return "Welcome!"
    }
    
    var description: String {
        return "Welcome to CoffeeApp, your go-to app for ordering delicious coffee from the best cafes around. Explore a world of rich flavors and convenient ordering at your fingertips. Let's get started!"
    }
    
    var imageName: String {
        return "onboarding_page_1"
    }
}

struct OnboardingView: View {
    
    @Binding var shouldFinishOnboarding: Bool
    @AppStorage(AppStorageKeys.hasSeenOnboarding.rawValue) var hasSeenOnboarding: Bool = false
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView(.horizontal) {
                HStack(spacing: 0) {
                    ForEach(OnboardingPage.allCases, id: \.self) { page in
                        OnboardingPageView(onboardingPage: page)
                            .frame(width: proxy.size.width, height: proxy.size.height)
                            .overlay(alignment: .bottomTrailing) {
                                if page == OnboardingPage.allCases.last {
                                    Button {
                                        hasSeenOnboarding = true
                                    } label: {
                                        ZStack {
                                            Circle()
                                                .fill(Color("Smoked"))
                                                .frame(width: 44, height: 44)
                                            Image(systemName: "chevron.right")
                                        }
                                    }
                                    .foregroundStyle(.white)
                                    .padding()
                                    .safeAreaPadding([.bottom])
                                    .padding(.bottom, -12)
                                    .padding(.trailing, 8)
                                }
                            }
                    }
                }
                .scrollTargetLayout()
                .overlay(alignment: .bottom) {
                    CustomPagingIndicator(activeTint: .white, inActiveTint: .secondary,
                                          cellItemPadding: 0, cellItemSpacing: 0, opacityEffect: true,
                                          clipEdges: false)
                    .padding(.bottom)
                }
            }
            .ignoresSafeArea(edges: .top)
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.paging)
            .overlay(alignment: .topTrailing) {
                Button { hasSeenOnboarding = true } label: {
                    Text("Skip")
                        .foregroundStyle(.white)
                }
                .padding(32)
                .padding(.top, UIDevice.isIPhone ? 24 : 0)
                .font(.headline)
                .fontWeight(.bold)
            }
        }
        .ignoresSafeArea(.all)
    }
}

#Preview {
    OnboardingView(shouldFinishOnboarding: .constant(false))
}
