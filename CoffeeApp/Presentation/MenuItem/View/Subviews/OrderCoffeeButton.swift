import SwiftUI

struct OrderCoffeeButton: View {
    
    @Binding var coffeePreviewVisible: Bool
    var safeAreaBottom: CGFloat
    
    var body: some View {
        Button {
            coffeePreviewVisible = false
        } label: {
            Text("Zamów")
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.accent)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.bottom, safeAreaBottom + 16)
                .padding(.horizontal)
        }
    }
}

#Preview {
    OrderCoffeeButton(coffeePreviewVisible: .constant(true), safeAreaBottom: 0)
}
