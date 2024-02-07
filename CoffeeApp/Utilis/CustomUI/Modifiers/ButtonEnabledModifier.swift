import SwiftUI

struct ButtonEnabledModifier: ViewModifier {

    var enabled: Bool
    
    func body(content: Content) -> some View {
        content
            .disabled(!enabled)
    }
}

extension View {
    func enabled(_ enabled: Bool) -> some View {
        self.modifier(ButtonEnabledModifier(enabled: enabled))
    }
}
