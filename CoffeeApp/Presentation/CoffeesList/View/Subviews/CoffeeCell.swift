import SwiftUI

struct CoffeeCell: View {
    
    var coffee: CoffeeDto
    var size: CGSize
    @Binding var selectedCoffee: CoffeeDto?
    @Binding var coffeePreviewVisible: Bool
    @Binding var listAppearance: ListAppearanceType
    var coffeeTitleNamespace: Namespace.ID
    var coffeePriceNamespace: Namespace.ID
    var coffeeImageNamespace: Namespace.ID
    
    var body: some View {
        VStack {
            Text(coffee.title)
                .matchedGeometryEffect(id: coffee.titleMatchedGeometryID, in: coffeeTitleNamespace)
                .fontWeight(.semibold)
                .font(.system(size: 24))
                .padding(.bottom, 4)
                .minimumScaleFactor(0.5)
            Text(PriceFormatter.formatToPLN(price: coffee.price))
                .matchedGeometryEffect(id: coffee.priceMatchedGeometryID, in: coffeePriceNamespace)
                .minimumScaleFactor(0.8)
            Image(coffee.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .matchedGeometryEffect(id: coffee.imageMatchedGeometryID, in: coffeeImageNamespace)
                .frame(width: getImageDimensions(), height: getImageDimensions())
                .background(Color.red)
        }
        .onTapGesture {
            HapticManager.shared.impact(.soft)
            selectedCoffee = coffee
            withAnimation(.snappy(duration: 0.35, extraBounce: 0.07)) {
                coffeePreviewVisible.toggle()
            }
        }
        .onAppear {
            print("")
        }
    }
    
    private func getImageDimensions() -> CGFloat {
        switch listAppearance {
        case .horizontal:
            return size.height * 0.35
        case .vertical:
            return size.height * 0.25
        }
    }
}

#Preview {
    CoffeesListView()
}
