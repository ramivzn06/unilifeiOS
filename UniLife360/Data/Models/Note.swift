import Foundation

struct Note: Codable, Identifiable, Hashable {
    let id: UUID
    let userId: UUID
    var courseId: UUID?
    var title: String
    var content: String? // JSON string from TipTap - rendered as plain text
    var plainTextContent: String?
    var visibility: NoteVisibility
    var tags: [String]?
    let createdAt: Date
    var updatedAt: Date?

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case courseId = "course_id"
        case title, content
        case plainTextContent = "plain_text_content"
        case visibility, tags
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
