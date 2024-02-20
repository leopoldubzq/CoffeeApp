import SwiftUI

struct ClaimRewardView: View {
    
    @Binding var claimRewardViewVisible: Bool
    @Binding var stamps: [StampDto]
    var voucherNamespace: Namespace.ID
    var code: String
    
    @GestureState private var translationY: CGFloat = 0.0
    @State private var dragGestureOffsetY: CGFloat = 0.0
    @State private var qrCodeOffsetY: CGFloat = 50
    
    init(claimRewardViewVisible: Binding<Bool>, stamps: Binding<[StampDto]>,
         voucherNamespace: Namespace.ID, code: String) {
        self._claimRewardViewVisible = claimRewardViewVisible
        self._stamps = stamps
        self.voucherNamespace = voucherNamespace
        self.code = code
    }
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            VStack(alignment: .center, spacing: 18) {
                Rectangle()
                    .fill(.secondary.opacity(0.5))
                    .clipShape(Capsule())
                    .frame(width: 38, height: 6)
                HStack {
                    Spacer()
                    Button {
                        withAnimation(.snappy(duration: 0.3, extraBounce: 0.08)) {
                            claimRewardViewVisible = false
                        }
                    } label: {
                        Text("Anuluj")
                    }
                }
                Text("Twoja nagroda")
                    .font(.title)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                VoucherView(voucherIndex: 1, isActive: true, userStamps: $stamps)
                    .matchedGeometryEffect(id: "VoucherView", in: voucherNamespace)
                ZStack(alignment: .center) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.white)
                        .frame(width: size.width * 0.8, height: size.width * 0.8)
                    VStack {
                        QRCodeImageView(from: "123456789")
                            .frame(width: size.width * 0.6, height: size.width * 0.6)
                        Button {
                            HapticManager.shared.impact(.medium)
                            UIPasteboard.general.string = code
                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: "doc.on.doc")
                                    .scaleEffect(0.9)
                                Text(code)
                            }
                        }
                        .foregroundStyle(.black)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 16)
                .offset(y: qrCodeOffsetY)
                Text("Voucher na darmową kawę")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.horizontal)
                    .font(.headline)
                    .offset(y: qrCodeOffsetY)
                Spacer()
            }
            .offset(y: dragGestureOffsetY)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .padding()
            .background(Color("Background"))
            .gesture(
                DragGesture().updating($translationY, body: { value, out, _ in
                    out = value.translation.height
                }).onEnded({ value in
                    withAnimation(.snappy(duration: 0.3, extraBounce: 0.04)) {
                        if value.translation.height > 150 {
                            claimRewardViewVisible = false
                        }
                        dragGestureOffsetY = 0
                    }
                })
            )
            .onChange(of: translationY) { _, newValue in
                guard newValue >= 0 else { return }
                dragGestureOffsetY = translationY
            }
            .onAppear {
                withAnimation(.snappy(duration: 0.3, extraBounce: 0.08)) {
                    qrCodeOffsetY = 0
                }
            }
            .ignoresSafeArea(edges: .bottom)
            .toolbar(.hidden, for: .tabBar)
        }
        
    }
}

#Preview {
    @Namespace var voucherNamespace
    return ClaimRewardView(claimRewardViewVisible: .constant(true),
                           stamps: .constant(Array(repeating: StampDto(uid: UUID().uuidString), count: 10)),
                           voucherNamespace: voucherNamespace, code: "123456789")
}
