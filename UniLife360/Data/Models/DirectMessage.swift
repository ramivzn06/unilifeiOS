import Foundation

struct DirectMessage: Codable, Identifiable, Hashable {
    let id: UUID
    let conversationId: UUID
    let senderId: UUID
    var content: String
    var messageType: String
    var isRead: Bool
    let createdAt: Date

    // Joined
    var sender: AppUser?

    enum CodingKeys: String, CodingKey {
        case id
        case conversationId = "conversation_id"
        case senderId = "sender_id"
        case content
        case messageType = "message_type"
        case isRead = "is_read"
        case createdAt = "created_at"
        case sender
    }
}
