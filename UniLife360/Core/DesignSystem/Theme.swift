import SwiftUI

enum Theme {
    // MARK: - Colors
    static let background = Color(hex: "#fefce8")
    static let backgroundDark = Color(hex: "#1a1a1d")
    static let surface = Color.white
    static let surfaceDark = Color(hex: "#27272a")
    static let border = Color(hex: "#0a0a0a")
    static let borderDark = Color(hex: "#3f3f46")
    static let text = Color(hex: "#0a0a0a")
    static let textDark = Color(hex: "#fafafa")
    static let textSecondary = Color(hex: "#71717a")

    // MARK: - Dimensions
    static let cornerRadius: CGFloat = 12
    static let borderWidth: CGFloat = 2
    static let shadowOffset: CGFloat = 4
    static let cardPadding: CGFloat = 16
    static let spacing: CGFloat = 12

    // MARK: - Shadows
    static func hardShadow(pressed: Bool = false) -> some View {
        EmptyView() // Use .brutalistCard() modifier instead
    }
}

// MARK: - Color Hex Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
