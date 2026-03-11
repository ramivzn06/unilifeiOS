import SwiftUI

enum JobType: String, Codable, CaseIterable {
    case stage, cdd, cdi, freelance, alternance

    var label: String {
        switch self {
        case .stage: "Stage"
        case .cdd: "CDD"
        case .cdi: "CDI"
        case .freelance: "Freelance"
        case .alternance: "Alternance"
        }
    }
}

enum ApplicationStatus: String, Codable {
    case pending, reviewed, interview, accepted, rejected

    var label: String {
        switch self {
        case .pending: "En attente"
        case .reviewed: "Examinée"
        case .interview: "Entretien"
        case .accepted: "Acceptée"
        case .rejected: "Refusée"
        }
    }

    var color: Color {
        switch self {
        case .pending: Color(hex: "#fdba74")
        case .reviewed: Color(hex: "#d8b4fe")
        case .interview: Color(hex: "#86efac")
        case .accepted: Color(hex: "#16a34a")
        case .rejected: Color(hex: "#fca5a5")
        }
    }
}
