import SwiftUI

struct ChangeAppearanceButton: View {
    
    @State private var appearance: ListAppearanceType = .vertical
    
    var body: some View {
        Group {
            if appearance == .horizontal {
                HStack(spacing: 4) {
                    ForEach(1...3, id: \.self) { index in
                        Rectangle()
                            .frame(width: getDimensions(by: index).width, height: getDimensions(by: index).height)
                    }
                }
                .rotationEffect(.degrees(appearance == .horizontal ? 0 : 95))
            } else {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 12, maximum: 12), spacing: 0), count: 2), spacing: 0) {
                    ForEach(1...4, id: \.self) { index in
                        Rectangle()
                            .overlay(content: {
                                Rectangle()
                                    .stroke(Color.init(uiColor: .systemBackground), lineWidth: 1)
                            })
                            .frame(width: 12, height: 12)
                    }
                }
                .frame(width: 35, height: 35)
                .rotationEffect(.degrees(appearance == .horizontal ? 90 : 0))
            }
        }
        .onTapGesture {
            changeAppearance()
        }
    }
    
    private func getDimensions(by index: Int) -> (width: CGFloat, height: CGFloat) {
        switch index {
        case 1, 3:
            return (8, 8)
        case 2:
            return (12, 12)
        default:
            return (15, 15)
        }
    }
    
    private func changeAppearance() {
        withAnimation(.snappy(duration: 0.35)) {
            appearance = appearance == .horizontal ? .vertical : .horizontal
        }
    }
}

#Preview {
    ChangeAppearanceButton()
}
