import SwiftUI

public struct MenuStyleSubview<Content: View>: View {
    
    var cornerRadius: CGFloat = 30
    @ViewBuilder var content: Content
    @State private var viewSize: CGSize = .zero
    
    var colorSchemeVariant: Bool = false
    
    public var body: some View {
        content
            .clipShape(.rect(cornerRadius: cornerRadius, style: .continuous))
            .contentShape(.rect(cornerRadius: cornerRadius, style: .continuous))
            .background {
                BackgroundView()
            }
            .compositingGroup()
            .shadow(color: .black.opacity(0.15), radius: 8, x: 8, y: 8)
            .shadow(color: .black.opacity(0.1), radius: 5, x: -5, y: -5)
            .onGeometryChange(for: CGSize.self) {
                $0.size
            } action: { newValue in
                viewSize = newValue
            }

    }
    
    @ViewBuilder private func BackgroundView() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .stroke(.gray.opacity(0.25), style: .init(lineWidth: 3, lineCap: .round, lineJoin: .round))
            
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(.ultraThinMaterial.shadow(.inner(color: .black.opacity(0.2), radius: 10)))
        }
        .compositingGroup()
        .environment(\.colorScheme, !colorSchemeVariant ? .dark : .light)
    }
}
