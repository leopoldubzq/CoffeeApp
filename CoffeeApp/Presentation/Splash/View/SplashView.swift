import SwiftUI

struct SplashView: View {
    
    @State private var imageAnimationTrigger: Bool = false
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
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

#Preview {
    SplashView()
}
