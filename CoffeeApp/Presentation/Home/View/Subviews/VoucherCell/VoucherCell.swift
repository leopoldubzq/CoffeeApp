import SwiftUI

struct Voucher: Identifiable, Equatable {
    let id = UUID().uuidString
    var title: String
    var shop: CoffeeShop
    var code: String
    var expirationDate: Date
    var expirationDateString: String {
        "Kupon ważny do \(DateManager.formatDate(expirationDate))"
    }
    
    static func == (lhs: Voucher, rhs: Voucher) -> Bool {
        lhs.id == rhs.id
    }
    
    static var mocks: [Voucher] = [
        Voucher(title: "Rabat 5zł na Americano, Cappuccino, Latte",
                shop: CoffeeShop(title: "Costa Coffee"),
                code: QRCodeGenerator.generate(),
                expirationDate: Date()),
        Voucher(title: "Rabat 5zł na Americano, Cappuccino, Latte",
                shop: CoffeeShop(title: "Costa Coffee"),
                code: QRCodeGenerator.generate(),
                expirationDate: Date()),
        Voucher(title: "Rabat 5zł na Americano, Cappuccino, Latte",
                shop: CoffeeShop(title: "Costa Coffee"),
                code: QRCodeGenerator.generate(),
                expirationDate: Date()),
        Voucher(title: "Rabat 5zł na Americano, Cappuccino, Latte",
                shop: CoffeeShop(title: "Costa Coffee"),
                code: QRCodeGenerator.generate(),
                expirationDate: Date()),
        Voucher(title: "Rabat 5zł na Americano, Cappuccino, Latte",
                shop: CoffeeShop(title: "Costa Coffee"),
                code: QRCodeGenerator.generate(),
                expirationDate: Date()),
        Voucher(title: "Rabat 5zł na Americano, Cappuccino, Latte",
                shop: CoffeeShop(title: "Costa Coffee"),
                code: QRCodeGenerator.generate(),
                expirationDate: Date())
    ]
}

struct CoffeeShop {
    var title: String
}

struct VoucherCell: View {
    
    var voucher: Voucher
    @Binding var voucherToActivate: Voucher?
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(spacing: 8) {
            if voucherToActivate == voucher {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .frame(width: 170, height: 170)
                        .foregroundStyle(Color.white)
                        .overlay(alignment: .bottom) {
                            Text("123456789")
                                .foregroundStyle(Color.black)
                                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                                .padding(.bottom, 5)
                                .font(.system(size: 16))
                        }
                        .shadow(radius: 16)
                    QRCodeImageView(from: "123456789")
                        .frame(width: 120, height: 120)
                }
            } else {
                Text(voucher.title)
                    .foregroundStyle(Color(uiColor: .label))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.leading)
                Text(voucher.expirationDateString)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.secondary)
                    .font(.footnote)
                Spacer()
                Button {
                    withAnimation(.snappy(duration: 0.4, extraBounce: 0.05)) {
                        voucherToActivate = voucher
                    }
                } label: {
                    Text("Aktywuj")
                        .frame(maxWidth: .infinity)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(RoundedRectangle(cornerRadius: 12).foregroundStyle(.accent))
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .frame(height: 220)
        .background {
            Color.gray.opacity(colorScheme == .dark ? 0.15 : 0.08)
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(alignment: .topTrailing) {
            if voucherToActivate == voucher {
                HStack {
                    Spacer()
                    Button {
                        withAnimation(.snappy(duration: 0.4, extraBounce: 0.05)) {
                            voucherToActivate = nil
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 12, height: 12)
                            .foregroundStyle(Color.init(uiColor: .label))
                    }
                }
                .padding()
            }
        }
        .rotation3DEffect(.degrees(voucherToActivate == voucher ? 180 : 0),
                          axis: (x: 0, y: 1, z: 0))
        .onTapGesture {
            withAnimation(.snappy(duration: 0.4, extraBounce: 0.05)) {
                voucherToActivate = nil
            }
        }
    }
}

#Preview {
    VoucherCell(voucher: Voucher(title: "Rabat 5zł na Americano, Cappuccino, Latte",
                                 shop: CoffeeShop(title: "Costa Coffee"),
                                 code: QRCodeGenerator.generate(),
                                 expirationDate: Date()),
                voucherToActivate: .constant(nil))
    .frame(maxWidth: .infinity)
    .frame(height: 220)
    .padding(.horizontal)
}
