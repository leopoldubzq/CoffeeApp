import SwiftUI

struct LoginWithGoogleButton: View {
    
    var size: CGSize
    var action: VoidCallback
    
    var body: some View {
        Button { action() } label: {
            HStack {
                Image("google_logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
                Text("Login with Google")
                    .foregroundStyle(Color.primary)
                    .font(.headline)
            }
            .frame(width: size.width * 0.6)
            .padding(.vertical, 8)
            .background(
                Rectangle()
                    .fill(Color("GroupedListCellBackgroundColor"))
                    .clipShape(Capsule())
            )
            .overlay {
                Rectangle()
                    .foregroundStyle(Color.init(uiColor: .label))
                    .clipShape(Capsule().stroke(lineWidth: 1))
            }
        }
    }
}

#Preview {
    LoginView()
}

