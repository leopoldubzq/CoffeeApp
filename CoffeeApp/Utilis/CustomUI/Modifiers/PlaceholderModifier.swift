import SwiftUI
import Shimmer

struct PlaceholderModifier: ViewModifier {

    @Binding var showPlaceholder: Bool
    
    func body(content: Content) -> some View {
        if showPlaceholder {
            content
                .redacted(reason: .placeholder)
                .shimmering(animation: .easeInOut(duration: 0.5).repeatForever(autoreverses: false))
                .allowsHitTesting(false)
        } else {
            content
                .allowsHitTesting(true)
        }
    }
}

extension View {
    func showPlaceholder(_ showPlaceholder: Binding<Bool>) -> some View {
        self.modifier(PlaceholderModifier(showPlaceholder: showPlaceholder))
    }
}
