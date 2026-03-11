import Foundation

struct SocialEvent: Codable, Identifiable, Hashable {
    let id: UUID
    let organizerId: UUID
    var title: String
    var description: String?
    var location: String?
    var startDate: Date
    var endDate: Date?
    var imageUrl: String?
    var category: String?
    var maxParticipants: Int?
    var currentParticipants: Int
    var price: Double?
    var status: EventStatus
    var circleId: UUID?
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case organizerId = "organizer_id"
        case title, description, location
        case startDate = "start_date"
        case endDate = "end_date"
        case imageUrl = "image_url"
        case category
        case maxParticipants = "max_participants"
        case currentParticipants = "current_participants"
        case price, status
        case circleId = "circle_id"
        case createdAt = "created_at"
    }
}
