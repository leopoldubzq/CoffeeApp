import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct QRCodeView: View {
    
    @Binding var qrCodeViewIsPresented: Bool
    var qrCodeString: String
    var qrCodeNamespace: Namespace.ID
    var qrCodeBackgroundNamespace: Namespace.ID
    var qrCodeStringNamespace: Namespace.ID
    
    @State private var zStackOffsetY: CGFloat = 0
    @GestureState private var translationY: CGFloat = 0.0
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack {
            Text("Twoja karta zniżkowa")
                .font(.title)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .center)
            ZStack {
                if qrCodeViewIsPresented {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.white)
                        .matchedGeometryEffect(id: "QRCodeBackground",
                                               in: qrCodeBackgroundNamespace)
                        .frame(width: UIDevice.isIPad ? 460 : 230,
                               height: UIDevice.isIPad ? 460  : 230)
                        .shadow(radius: 24)
                        .overlay(alignment: .bottom) {
                            HStack(spacing: 4) {
                                Image(systemName: "doc.on.doc")
                                    .foregroundStyle(.black)
                                    .scaleEffect(0.9)
                                Text(qrCodeString)
                                    .foregroundStyle(.black)
                                    .minimumScaleFactor(0.8)
                                    .lineLimit(1)
                            }
                            .padding(.bottom, 10)
                            .matchedGeometryEffect(id: "QRCodeString", in: qrCodeStringNamespace)
                            .onTapGesture { UIPasteboard.general.string = qrCodeString }
                        }
                    QRCodeImageView(from: qrCodeString)
                        .matchedGeometryEffect(id: "QRCode", in: qrCodeNamespace)
                        .frame(width: UIDevice.isIPad ? 300 : 150, height: UIDevice.isIPad ? 300 : 150)
                }
            }
        }
        .offset(y: zStackOffsetY)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Color.init(uiColor: .systemBackground)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .opacity((1.0 - (zStackOffsetY / 1000)))
                .shadow(radius: 12)
        )
        .gesture(
            DragGesture().updating($translationY, body: { value, out, _ in
                out = value.translation.height
            }).onEnded({ value in
                withAnimation(.snappy(duration: 0.4, extraBounce: 0.04)) {
                    if value.translation.height > 150 {
                        qrCodeViewIsPresented.toggle()
                    }
                    zStackOffsetY = 0
                }
            })
        )
        .onChange(of: translationY) { _, newValue in
            guard newValue >= 0 else { return }
            zStackOffsetY = translationY
        }
        .ignoresSafeArea(.all, edges: .all)
        .onTapGesture {
            withAnimation(.snappy(duration: 0.4, extraBounce: 0.04)) {
                qrCodeViewIsPresented.toggle()
            }
        }
    }
    
    
}

#Preview {
    @Namespace var qrCodeNamespace
    @Namespace var qrCodeBackgroundNamespace
    @Namespace var qrCodeStringNamespace
    return QRCodeView(qrCodeViewIsPresented: .constant(true),
                      qrCodeString: QRCodeGenerator.generate(),
                      qrCodeNamespace: qrCodeNamespace,
                      qrCodeBackgroundNamespace: qrCodeBackgroundNamespace,
                      qrCodeStringNamespace: qrCodeStringNamespace)
}
