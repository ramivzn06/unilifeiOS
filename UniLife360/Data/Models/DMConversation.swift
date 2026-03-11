import Foundation

struct DMConversation: Codable, Identifiable, Hashable {
    let id: UUID
    var participants: [UUID]
    var lastMessage: String?
    var lastMessageAt: Date?
    var unreadCount: Int
    let createdAt: Date

    // Joined data
    var otherUser: AppUser?

    enum CodingKeys: String, CodingKey {
        case id, participants
        case lastMessage = "last_message"
        case lastMessageAt = "last_message_at"
        case unreadCount = "unread_count"
        case createdAt = "created_at"
        case otherUser = "other_user"
    }
}
