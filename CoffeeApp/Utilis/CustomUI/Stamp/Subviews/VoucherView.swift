import SwiftUI

struct VoucherView: View {
    
    var voucherIndex: Int = 1
    var isActive: Bool = false
    @Binding var userStamps: [StampDto]
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 5)) {
            ForEach(getRange(i: voucherIndex), id: \.self) { j in
                StampleCell(isEmpty: j > userStamps.count)
            }
        }
        .padding()
        .background(Color("SecondaryBackground"))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .animation(.snappy(duration: 0.35), value: userStamps)
        .onTapGesture {
            guard isActive else { return }
        }
    }
    
    private func getRange(i: Int) -> ClosedRange<Int> {
        switch i {
        case 1:
            return (1...Constants.stampsPerVoucher)
        default:
            let initialValue: Int = ((i - 1) * Constants.stampsPerVoucher) + 1
            let destinationValue: Int = i * Constants.stampsPerVoucher
            return (initialValue...destinationValue)
        }
    }
}

#Preview {
    VoucherView(userStamps: .constant(Array(repeating: StampDto.mock, count: 4)))
}
