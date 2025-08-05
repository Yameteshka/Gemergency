import SwiftUI

final class HapticsController {
    
    static let shared = HapticsController()
    
    public func handleInteractionFeedback(of style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
}
