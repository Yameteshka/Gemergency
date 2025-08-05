import SwiftUI

public struct SquishyButtonStyle: ButtonStyle {
    
    var squishDimensions: CGFloat
    
    public func makeBody(configuration: Configuration) -> some View {
        let isPressed = configuration.isPressed
        
        configuration.label
            .background {
                if isPressed {
                    ZStack {
                        Capsule(style: .continuous)
                            .stroke(.gray.opacity(0.25), lineWidth: 1.5)
                       
                        Capsule(style: .continuous)
                            .fill(.ultraThinMaterial)
                    }
                    .compositingGroup()
                } else {
                    ZStack {
                        Capsule(style: .continuous)
                            .stroke(.gray.opacity(0.25), lineWidth: 1.5)
                        
                        Capsule(style: .continuous)
                            .fill(.background.opacity(0.8))
                        
                        Capsule(style: .continuous)
                            .fill(.ultraThinMaterial)
                    }
                    .compositingGroup()
                }
            }
            .scaleEffect(isPressed ? squishDimensions : 1.0)
            .animation(.spring(response: 0.4, dampingFraction: 0.5), value: isPressed)
    }
}
