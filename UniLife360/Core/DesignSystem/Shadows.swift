import SwiftUI

enum BrutalistShadow {
    static let small = Shadow(color: .black.opacity(0.9), radius: 0, x: 2, y: 2)
    static let medium = Shadow(color: .black.opacity(0.9), radius: 0, x: 4, y: 4)
    static let large = Shadow(color: .black.opacity(0.9), radius: 0, x: 6, y: 6)

    struct Shadow {
        let color: Color
        let radius: CGFloat
        let x: CGFloat
        let y: CGFloat
    }
}

struct BrutalistShadowModifier: ViewModifier {
    var shadow: BrutalistShadow.Shadow = BrutalistShadow.medium
    var isPressed: Bool = false

    func body(content: Content) -> some View {
        content
            .shadow(
                color: shadow.color,
                radius: shadow.radius,
                x: isPressed ? shadow.x * 0.3 : shadow.x,
                y: isPressed ? shadow.y * 0.3 : shadow.y
            )
    }
}

extension View {
    func brutalistShadow(_ shadow: BrutalistShadow.Shadow = BrutalistShadow.medium, isPressed: Bool = false) -> some View {
        modifier(BrutalistShadowModifier(shadow: shadow, isPressed: isPressed))
    }
}
