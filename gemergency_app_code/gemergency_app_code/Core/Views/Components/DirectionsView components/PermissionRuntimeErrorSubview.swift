import SwiftUI

public struct PermissionRuntimeErrorSubview: View {
    
    @Environment(\.openURL) private var openURL
    
    public var body: some View {
        ZStack {
            Rectangle()
                .fill(.black.opacity(0.167))
                .ignoresSafeArea()
            
            MenuStyleSubview(cornerRadius: 42.5) {
                VStack(alignment: .center, spacing: 8) {
                    Text("Oops")
                        .font(.title2)
                        .bold()
                        .foregroundStyle(.white)
                        .padding(.bottom, 8)
                    
                    Text("An unexpected error occured\nwhile getting your location. We highly\nrecommend you to reinstall an app!")
                        .font(.caption)
                        .bold()
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 30)
                    
                    Button {
                        if let settingsUrl = URL(string: "AppStore link") {
                            openURL(settingsUrl)
                        }
                    } label: {
                        Text("Open Settings")
                            .font(.system(size: 13, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .frame(height: 40)
                    }
                    .buttonStyle(SquishyButtonStyle(squishDimensions: 1.15))
                    .padding(.horizontal, 40)
                }
                .frame(maxWidth: 330)
                .frame(height: 250)
            }
        }
    }
}

#Preview {
    PermissionRuntimeErrorSubview()
}
