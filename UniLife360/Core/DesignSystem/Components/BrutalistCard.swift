import SwiftUI

struct BrutalistCard<Content: View>: View {
    var backgroundColor: Color = .white
    var borderColor: Color = Theme.border
    var padding: CGFloat = Theme.cardPadding
    @ViewBuilder var content: () -> Content

    @State private var isPressed = false

    var body: some View {
        content()
            .padding(padding)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: Theme.cornerRadius)
                    .stroke(borderColor, lineWidth: Theme.borderWidth)
            )
            .shadow(
                color: .black.opacity(0.85),
                radius: 0,
                x: 4,
                y: 4
            )
    }
}
