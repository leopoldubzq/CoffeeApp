import SwiftUI

struct CouponCell: View {
    
    var coupon: CouponDto
    @Binding var couponToActivate: CouponDto?
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(spacing: 8) {
            if couponToActivate == coupon {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .frame(width: 170, height: 170)
                        .foregroundStyle(Color.white)
                        .overlay(alignment: .bottom) {
                            Text("123456789")
                                .foregroundStyle(Color.black)
                                .padding(.bottom, 5)
                                .font(.system(size: 16))
                        }
                        .shadow(radius: 16)
                    QRCodeImageView(from: "123456789")
                        .frame(width: 120, height: 120)
                }
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
            } else {
                Text(coupon.title)
                    .foregroundStyle(Color(uiColor: .label))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.leading)
                Text("Kupon ważny do \(DateManager.formatDate(coupon.expirationDate))")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.secondary)
                    .font(.footnote)
                Spacer()
                Button {
                    withAnimation(.snappy(duration: 0.4, extraBounce: 0.05)) {
                        couponToActivate = coupon
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
        .background(Color("SecondaryBackground"))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(alignment: .topTrailing) {
            if couponToActivate == coupon {
                HStack {
                    Spacer()
                    Button {
                        withAnimation(.snappy(duration: 0.4, extraBounce: 0.05)) {
                            couponToActivate = nil
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
        .rotation3DEffect(.degrees(couponToActivate == coupon ? 180 : 0),
                          axis: (x: 0, y: 1, z: 0))
        .onTapGesture {
            withAnimation(.snappy(duration: 0.4, extraBounce: 0.05)) {
                couponToActivate = nil
            }
        }
    }
}

#Preview {
    CouponCell(coupon: CouponDto.mock, couponToActivate: .constant(nil))
        .frame(maxWidth: .infinity)
        .frame(height: 220)
        .padding(.horizontal)
}
