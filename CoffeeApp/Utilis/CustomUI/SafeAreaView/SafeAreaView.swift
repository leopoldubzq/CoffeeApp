import SwiftUI

struct SafeAreaView: View {
    
    var color: Color = Color.init(uiColor: .systemBackground)
    
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(width: getKeyWindow()?.frame.size.width ?? 0.0)
            .frame(height: getKeyWindow()?.safeAreaInsets.top ?? 0.0)
            .ignoresSafeArea(edges: .top)
    }
}

#Preview {
    SafeAreaView(color: .red)
}
