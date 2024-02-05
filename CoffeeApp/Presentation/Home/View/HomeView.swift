import SwiftUI

struct HomeView: View {
    
    @Binding var shouldPresentLoginView: Bool
    @StateObject private var viewModel = HomeViewModel()
    @State private var route: [Route] = []
    @State private var qrCodeViewIsPresented: Bool = false
    @Namespace private var qrCodeNamespace
    @Namespace private var qrCodeBackgroundNamespace
    @Namespace private var qrCodeStringNamespace
    @State private var scrollOffsetY: CGFloat = 0
    @State private var voucherToActivate: Voucher?
    @State private var coffeeShopPickerExpanded: Bool = false
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        NavigationStack(path: $route) {
            GeometryReader { proxy in
                let size = proxy.size
                OffsetObservingScrollView(offset: $scrollOffsetY) {
                    VStack(spacing: 16) {
                        if viewModel.isLoggedIn {
                            TitleSectionView()
                        } else {
                            LoginTopSectionView()
                        }
                        VStack(spacing: 8) {
                            HStack {
                                CoffeeShopPickerButton()
                                Spacer()
                                    .frame(maxWidth: .infinity)
                            }
                            Text("Godziny otwarcia")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.callout)
                                .foregroundStyle(.accent)
                            Group {
                                Text("pn-pt: ")
                                + Text("9:00 - 19:00")
                                    .fontWeight(.semibold)
                                Text("sb-nd: ")
                                + Text("10:00 - 18:00")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        VouchersText()
                        VouchersList(size: size)

                        Spacer()
                    }
                    .padding(.horizontal, 16)
                }
                .scrollIndicators(.hidden)
                .overlay(alignment: .top) { SafeAreaTopView(proxy: proxy) }
                .overlay {
                    if qrCodeViewIsPresented {
                        QRCodeView(qrCodeViewIsPresented: $qrCodeViewIsPresented,
                                   qrCodeString: "123456789",
                                   qrCodeNamespace: qrCodeNamespace,
                                   qrCodeBackgroundNamespace: qrCodeBackgroundNamespace,
                                   qrCodeStringNamespace: qrCodeStringNamespace)
                    }
                }
                .toolbar(qrCodeViewIsPresented ? .hidden : .visible, for: .tabBar)
                .onChange(of: qrCodeViewIsPresented) { _, _ in
                    HapticManager.shared.impact(.soft)
                }
                .task(id: shouldPresentLoginView) {
                    viewModel.isLoggedIn = !shouldPresentLoginView
                    viewModel.fetchData()
                }
            }
        }
    }
    
    private func getCellWidth(size: CGSize) -> CGFloat {
        let defaultWidth: CGFloat = size.width * 0.8
        return defaultWidth > 350 ? 350 : defaultWidth
    }
    
    @ViewBuilder
    private func QRCodeButton() -> some View {
        Button {
            withAnimation(.snappy(duration: 0.4, extraBounce: 0.04)) {
                qrCodeViewIsPresented.toggle()
            }
        } label: {
            Image(systemName: "qrcode")
                .resizable()
                .matchedGeometryEffect(id: "QRCode", in: qrCodeNamespace)
                .matchedGeometryEffect(id: "QRCodeBackground", in: qrCodeBackgroundNamespace)
                .matchedGeometryEffect(id: "QRCodeString", in: qrCodeStringNamespace)
                .frame(width: 20, height: 20)
                .aspectRatio(contentMode: .fit)
        }
        .frame(width: 44, height: 44)
    }
    
    @ViewBuilder
    private func TitleSectionView() -> some View {
        HStack {
            Group {
                Text("Cześć, ")
                + Text("LEOPOLD!")
                    .foregroundStyle(.accent)
            }
            .minimumScaleFactor(0.95)
            .lineLimit(1)
            .font(.system(size: 28, weight: .semibold))
            .scaleEffect(1 + (scrollOffsetY > 0 ? (scrollOffsetY / 2000) : 0))
            .offset(x: scrollOffsetY > 0 ? (scrollOffsetY / 20) : 0)
            Spacer()
            if !qrCodeViewIsPresented {
                QRCodeButton()
            }
        }
        .frame(height: 44)
    }

    @ViewBuilder
    private func VouchersText() -> some View {
        Text("Kupony")
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundStyle(.secondary)
    }
    
    @ViewBuilder
    private func VouchersList(size: CGSize) -> some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(viewModel.activeVouchers, id: \.id) { voucher in
                    VoucherCell(voucher: voucher,
                                voucherToActivate: $voucherToActivate)
                    .frame(width: getCellWidth(size: size), height: 220)
                    .scrollTransition { content, phase in
                        content
                            .opacity(phase.isIdentity ? 1 : 0.3)
                            .scaleEffect(phase.isIdentity ? 1 : 0.95)
                    }
                }
                if !viewModel.isLoggedIn {
                    Button {} label: {
                        VStack {
                            ZStack {
                                Circle()
                                    .fill(Color.gray.opacity(colorScheme == .dark ? 0.15 : 0.08))
                                    .frame(width: 100, height: 100)
                                Image(systemName: "chevron.right")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 25, height: 25)
                                    .foregroundStyle(Color.init(uiColor: .label))
                            }
                            
                            Text("Zaloguj się")
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.init(uiColor: .label))
                        }
                    }
                    .padding(.leading)
                }
            }
            
            .scrollTargetLayout()
        }
        .scrollIndicators(.hidden)
        .scrollTargetBehavior(.viewAligned)
        .scrollClipDisabled()
        .contentMargins(.trailing, 8)
    }
    
    @ViewBuilder
    private func SafeAreaTopView(proxy: GeometryProxy) -> some View {
        Rectangle()
            .fill(Color.init(uiColor: .systemBackground))
            .frame(maxWidth: .infinity)
            .frame(height: proxy.safeAreaInsets.top)
            .ignoresSafeArea(.all)
    }
    
    @ViewBuilder
    private func LoginTopSectionView() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(colorScheme == .dark ? 0.15 : 0.08))
            VStack(spacing: 8) {
                Text("Zaloguj się do aplikacji aby mieć dostęp do kuponów na kawy!")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fontWeight(.regular)
                Spacer()
                Button {} label: {
                    Text("Zaloguj się")
                        .foregroundStyle(Color.white)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(.accent)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding()
        }
    }
    
    @ViewBuilder
    private func CoffeeShopPickerButton() -> some View {
        Button {
            withAnimation(.snappy(duration: 0.35, extraBounce: 0.08)) {
                coffeeShopPickerExpanded.toggle()
            }
        } label: {
            HStack {
                Text("CostaCoffee")
                    .font(.callout)
                Image(systemName: "chevron.down")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 12, height: 12)
                    .rotationEffect(.degrees(coffeeShopPickerExpanded ? 180 : 0))
                Spacer()
            }
        }
        .foregroundStyle(.secondary)
    }
}

#Preview {
    MainView(selectedTab: .home)
}

