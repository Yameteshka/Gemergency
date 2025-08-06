import SwiftUI

public struct CustomOnBoardingCard: Identifiable {
    
    public var id: String = UUID().uuidString
    var symbol, title, description: String
}

@resultBuilder struct CustomOnBoardingCardResultBuilder {
    static func buildBlock(_ components: CustomOnBoardingCard...) -> [CustomOnBoardingCard] {
        return components.compactMap { $0 }
    }
}

public struct CustomOnBoardingSubview<Icon: View>: View {
    
    var tint: Color
    var title: String
    var icon: Icon
    var cards: [CustomOnBoardingCard]
    var onContinue: () -> Void
    
    @State private var animateIcon: Bool = false
    @State private var animateTitle: Bool = false
    @State private var animateCards: [Bool]
    @State private var animateFooter: Bool = false
    
    init(
        tint: Color,
        title: String,
        @ViewBuilder icon: @escaping () -> Icon,
        @CustomOnBoardingCardResultBuilder cards: @escaping () ->  [CustomOnBoardingCard],
        onContinue: @escaping () -> Void
    ) {
        self.tint = tint
        self.title = title
        self.icon = icon()
        self.cards = cards()
        self.onContinue = onContinue
        self._animateCards = .init(initialValue: Array(repeating: false, count: self.cards.count))
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 20) {
                    icon
                        .frame(maxWidth: .infinity)
                        .blurSlide(animateIcon)
                    
                    Text(title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .blurSlide(animateTitle)
                    
                    CardsListSubview()
                }
            }
            .scrollIndicators(.hidden)
            .scrollBounceBehavior(.basedOnSize)
            
            VStack(spacing: 0) {
                Button(action: onContinue) {
                    Text("Continue")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 4)
                }
                .tint(tint)
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle(radius: 12.5))
            }
            .padding()
            .blurSlide(animateFooter)
        }
        .padding(.horizontal, 25)
        .interactiveDismissDisabled()
        .allowsHitTesting(animateFooter)
        .task {
            guard !animateIcon else {
                return
            }
            
            await implementDelayedAnimation(withDelay: 0.35) {
                animateIcon = true
            }
            
            await implementDelayedAnimation(withDelay: 0.2) {
                animateTitle = true
            }
            
            try? await Task.sleep(for: .seconds(0.2))
            
            for index in animateCards.indices {
                let delay = Double(index) * 0.1
                
                await implementDelayedAnimation(withDelay: delay) {
                    animateCards[index] = true
                }
            }
            
            await implementDelayedAnimation(withDelay: 0.2) {
                animateFooter = true
            }
        }
    }
    
    @ViewBuilder private func CardsListSubview() -> some View {
        Group {
            ForEach(cards.indices, id: \.self) { index in
                let card = cards[index]
                
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: card.symbol)
                        .font(.title2)
                        .foregroundStyle(tint)
                        .symbolVariant(.fill)
                        .frame(width: 45)
                        .offset(y: 10)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text(card.title)
                            .font(.title3)
                            .lineLimit(1)
                        
                        Text(card.description)
                            .lineLimit(3)
                    }
                }
                .blurSlide(animateCards[index])
            }
        }
    }
    
    private func implementDelayedAnimation(withDelay delay: Double, action: @escaping () -> Void) async {
        try? await Task.sleep(for: .seconds(delay))
        
        withAnimation(.smooth) {
            action()
        }
    }
}
