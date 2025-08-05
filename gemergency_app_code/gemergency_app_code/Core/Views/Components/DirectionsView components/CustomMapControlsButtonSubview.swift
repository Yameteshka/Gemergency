import SwiftUI
 
public struct CustomMapControlsButtonSubview: View {
      
    @Binding var isSettingsMenuExpanded: Bool
    @Binding var isDirectionsMenuExpanded: Bool
    
    public var body: some View {
        Button {
            HapticsController.shared.handleInteractionFeedback(of: .soft)
            
            withAnimation(.smooth) {
                isSettingsMenuExpanded.toggle()
            }
            
            if isSettingsMenuExpanded {
                withAnimation(.smooth) {
                    isDirectionsMenuExpanded = false
                }
            }
        } label: {
            Image(systemName: "gear")
                .font(.title2)
                .foregroundStyle(isSettingsMenuExpanded ? .black : Color.primary)
                .frame(width: 56, height: 56)
                .background {
                    if isSettingsMenuExpanded {
                        Capsule(style: .continuous)
                            .fill(.white)
                    }
                }
        }
        .buttonStyle(SquishyButtonStyle(squishDimensions: 1.3))
    }
}
