import SwiftUI

struct OnboardingPageView: View {
    
    var onboardingPage: OnboardingPage
    
    var body: some View {
        GeometryReader { proxy in
            
            let size = proxy.frame(in: .scrollView(axis: .horizontal)).size
            
            ZStack {
                Image(onboardingPage.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height)
                    .overlay {
                        Rectangle()
                            .fill(
                                .linearGradient(colors: [
                                    Color.black.opacity(0.8),
                                    Color.black.opacity(0.6),
                                    Color.black.opacity(0.5),
                                    Color.black.opacity(0.4),
                                    Color.black.opacity(0.1)
                                ], startPoint: .bottom, endPoint: .center)
                            )
                            .ignoresSafeArea(.all)
                            
                    }
                VStack(spacing: 12) {
                    Spacer()
                    Text(onboardingPage.title)
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                    Text(onboardingPage.description)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.white)
                }
                .padding()
                .padding(.bottom, 60)
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.all)
    }
}

#Preview {
    OnboardingPageView(onboardingPage: .onboardingPage1)
}
