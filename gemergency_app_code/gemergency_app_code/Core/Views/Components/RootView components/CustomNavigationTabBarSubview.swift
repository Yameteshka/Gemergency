import SwiftUI

public struct CustomNavigationTabBarSubview: View {
    
    @Binding var currentNavigationTab: NavigationTabs
    @GestureState private var isActive: Bool = false
    @State private var isInitialOffset: Bool = false
    @State private var dragOffset: CGFloat = 0
    @State private var lastDragOffset: CGFloat?
    
    public var body: some View {
        GeometryReader {
            let size = $0.size
            let tabs = NavigationTabs.allCases.prefix(5)
            let tabItemWidth = max(min(size.width / CGFloat(tabs.count), 90), 60)
            let tabItemHeight: CGFloat = 56
            
            ZStack {
                if isInitialOffset {
                    HStack(spacing: 0) {
                        ForEach(tabs, id: \.rawValue) { tab in
                            TabItemView(tab, width: tabItemWidth, height: tabItemHeight)
                        }
                    }
                    .background(alignment: .leading) {
                        ZStack {
                            Capsule(style: .continuous)
                                .stroke(.gray.opacity(0.25), lineWidth: 3)
                                .opacity(isActive ? 1 : 0)
                            
                            Capsule(style: .continuous)
                                .fill(.ultraThinMaterial)
                        }
                        .compositingGroup()
                        .frame(width: tabItemWidth, height: tabItemHeight)
                        .scaleEffect(isActive ? 1.3 : 1)
                        .offset(x: dragOffset)
                    }
                    .padding(3)
                    .background(TabBarBackground())
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .onAppear {
                guard !isInitialOffset else {
                    return
                }
                
                dragOffset = CGFloat(currentNavigationTab.idx) * tabItemWidth
                isInitialOffset = true
            }
        }
        .frame(height: 56)
        .padding(.horizontal, 25)
        .padding(.bottom, 20)
        .animation(.bouncy, value: dragOffset)
        .animation(.bouncy, value: isActive)
        .animation(.smooth, value: currentNavigationTab)
    }
    
    @ViewBuilder private func TabItemView(_ tab: NavigationTabs, width: CGFloat, height: CGFloat) -> some View {
        let tabs = NavigationTabs.allCases.prefix(5)
        let tabCount = tabs.count - 1
        
        VStack(spacing: 6) {
            Image(systemName: tab.navigationTabSymbol)
                .font(.title2)
                .symbolVariant(.fill)
            
            Text(tab.rawValue)
                .font(.caption2)
                .lineLimit(2)
        }
        .foregroundStyle(currentNavigationTab == tab ? accentColor : Color.primary)
        .frame(width: width, height: height)
        .contentShape(.capsule)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .updating($isActive, body: { _, out, _ in
                    out = true
                })
                .onChanged({ value in
                    let xOffSet = value.translation.width
                    if let lastDragOffset {
                        let newDragOffset = xOffSet + lastDragOffset
                        dragOffset = max(min(newDragOffset, CGFloat(tabCount) * width), 0)
                    } else {
                        lastDragOffset = dragOffset
                    }
                })
                .onEnded({ value in
                    lastDragOffset = nil
                    let landingIndex = Int((dragOffset / width).rounded())
                    if tabs.indices.contains(landingIndex) {
                        dragOffset = CGFloat(landingIndex) * width
                        currentNavigationTab = tabs[landingIndex]
                    }
                })
        )
        .simultaneousGesture(
            TapGesture()
                .onEnded({ _ in
                    currentNavigationTab = tab
                    dragOffset = CGFloat(tab.idx) * width
                })
        )
    }
    
    @ViewBuilder private func TabBarBackground() -> some View {
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
    
    private var accentColor: Color {
        return .blue
    }
}
