import Foundation

struct Friendship: Codable, Identifiable {
    let id: UUID
    let requesterId: UUID
    let addresseeId: UUID
    var status: FriendStatus
    let createdAt: Date

    // Joined
    var requester: AppUser?
    var addressee: AppUser?

    enum CodingKeys: String, CodingKey {
        case id
        case requesterId = "requester_id"
        case addresseeId = "addressee_id"
        case status
        case createdAt = "created_at"
        case requester, addressee
    }
}
