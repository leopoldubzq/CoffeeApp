import SwiftUI
import Firebase
import FirebaseFirestoreSwift

enum VoucherStampsAppearance {
    case all
    case active
    
    var title: String {
        switch self {
        case .all:
            return "Wszystkie"
        case .active:
            return "Aktywne"
        }
    }
}

struct StampView: View {
    
    @State private var voucherStampsAppearance: VoucherStampsAppearance = .all
    @Environment(\.colorScheme) private var colorScheme
    @Binding private var userStamps: [StampDto]
    
    init(userStamps: Binding<[StampDto]>) {
        self._userStamps = userStamps
    }
    
    var body: some View {
        if !userStamps.isEmpty {
            VouchersList()
        } else {
            NoResultsView()
        }
    }
    
    @ViewBuilder
    private func VouchersList() -> some View {
        ScrollView {
            VStack {
                ActiveStampsCountText()
                    .padding([.leading, .bottom])
                if getAllVouchersCount() > 1 {
                    Picker("Pieczątki", selection: $voucherStampsAppearance) {
                        Text(VoucherStampsAppearance.all.title).tag(VoucherStampsAppearance.all)
                        Text(VoucherStampsAppearance.active.title).tag(VoucherStampsAppearance.active)
                    }
                    .pickerStyle(.segmented)
                    .padding([.horizontal, .bottom])
                }
                if UIDevice.isIPhone {
                    VStack {
                        if getActiveVouchersCount() > 0 {
                            if voucherStampsAppearance == .all && getVouchersCount() > 0 {
                                Text("\(PluralizedString.active(getActiveVouchersCount()).pluralized)".capitalized)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading)
                                    .padding(.leading)
                                    .foregroundStyle(.secondary)
                            }
                            ForEach(Array(1...getActiveVouchersCount()), id: \.self) { i in
                                VoucherView(voucherIndex: i, isActive: true, userStamps: $userStamps)
                            }
                        }
                        if voucherStampsAppearance == .all && getVouchersCount() > 0 {
                            Text("Nieaktywny")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading)
                                .padding(.leading)
                                .foregroundStyle(.secondary)
                            VoucherView(voucherIndex: getLastIndex(), isActive: false, userStamps: $userStamps)
                        }
                    }
                    .animation(.snappy(duration: 0.35, extraBounce: 0.04), value: voucherStampsAppearance)
                    .padding(.horizontal)
                } else {
                    LazyVGrid(columns: Array(repeating: GridItem(), count: 2), spacing: 8) {
                        ForEach(Array(1...getVouchersCount()), id: \.self) { i in
                            VoucherView(voucherIndex: i, isActive: false, userStamps: $userStamps)
                        }
                    }
                    .animation(.snappy(duration: 0.35, extraBounce: 0.04), value: voucherStampsAppearance)
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Twoje pieczątki")
        }
        .background(Color("Background"))
    }
    
    @ViewBuilder
    private func NoResultsView() -> some View {
        GeometryReader { proxy in
            VStack(alignment: .center, spacing: 16) {
                Spacer()
                Image("stamp")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: proxy.size.width * 0.4,
                           height: proxy.size.width * 0.4,
                           alignment: .center)
                    .overlay {
                        Image(systemName: "questionmark")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: proxy.size.width * 0.15, height: proxy.size.width * 0.15)
                            .foregroundStyle(.white)
                    }
                Text("Nie masz jeszcze żadnych pieczątek")
                    .foregroundStyle(.secondary)
                    .font(.headline)
                    .fontWeight(.regular)
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .ignoresSafeArea(.all)
        .background(Color("Background"))
    }
    
    @ViewBuilder
    private func ActiveStampsCountText() -> some View {
        Group {
            Text("Masz do wykorzystania ")
                .foregroundStyle(.secondary)
            + Text("\(getActiveVouchersCount())")
                .foregroundStyle(.primary)
                .fontWeight(.semibold)
            + Text(" \(PluralizedString.reward(getActiveVouchersCount()).pluralized)")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func getVouchersCount() -> Int {
        switch voucherStampsAppearance {
        case .all:
            return getAllVouchersCount()
        case .active:
            return getActiveVouchersCount()
        }
    }
    
    private func getAllVouchersCount() -> Int {
        let value = Int(CGFloat(userStamps.count) / CGFloat(Constants.stampsPerVoucher))
        return value + 1
    }
    
    private func getActiveVouchersCount() -> Int {
        let value = Int(CGFloat(userStamps.count) / CGFloat(Constants.stampsPerVoucher))
        return userStamps.count < Constants.stampsPerVoucher ? 0 : value
    }
    
    private func getLastIndex() -> Int {
        Int(CGFloat(userStamps.count) / CGFloat(Constants.stampsPerVoucher)) + 1
    }
}

#Preview {
    NavigationStack {
        StampView(userStamps: .constant(Array(repeating: StampDto.mock, count: 12)))
    }
}
