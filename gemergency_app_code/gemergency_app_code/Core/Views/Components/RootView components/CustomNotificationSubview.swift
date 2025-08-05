import SwiftUI

public struct CustomNotificationSubview: View {
    
    var size: CGSize
    @State private var isExpandable: Bool = false
    @State private var customNotification: CustomNotification?
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(customNotification?.title ?? "Error message")
                .font(.headline.bold())
                .foregroundStyle(Color.primary)
            
            Text(customNotification?.description ?? "Something went wrong during the sending notification. Don't pay attention to that!")
                .font(.subheadline)
                .foregroundStyle(Color.secondary)
        }
        .padding(.horizontal, 25)
        .frame(width: isExpandable ? size.width - 22 : 126, height: isExpandable ? 170 : 37.33, alignment: .leading)
        .blur(radius: isExpandable ? 0 : 30)
        .opacity(isExpandable ? 1 : 0)
        .scaleEffect(isExpandable ? 1 : 0.5, anchor: .top)
        .background {
            RoundedRectangle(cornerRadius: isExpandable ? 50 : 63, style: .continuous)
                .fill(.black)
        }
        .clipped()
        .offset(y: 11)
        .onReceive(NotificationCenter.default.publisher(for: .init("NOTIFY"))) { output in
            guard let notification = output.object as? CustomNotification else {
                return
            }
            
            self.customNotification = notification
            
            withAnimation(.interactiveSpring(response: 0.7, dampingFraction: 0.7, blendDuration: 0.7)) {
                isExpandable = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.2) {
                    withAnimation(.interactiveSpring(response: 0.7, dampingFraction: 0.7, blendDuration: 0.7)) {
                        isExpandable = false
                        self.customNotification = nil
                    }
                }
            }
        }
    }
}
