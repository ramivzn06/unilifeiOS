import Foundation

struct Company: Codable, Identifiable, Hashable {
    let id: UUID
    let userId: UUID
    var name: String
    var description: String?
    var logoUrl: String?
    var website: String?
    var industry: String?
    var location: String?
    var isVerified: Bool
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case name, description
        case logoUrl = "logo_url"
        case website, industry, location
        case isVerified = "is_verified"
        case createdAt = "created_at"
    }
}
