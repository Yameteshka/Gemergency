import SwiftUI

public struct MenuControlSubview: View {
 
    var title: String
    var systemImage: String
    var action: () -> ()
    
    init(
        title: String,
        systemImage: String,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.systemImage = systemImage
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.system(size: 13))
                
                Spacer(minLength: 0)
                
                Image(systemName: systemImage)
                    .frame(width: 20)
            }
            .frame(maxHeight: .infinity)
        }
        .foregroundStyle(systemImage == "trash.fill" ? .red : Color.primary)
    }
}
