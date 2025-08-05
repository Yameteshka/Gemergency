import SwiftUI

public struct ChatBubbleSubview: View {
    var message: Message
    
    public var body: some View {
        HStack {
            if message.sender == .user {
                Spacer(minLength: 0)
            }
            
            Text(LocalizedStringKey(message.content))
                .font(.body)
                .padding(12)
                .textSelection(.enabled)
                .background {
                    if message.sender == .user {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15.5)
                                .stroke(.gray.opacity(0.25), lineWidth: 3)
                            
                            RoundedRectangle(cornerRadius: 15.5)
                                .fill(.background.opacity(0.8))
                            
                            RoundedRectangle(cornerRadius: 15.5)
                                .fill(.ultraThinMaterial)
                        }
                        .compositingGroup()
                    } else {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15.5)
                                .stroke(.gray.opacity(0.25), lineWidth: 3)
                            
                            RoundedRectangle(cornerRadius: 15.5)
                                .fill(.white.opacity(0.3))
                            
                            RoundedRectangle(cornerRadius: 15.5)
                                .fill(.ultraThinMaterial)
                        }
                        .compositingGroup()
                    }
                }
                .foregroundColor(.white)
                .clipShape(.rect(cornerRadius: 15.5))
            
            if message.sender == .gemma {
                Spacer(minLength: 0)
            }
        }
        .padding(.horizontal, 25)
        .padding(.vertical, 2)
    }
}
