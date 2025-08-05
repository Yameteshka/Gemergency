import SwiftUI
import LiquidGlass

public struct ChatHeaderSubview: View {
    
    @Binding var isMenuExpanded: Bool
    
    public var body: some View {
        HStack {
            Image("gemma_color_logo")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 30, height: 30)
            
            Text("Google Gemma 3n")
                .font(.system(size: 16, weight: .black))
            
            Image(systemName: "checkmark.seal.fill")
                .font(.caption2)
                .foregroundStyle(.green)
            
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
        .frame(height: 46)
        .background {
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
        .padding(.horizontal, 25)
    }
}
