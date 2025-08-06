import SwiftUI
 
public struct CustomGetWayButtonSubview: View {
    
    @Binding var isDirectionsMenuExpanded: Bool
    @Binding var isSettingsMenuExpanded: Bool
     
    public var body: some View {
        Button {
            HapticsController.shared.handleInteractionFeedback(of: .soft)
            
            withAnimation(.smooth) {
                isDirectionsMenuExpanded.toggle()
            }
            
            if isDirectionsMenuExpanded {
                withAnimation(.smooth) {
                    isSettingsMenuExpanded = false
                }
            }
        } label: {
            Image(systemName: "point.topleft.down.to.point.bottomright.curvepath.fill")
                .font(.title2)
                .foregroundStyle(isDirectionsMenuExpanded ? .black : Color.primary)
                .frame(width: 56, height: 56)
                .background {
                    if isDirectionsMenuExpanded {
                        Capsule(style: .continuous)
                            .fill(.white)
                    }
                }
        }
        .buttonStyle(SquishyButtonStyle(squishDimensions: 1.3))
    }
}
