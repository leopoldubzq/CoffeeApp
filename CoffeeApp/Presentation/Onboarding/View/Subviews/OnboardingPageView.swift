import SwiftUI

struct OnboardingPageView: View {
    
    var onboardingPage: OnboardingPage
    
    var body: some View {
        ZStack {
            Image(onboardingPage.imageName)
                .resizable()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .aspectRatio(contentMode: .fill) // Ensure the image fills the available space
                .clipped() // Clip the image to the frame
                .ignoresSafeArea(.all)
                
            VStack(spacing: 12) {
                Spacer()
                Text(onboardingPage.title)
                    .font(.title)
                    .fontWeight(.semibold)
                Text(onboardingPage.description)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .padding(.bottom, 60)
        }
    }
}

#Preview {
    OnboardingPageView(onboardingPage: .onboardingPage1)
}
