import SwiftUI

enum Typography {
    // MARK: - Headings (DM Sans)
    static let largeTitle = Font.custom("DMSans-ExtraBold", size: 34)
    static let title1 = Font.custom("DMSans-Bold", size: 28)
    static let title2 = Font.custom("DMSans-Bold", size: 22)
    static let title3 = Font.custom("DMSans-SemiBold", size: 20)
    static let headline = Font.custom("DMSans-Bold", size: 17)

    // MARK: - Body (Inter)
    static let body = Font.custom("Inter-Regular", size: 17)
    static let bodyMedium = Font.custom("Inter-Medium", size: 17)
    static let bodySemiBold = Font.custom("Inter-SemiBold", size: 17)
    static let callout = Font.custom("Inter-Regular", size: 16)
    static let subheadline = Font.custom("Inter-Medium", size: 15)
    static let footnote = Font.custom("Inter-Regular", size: 13)
    static let caption1 = Font.custom("Inter-Regular", size: 12)
    static let caption2 = Font.custom("Inter-Medium", size: 11)

    // MARK: - Font Registration
    static func registerFonts() {
        // Fonts are auto-registered via Info.plist UIAppFonts
        // This method exists for future manual registration if needed
    }
}
