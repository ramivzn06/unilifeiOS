import SwiftUI

// MARK: - Brutalist Card Modifier
struct BrutalistCardModifier: ViewModifier {
    var backgroundColor: Color = .white
    var borderColor: Color = Theme.border
    var cornerRadius: CGFloat = Theme.cornerRadius
    var isPressed: Bool = false

    func body(content: Content) -> some View {
        content
            .padding(Theme.cardPadding)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(borderColor, lineWidth: Theme.borderWidth)
            )
            .shadow(
                color: .black.opacity(0.85),
                radius: 0,
                x: isPressed ? 1 : 4,
                y: isPressed ? 1 : 4
            )
    }
}

// MARK: - Brutalist Button Style
struct BrutalistButtonStyle: ButtonStyle {
    var color: Color = ModuleColors.finance
    var textColor: Color = .black
    var fullWidth: Bool = true

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .fontWeight(.bold)
            .foregroundColor(textColor)
            .frame(maxWidth: fullWidth ? .infinity : nil)
            .padding(.horizontal, 24)
            .padding(.vertical, 14)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: Theme.cornerRadius)
                    .stroke(Theme.border, lineWidth: Theme.borderWidth)
            )
            .shadow(
                color: .black.opacity(0.85),
                radius: 0,
                x: configuration.isPressed ? 1 : 4,
                y: configuration.isPressed ? 1 : 4
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .offset(
                x: configuration.isPressed ? 2 : 0,
                y: configuration.isPressed ? 2 : 0
            )
            .animation(.spring(response: 0.2, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

// MARK: - View Extensions
extension View {
    func brutalistCard(
        backgroundColor: Color = .white,
        borderColor: Color = Theme.border,
        isPressed: Bool = false
    ) -> some View {
        modifier(BrutalistCardModifier(
            backgroundColor: backgroundColor,
            borderColor: borderColor,
            isPressed: isPressed
        ))
    }

    func brutalistBorder(
        cornerRadius: CGFloat = Theme.cornerRadius,
        color: Color = Theme.border
    ) -> some View {
        self
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(color, lineWidth: Theme.borderWidth)
            )
    }
}
