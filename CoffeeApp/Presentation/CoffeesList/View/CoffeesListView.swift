import SwiftUI

enum ListAppearanceType {
    case horizontal
    case vertical
    
    var title: String {
        switch self {
        case .horizontal:
            return "Pionowo"
        case .vertical:
            return "Poziomo"
        }
    }
    
    var imageName: String {
        switch self {
        case .horizontal:
            return "square.split.2x2"
        case .vertical:
            return "rectangle.split.3x1"
        }
    }
    
    var imageRotationDegrees: CGFloat {
        switch self {
        case .horizontal:
            return 90
        case .vertical:
            return 0
        }
    }
}

struct CoffeesListView: View {
    
    var coffees: [CoffeeDto] = [CoffeeDto(title: "Cappuccino", price: 18.00, imageName: "cappuccino", accessories: [.sugar, .doubleEspresso]),
                                CoffeeDto(title: "Espresso", price: 7.00, imageName: "espresso", accessories: [.sugar]),
                                CoffeeDto(title: "Cappuccino", price: 18.00, imageName: "cappuccino", accessories: [.sugar, .doubleEspresso]),
                                CoffeeDto(title: "Espresso", price: 7.00, imageName: "espresso", accessories: [.sugar]),
                                CoffeeDto(title: "Cappuccino", price: 18.00, imageName: "cappuccino", accessories: [.sugar, .doubleEspresso]),
                                CoffeeDto(title: "Espresso", price: 7.00, imageName: "espresso", accessories: [.sugar]),
                                CoffeeDto(title: "Cappuccino", price: 18.00, imageName: "cappuccino", accessories: [.sugar, .doubleEspresso]),
                                CoffeeDto(title: "Espresso", price: 7.00, imageName: "espresso", accessories: [.sugar])]
    
    @State private var coffeePreviewVisible: Bool = false
    @State private var selectedCoffee: CoffeeDto?
    @State private var selectedMenuType: Menu = .coffees
    @State private var spacing: CGFloat = 0
    @State private var rotation: CGFloat = 40
    @State private var enableReflection: Bool = false
    @State private var listAppearance: ListAppearanceType = .horizontal
    @State private var scrollOffsetY: CGFloat = 0
    @State private var shouldHideAppearanceSection: Bool = false
    
    @Namespace private var coffeeImageNamespace
    @Namespace private var coffeeTitleNamespace
    @Namespace private var coffeePriceNamespace
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            VStack {
                ScrollViewReader { scrollView in
                    ScrollView(.horizontal) {
                        HStack(spacing: 16) {
                            ForEach(Menu.allCases, id: \.self) { menuItem in
                                
                                VStack(spacing: 6) {
                                    Text(menuItem.title)
                                        .foregroundStyle(Color.init(uiColor: .label))
                                        .fontWeight(selectedMenuType == menuItem ? .bold : .regular)
                                    Rectangle()
                                        .fill(selectedMenuType == menuItem ? .accent : .clear)
                                        .frame(height: 2)
                                }
                                .frame(height: 50)
                                .onTapGesture {
                                    selectedMenuType = menuItem
                                    withAnimation {
                                        scrollView.scrollTo(menuItem, anchor: .center)
                                    }
                                }
                            }
                        }
                    }
                    .scrollIndicators(.hidden)
                    .contentMargins(.horizontal, 16)
                    
                }
                HStack {
                    Button { changeListAppearance() } label: {
                        HStack(spacing: 4) {
                            Image(systemName: listAppearance.imageName)
                                .rotationEffect(.degrees(listAppearance.imageRotationDegrees))
                            Text(listAppearance.title)
                                .fontWeight(.semibold)
                        }
                        .foregroundStyle(Color.white)
                        .padding(6)
                        .padding(.horizontal, 2)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                if listAppearance == .horizontal {
                    Spacer()
                    CoverFlowView(itemWidth: getCoffeeItemWidth(size: size),
                                  enableReflection: false,
                                  spacing: spacing,
                                  rotation: rotation,
                                  items: coffees) { coffee in
                        CoffeeCell(coffee: coffee,
                                   size: size,
                                   selectedCoffee: $selectedCoffee,
                                   coffeePreviewVisible: $coffeePreviewVisible,
                                   listAppearance: $listAppearance,
                                   coffeeTitleNamespace: coffeeTitleNamespace,
                                   coffeePriceNamespace: coffeePriceNamespace,
                                   coffeeImageNamespace: coffeeImageNamespace)
                    }
                    .frame(height: size.height * 0.6)
                    Spacer(minLength: size.height * 0.17)
                } else {
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: GridItem(), count: 2)) {
                            ForEach(coffees) { coffee in
                                CoffeeCell(coffee: coffee,
                                           size: size,
                                           selectedCoffee: $selectedCoffee,
                                           coffeePreviewVisible: $coffeePreviewVisible,
                                           listAppearance: $listAppearance,
                                           coffeeTitleNamespace: coffeeTitleNamespace,
                                           coffeePriceNamespace: coffeePriceNamespace,
                                           coffeeImageNamespace: coffeeImageNamespace)
                                .scrollTransition { content, phase in
                                    content
                                        .scaleEffect(phase.isIdentity ? 1 : 0.9)
                                        .opacity(phase.isIdentity ? 1 : 0.5)
                                }
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .scrollIndicators(.hidden)
                    .padding(.horizontal)
                    .padding(.top)
                }
            }
            .overlay {
                if coffeePreviewVisible, let selectedCoffee {
                    CoffeePreview(coffeePreviewVisible: $coffeePreviewVisible,
                                  coffee: selectedCoffee,
                                  coffeeImageNamespace: coffeeImageNamespace,
                                  coffeeTitleNamespace: coffeeTitleNamespace,
                                  coffeePriceNamespace: coffeePriceNamespace)
                }
            }
            .onChange(of: selectedMenuType) { _, _ in
                HapticManager.shared.impact(.medium)
            }
        }
    }
    
    private func changeListAppearance() {
        HapticManager.shared.impact(.soft)
        withAnimation(.snappy(duration: 0.3)) {
            listAppearance = listAppearance == .horizontal ? .vertical : .horizontal
        }
    }
    
    private func getCoffeeItemWidth(size: CGSize) -> CGFloat {
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            return UIDevice.isIPad ? size.width * 0.9 : size.width * 0.6
        case .portrait:
            return UIDevice.isIPad ? size.width * 0.65 : size.width * 0.6
        default:
            return size.width * 0.6
        }
    }
    
    private func getOffsetXValue(phase: ScrollTransitionPhase, size: CGSize) -> CGFloat {
        let offsetXValue = size.width * 0.4
        return phase.isIdentity ? 0 : offsetXValue
    }
}

#Preview {
    MainView(selectedTab: .menu)
}
