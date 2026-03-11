import Foundation

struct Course: Codable, Identifiable, Hashable {
    let id: UUID
    let userId: UUID
    var name: String
    var code: String?
    var professor: String?
    var color: String?
    var credits: Int?
    var semester: String?
    var location: String?
    var schedule: [String: String]?
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case name, code, professor, color, credits, semester, location, schedule
        case createdAt = "created_at"
    }
}
