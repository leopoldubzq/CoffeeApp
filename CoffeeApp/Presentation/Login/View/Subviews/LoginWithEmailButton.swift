import SwiftUI

struct LoginWithEmailButton: View {
    
    var size: CGSize
    var actionCallback: VoidCallback
    
    var body: some View {
        Button {
            HapticManager.shared.impact(.soft)
            actionCallback()
        } label: {
            HStack(alignment: .center) {
                Image(systemName: "envelope")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
                    
                Text("Login with email")
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
    LoginView(shouldPresentLoginView: .constant(false))
}
