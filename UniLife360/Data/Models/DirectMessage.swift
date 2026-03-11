import Foundation

// Matches DB table: direct_messages (sender_id, receiver_id, content, message_type, metadata, read_at)
struct DirectMessage: Codable, Identifiable, Hashable {
    let id: UUID
    let senderId: UUID
    let receiverId: UUID
    var content: String
    var messageType: String
    var metadata: [String: String]?
    var readAt: Date?
    let createdAt: Date

    // Joined
    var sender: AppUser?

    var isRead: Bool { readAt != nil }

    enum CodingKeys: String, CodingKey {
        case id
        case senderId = "sender_id"
        case receiverId = "receiver_id"
        case content
        case messageType = "message_type"
        case metadata
        case readAt = "read_at"
        case createdAt = "created_at"
        case sender
    }
}
