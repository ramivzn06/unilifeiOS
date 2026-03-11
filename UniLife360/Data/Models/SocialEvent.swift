import Foundation

// Matches DB table: events (via social_events view)
// Columns: circle_id, created_by, title, description, cover_url, location,
//          location_lat, location_lng, start_time, end_time, status,
//          max_attendees, ticket_price, currency_code, tags
struct SocialEvent: Codable, Identifiable, Hashable {
    let id: UUID
    let circleId: UUID?
    let createdBy: UUID
    var title: String
    var description: String?
    var coverUrl: String?
    var location: String?
    var locationLat: Double?
    var locationLng: Double?
    var startTime: Date
    var endTime: Date?
    var status: EventStatus
    var maxAttendees: Int?
    var ticketPrice: Double?
    var currencyCode: String?
    var tags: [String]?
    let createdAt: Date
    var updatedAt: Date?

    // Joined
    var organizer: AppUser?

    enum CodingKeys: String, CodingKey {
        case id
        case circleId = "circle_id"
        case createdBy = "created_by"
        case title, description
        case coverUrl = "cover_url"
        case location
        case locationLat = "location_lat"
        case locationLng = "location_lng"
        case startTime = "start_time"
        case endTime = "end_time"
        case status
        case maxAttendees = "max_attendees"
        case ticketPrice = "ticket_price"
        case currencyCode = "currency_code"
        case tags
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case organizer
    }
}
