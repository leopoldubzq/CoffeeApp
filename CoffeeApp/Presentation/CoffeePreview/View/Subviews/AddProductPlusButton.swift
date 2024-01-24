import SwiftUI

struct AddProductPlusButton: View {
    var body: some View {
        Circle()
            .fill(.accent)
            .frame(width: 20, height: 20)
            .overlay {
                Image(systemName: "plus")
                    .resizable()
                    .foregroundStyle(.white)
                    .frame(width: 10, height: 10)
            }
    }
}

#Preview {
    AddProductPlusButton()
}
