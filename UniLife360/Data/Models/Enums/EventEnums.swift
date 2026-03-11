import SwiftUI

enum EventType: String, Codable, CaseIterable {
    case etudes, sport, social, loisirs, autre

    var label: String {
        switch self {
        case .etudes: "Études"
        case .sport: "Sport"
        case .social: "Social"
        case .loisirs: "Loisirs"
        case .autre: "Autre"
        }
    }

    var color: Color {
        switch self {
        case .etudes: Color(hex: "#d8b4fe")
        case .sport: Color(hex: "#fdba74")
        case .social: Color(hex: "#f9a8d4")
        case .loisirs: Color(hex: "#86efac")
        case .autre: Color(hex: "#f5f5f4")
        }
    }
}

enum EventStatus: String, Codable {
    case draft, published, cancelled, completed
}

enum TicketStatus: String, Codable {
    case reserved, paid, cancelled, used
}
