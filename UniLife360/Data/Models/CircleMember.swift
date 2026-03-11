import Foundation

struct CircleMember: Codable, Identifiable {
    let id: UUID
    let circleId: UUID
    let userId: UUID
    var role: CircleRole
    let joinedAt: Date
    var user: AppUser?

    enum CodingKeys: String, CodingKey {
        case id
        case circleId = "circle_id"
        case userId = "user_id"
        case role
        case joinedAt = "joined_at"
        case user
    }
}
