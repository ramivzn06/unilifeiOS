import Foundation

struct AIConversation: Codable, Identifiable {
    let id: UUID
    let userId: UUID
    var context: AIConversationContext
    var title: String?
    var messages: [AIMessage]
    let createdAt: Date
    var updatedAt: Date?

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case context, title, messages
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct AIMessage: Codable, Identifiable, Hashable {
    let id: UUID
    var role: String // "user" or "assistant"
    var content: String
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id, role, content
        case createdAt = "created_at"
    }

    init(id: UUID = UUID(), role: String, content: String, createdAt: Date = Date()) {
        self.id = id
        self.role = role
        self.content = content
        self.createdAt = createdAt
    }
}
