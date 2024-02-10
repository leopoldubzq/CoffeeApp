import SwiftUI

struct StampleCell: View {
    
    var isEmpty: Bool
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        Image("stamp")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 45, height: 45)
            .overlay {
                Image(systemName: "checkmark")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 12, height: 12)
                    .foregroundStyle(.white)
            }
            .overlay {
                if isEmpty {
                    Circle()
                        .fill(colorScheme == .dark ? .gray : .white)
                        .frame(width: 38, height: 38)
                }
            }
    }
}

#Preview {
    StampleCell(isEmpty: false)
}
