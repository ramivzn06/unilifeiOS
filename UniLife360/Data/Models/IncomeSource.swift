import Foundation

struct IncomeSource: Codable, Identifiable {
    let id: UUID
    let userId: UUID
    var name: String
    var amount: Double
    var category: TransactionCategory
    var isRecurring: Bool
    var recurrenceType: RecurrenceType?
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case name, amount, category
        case isRecurring = "is_recurring"
        case recurrenceType = "recurrence_type"
        case createdAt = "created_at"
    }
}
