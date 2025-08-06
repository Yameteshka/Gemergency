import SwiftUI

public struct NoPermissionGrantedSubview: View {
    
    @Environment(\.openURL) private var openURL
    
    public var body: some View {
        ZStack {
            Rectangle()
                .fill(.black.opacity(0.167))
                .ignoresSafeArea()
            
            MenuStyleSubview(cornerRadius: 42.5) {
                VStack(alignment: .center, spacing: 8) {
                    Text("Warning")
                        .font(.title2)
                        .bold()
                        .foregroundStyle(.white)
                        .padding(.bottom, 8)
                    
                    Text("Allow us to use your\ncurrent location. Once permission\ngranted, the map will become\navailable for you")
                        .font(.caption)
                        .bold()
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 30)
                    
                    Button {
                        if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
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
    NoPermissionGrantedSubview()
}
