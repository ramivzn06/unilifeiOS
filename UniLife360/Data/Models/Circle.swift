import Foundation

struct StudyCircle: Codable, Identifiable, Hashable {
    let id: UUID
    let createdBy: UUID
    var name: String
    var description: String?
    var avatarUrl: String?
    var category: String?
    var isPublic: Bool
    var memberCount: Int = 0
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case createdBy = "created_by"
        case name, description
        case avatarUrl = "avatar_url"
        case category
        case isPublic = "is_public"
        case memberCount = "member_count"
        case createdAt = "created_at"
    }
}
