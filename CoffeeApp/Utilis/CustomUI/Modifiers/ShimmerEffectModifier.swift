import SwiftUI
import Shimmer

struct ShimmerEffectModifier: ViewModifier {

    @Binding var showShimmerEffect: Bool
    var duration: TimeInterval
    var gradient: Gradient
    var delay: TimeInterval
    
    func body(content: Content) -> some View {
        if showShimmerEffect {
            content
                .shimmering(animation: .easeInOut(duration: duration).delay(delay).repeatForever(autoreverses: false), gradient: gradient)
                .allowsHitTesting(false)
        } else {
            content
                .allowsHitTesting(true)
        }
    }
}

extension View {
    func showShimmerEffect(_ showShimmerEffect: Binding<Bool>,
                           duration: TimeInterval = 0.8,
                           delay: TimeInterval = 0.0,
                           gradient: Gradient = Gradient(colors: [.secondary, .white, .secondary])) -> some View {
        self.modifier(ShimmerEffectModifier(showShimmerEffect: showShimmerEffect, 
                                            duration: duration, gradient: gradient,
                                            delay: delay))
    }
}
