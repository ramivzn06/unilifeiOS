import Foundation

struct Expense: Codable, Identifiable, Hashable {
    let id: UUID
    let userId: UUID
    var amount: Double
    var description: String?
    var category: TransactionCategory
    var type: TransactionType
    var date: Date
    var merchant: String?
    var isRecurring: Bool
    var recurrenceType: RecurrenceType?
    var receiptUrl: String?
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case amount, description, category, type, date, merchant
        case isRecurring = "is_recurring"
        case recurrenceType = "recurrence_type"
        case receiptUrl = "receipt_url"
        case createdAt = "created_at"
    }
}
