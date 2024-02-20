import SwiftUI

struct SelectedCoffeeAccessoryButton: View {
    
    var accessory: any CoffeeAccessoryTypeProtocol
    var action: (() -> ())
    
    var body: some View {
        Button { action() } label: {
            HStack(spacing: 8) {
                Text(accessory.title + getExtraPrice(from: accessory))
                Image(systemName: "xmark")
                    .resizable()
                    .frame(width: 8, height: 8)
            }
            .padding(.vertical, 8)
            .padding(.horizontal)
            .background(Color("GroupedListCellBackgroundColor"))
            .clipShape(Capsule())
        }
        .foregroundStyle(Color.init(uiColor: .label))
    }
    
    private func getExtraPrice(from accessory: any CoffeeAccessoryTypeProtocol) -> String {
        accessory.extraPrice > 0 ? " (+\(PriceFormatter.formatToPLN(price: accessory.extraPrice)))" : ""
    }
}

//#Preview {
//    SelectedCoffeeAccessoryButton(accessory: .sugar) {}
//}
