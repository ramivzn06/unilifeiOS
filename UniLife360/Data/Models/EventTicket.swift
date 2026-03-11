import Foundation

struct EventTicket: Codable, Identifiable {
    let id: UUID
    let eventId: UUID
    let userId: UUID
    var status: TicketStatus
    var qrCode: String?
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case eventId = "event_id"
        case userId = "user_id"
        case status
        case qrCode = "qr_code"
        case createdAt = "created_at"
    }
}
