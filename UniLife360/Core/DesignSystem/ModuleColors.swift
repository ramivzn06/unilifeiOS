import SwiftUI

enum ModuleColors {
    static let finance = Color(hex: "#86efac")
    static let studies = Color(hex: "#d8b4fe")
    static let social = Color(hex: "#f9a8d4")
    static let sport = Color(hex: "#fdba74")
    static let schedule = Color(hex: "#93c5fd")

    static let financeLight = Color(hex: "#bbf7d0")
    static let studiesLight = Color(hex: "#e9d5ff")
    static let socialLight = Color(hex: "#fbcfe8")
    static let sportLight = Color(hex: "#fed7aa")
    static let scheduleLight = Color(hex: "#bfdbfe")

    static func color(for module: String) -> Color {
        switch module.lowercased() {
        case "finance": finance
        case "studies", "études", "academic": studies
        case "social": social
        case "sport": sport
        case "schedule", "planning": schedule
        default: Color.gray
        }
    }
}
