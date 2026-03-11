import Foundation

// Local helper — no direct DB table, conversations are derived from direct_messages
// grouped by (sender_id, receiver_id) pairs
struct DMConversation: Identifiable, Hashable {
    let id: UUID // derived, e.g. from the other user's ID
    let otherUserId: UUID
    var otherUser: AppUser?
    var lastMessage: String?
    var lastMessageAt: Date?
    var unreadCount: Int

    init(otherUserId: UUID, otherUser: AppUser? = nil, lastMessage: String? = nil, lastMessageAt: Date? = nil, unreadCount: Int = 0) {
        self.id = otherUserId
        self.otherUserId = otherUserId
        self.otherUser = otherUser
        self.lastMessage = lastMessage
        self.lastMessageAt = lastMessageAt
        self.unreadCount = unreadCount
    }
}
