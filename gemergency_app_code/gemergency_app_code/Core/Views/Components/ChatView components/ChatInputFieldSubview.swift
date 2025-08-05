import SwiftUI

public struct ChatInputFieldSubview: View {
    
    @Binding var userPrompt: String
    
    public var body: some View {
        TextField("Ask Gemma for help", text: $userPrompt)
            .foregroundStyle(.white)
            .padding(.vertical, UIApplication.shared.isCurrentDeviceiPad ? 16 : 12)
            .padding(.horizontal, 16)
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
            .lineLimit(1)
    }
}
