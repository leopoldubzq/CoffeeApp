import SwiftUI

final class HapticManager {
    // MARK: - Public properties
    static let shared = HapticManager()
    
    //MARK: - PUBLIC METHODS
    func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}

