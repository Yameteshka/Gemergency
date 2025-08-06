import SwiftUI

public struct MapHeaderSubview: View {
    
    let title: String
    @Binding var isSheetOpen: Bool
    @Binding var isDirectionsMenuExpanded: Bool
    @Binding var isSettingsMenuExpanded: Bool
    
    public var body: some View {
        Button {
            HapticsController.shared.handleInteractionFeedback(of: .soft)
            
            isSheetOpen.toggle()
            
            withAnimation(.smooth) {
                isDirectionsMenuExpanded = false
                isSettingsMenuExpanded = false
            }
        } label: {
            HStack(spacing: 16) {
                Image(systemName: "mappin.and.ellipse")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .foregroundStyle(.gray.opacity(0.7))
                    .frame(width: 20, height: 20)
                
                Text(title)
                    .foregroundStyle(Color.primary)
                    .font(.system(size: 16, weight: .black))
                
                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 18)
            .padding(.vertical)
        }
        .buttonStyle(SquishyButtonStyle(squishDimensions: 1.1))
        .padding(.horizontal, 25)
    }
}
