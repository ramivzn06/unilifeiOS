import Foundation

struct CalendarEvent: Codable, Identifiable, Hashable {
    let id: UUID
    let userId: UUID
    var title: String
    var description: String?
    var startTime: Date
    var endTime: Date
    var location: String?
    var type: EventType
    var color: String?
    var isAllDay: Bool
    var recurrenceRule: String?
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case title, description
        case startTime = "start_time"
        case endTime = "end_time"
        case location, type, color
        case isAllDay = "is_all_day"
        case recurrenceRule = "recurrence_rule"
        case createdAt = "created_at"
    }
}
