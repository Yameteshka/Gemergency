import SwiftUI

public struct PathCreationRuntimeErrorSubview: View {
    
    @Binding var wrongPathCreationError: Bool
    
    public var body: some View {
        MenuStyleSubview(cornerRadius: 42.5) {
            VStack(alignment: .center, spacing: 8) {
                Text("Sorry")
                    .font(.title2)
                    .bold()
                    .foregroundStyle(.white)
                    .padding(.bottom, 8)
                
                Text("But we could not get a direction!\nPlease, make sure you chose\ncorrect parameters!")
                    .font(.caption)
                    .bold()
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 30)
                
                Button {
                    withAnimation(.smooth) {
                        wrongPathCreationError = false
                    }
                } label: {
                    Text("Try again")
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
