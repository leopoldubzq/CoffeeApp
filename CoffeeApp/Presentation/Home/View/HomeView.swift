import SwiftUI
import FirebaseFirestoreSwift
import Firebase
import Shimmer

struct HomeView: View {
    
    @Binding var shouldPresentLoginView: Bool
    @StateObject private var viewModel = HomeViewModel()
    @State private var route: [Route] = []
    @State private var qrCodeViewIsPresented: Bool = false
    @Namespace private var qrCodeNamespace
    @Namespace private var qrCodeBackgroundNamespace
    @Namespace private var qrCodeStringNamespace
    @State private var scrollOffsetY: CGFloat = 0
    @State private var couponToActivate: CouponDto?
    @State private var cafeViewPresented: Bool = false
    @State private var stampsAlertIsPresented: Bool = false
    @State private var stampsCountString: String = ""
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        NavigationStack(path: $route) {
            GeometryReader { proxy in
                let size = proxy.size
                OffsetObservingScrollView(offset: $scrollOffsetY) {
                    VStack(spacing: 16) {
                        TitleSectionView()
                        VStack(spacing: 8) {
                            HStack {
                                CoffeeShopPickerButton()
                                Spacer()
                                    .frame(maxWidth: .infinity)
                            }
                            .showPlaceholder($viewModel.isLoading)
                            Text("Godziny otwarcia")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.callout)
                                .foregroundStyle(.accent)
                                .showPlaceholder($viewModel.isLoading)
                            Group {
                                Text("pn-pt: ")
                                    .foregroundStyle(.secondary)
                                + Text("9:00 - 19:00")
                                    .fontWeight(.semibold)
                                Text("sb-nd: ")
                                    .foregroundStyle(.secondary)
                                + Text("10:00 - 18:00")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .showPlaceholder($viewModel.isLoading)
                        }
                        if viewModel.stamps.count > 0 {
                            if viewModel.getActiveVouchersCount() > 0 {
                                RewardsAmountInfoText()
                                    .showPlaceholder($viewModel.isLoading)
                            } else {
                                StampsLeftInfoText()
                                    .showPlaceholder($viewModel.isLoading)
                            }
                            VoucherView(userStamps: $viewModel.stamps)
                                .showPlaceholder($viewModel.isLoading)
                        }
                        VouchersText()
                            .showPlaceholder($viewModel.isLoading)
                        VouchersList(size: size)
                            .showPlaceholder($viewModel.isLoading)
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .animation(.easeInOut(duration: 0.2), value: viewModel.stamps)
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
                .sheet(isPresented: $cafeViewPresented) {
                    ChooseCafeView(selectedCafe: $viewModel.currentCafe) {
                        guard viewModel.user?.currentCafe != viewModel.currentCafe else { return }
                        viewModel.user?.currentCafe = viewModel.currentCafe
                        viewModel.updateUser()
                    }
                }
                .onChange(of: qrCodeViewIsPresented) { _, _ in
                    HapticManager.shared.impact(.soft)
                }
                .onChange(of: shouldPresentLoginView, { _, _ in
                    viewModel.getUser()
                })
                .alert("Dodaj pieczątki", 
                       isPresented: $stampsAlertIsPresented,
                       actions: {
                    TextField("Pieczątki", text: $stampsCountString)
                        .keyboardType(.numberPad)
                    Button("Ok") {
                        if let stampsCount = Int(stampsCountString) {
                            viewModel.addStamps(count: stampsCount)
                        }
                    }
                })
                .onLoad { viewModel.getUser() }
            }
        }
    }
    
    private func getCellWidth(size: CGSize) -> CGFloat {
        let defaultWidth: CGFloat = size.width * 0.8
        return defaultWidth > 350 ? 350 : defaultWidth
    }
    
    @ViewBuilder
    private func RewardsAmountInfoText() -> some View {
        Group {
            Text("Masz do wykorzystania ")
                .foregroundStyle(.secondary)
            + Text("\(viewModel.getActiveVouchersCount())")
                .foregroundStyle(.primary)
                .fontWeight(.semibold)
            + Text(" \(PluralizedString.reward(viewModel.getActiveVouchersCount()).pluralized)")
                .foregroundStyle(.secondary)
        }
        .contentTransition(.numericText())
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder
    private func StampsLeftInfoText() -> some View {
        Group {
            Text("Brakuje ci ")
                .foregroundStyle(.secondary)
            + Text("\(Constants.stampsPerVoucher - viewModel.stamps.count)")
                .fontWeight(.semibold)
                .foregroundStyle(.accent)
            + Text(" \(PluralizedString.stamps(viewModel.getActiveVouchersCount()).pluralized) do otrzymania nagrody")
                .foregroundStyle(.secondary)
        }
        .contentTransition(.numericText())
        .frame(maxWidth: .infinity, alignment: .leading)
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
                + Text("\((viewModel.user?.name ?? "Preview User").uppercased())!")
                    .foregroundStyle(.accent)
            }
            .minimumScaleFactor(0.95)
            .lineLimit(1)
            .font(.system(size: 28, weight: .semibold))
            .scaleEffect(1 + (scrollOffsetY > 0 ? (scrollOffsetY / 2000) : 0))
            .offset(x: scrollOffsetY > 0 ? (scrollOffsetY / 20) : 0)
            Spacer()
            Button { stampsAlertIsPresented.toggle() } label: {
                Image(systemName: "plus")
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(Color.init(uiColor: .label))
            }
            if !qrCodeViewIsPresented {
                QRCodeButton()
            }
        }
        .frame(height: 44)
        .showPlaceholder($viewModel.isLoading)
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
                ForEach(viewModel.coupons, id: \.uid) { coupon in
                    CouponCell(coupon: coupon, couponToActivate: $couponToActivate)
                        .frame(width: getCellWidth(size: size), height: 220)
                        .scrollTransition { content, phase in
                            content
                                .opacity(phase.isIdentity ? 1 : 0.3)
                                .scaleEffect(phase.isIdentity ? 1 : 0.95)
                        }
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
            HapticManager.shared.impact(.soft)
            withAnimation(.snappy(duration: 0.35, extraBounce: 0.08)) {
                cafeViewPresented.toggle()
            }
        } label: {
            HStack {
                Text(viewModel.user?.currentCafe?.title ?? "Preview Cafe")
                    .font(.callout)
                Image(systemName: "chevron.down")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 12, height: 12)
                Spacer()
            }
        }
        .foregroundStyle(.secondary)
    }
}

#Preview {
    HomeView(shouldPresentLoginView: .constant(false))
}

