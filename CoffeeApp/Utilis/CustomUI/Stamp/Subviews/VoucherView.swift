import SwiftUI

struct VoucherView: View {
    
    var voucherIndex: Int
    var isActive: Bool = false
    var userStamps: [StampDto]
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 5)) {
            ForEach(getRange(i: voucherIndex), id: \.self) { j in
                StampleCell(isEmpty: j > userStamps.count)
            }
        }
        .padding()
        .background(Color("GroupedListCellBackgroundColor"))
        .clipShape(RoundedRectangle(cornerRadius: 12))
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
    VoucherView(voucherIndex: 1, userStamps: Array(repeating: StampDto.mock, count: 4))
}
