import Foundation

struct FinancialProfile: Codable, Identifiable {
    let id: UUID
    let userId: UUID
    var monthlyBudget: Double
    var savingsGoal: Double?
    var currency: String
    let createdAt: Date
    var updatedAt: Date?

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case monthlyBudget = "monthly_budget"
        case savingsGoal = "savings_goal"
        case currency
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
