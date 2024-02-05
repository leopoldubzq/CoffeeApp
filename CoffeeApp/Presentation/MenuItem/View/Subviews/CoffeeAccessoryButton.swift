import SwiftUI

struct CoffeeAccessoryButton: View {
    
    var title: String
    var extraPrice: Double
    var action: (() -> Void)
    
    var body: some View {
        Button { action() } label: {
            HStack {
                Text(title + (extraPrice > 0 ? " (+\(PriceFormatter.formatToPLN(price: extraPrice)))" : ""))
                Spacer()
                AddProductPlusButton()
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .background(Color("GroupedListCellBackgroundColor"))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .foregroundStyle(Color(uiColor: .label))
    }
}

#Preview {
    CoffeeAccessoryButton(title: "Podwójne espresso", extraPrice: 3.0) {}
}
