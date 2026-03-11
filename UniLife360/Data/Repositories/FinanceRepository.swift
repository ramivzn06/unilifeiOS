import Foundation

struct FinanceRepository {
    private let client = SupabaseManager.shared.client

    func getExpenses(userId: UUID, month: Date? = nil) async throws -> [Expense] {
        var query = client
            .from("expenses")
            .select()
            .eq("user_id", value: userId.uuidString)
            .order("date", ascending: false)

        if let month {
            let calendar = Calendar.current
            let start = calendar.date(from: calendar.dateComponents([.year, .month], from: month))!
            let end = calendar.date(byAdding: .month, value: 1, to: start)!

            let formatter = ISO8601DateFormatter()
            query = query
                .gte("date", value: formatter.string(from: start))
                .lt("date", value: formatter.string(from: end))
        }

        return try await query.execute().value
    }

    func addExpense(_ expense: Expense) async throws {
        try await client
            .from("expenses")
            .insert(expense)
            .execute()
    }

    func deleteExpense(id: UUID) async throws {
        try await client
            .from("expenses")
            .delete()
            .eq("id", value: id.uuidString)
            .execute()
    }

    func getFinancialProfile(userId: UUID) async throws -> FinancialProfile? {
        try await client
            .from("financial_profiles")
            .select()
            .eq("user_id", value: userId.uuidString)
            .single()
            .execute()
            .value
    }

    func updateFinancialProfile(_ profile: FinancialProfile) async throws {
        try await client
            .from("financial_profiles")
            .upsert(profile)
            .execute()
    }

    func getIncomeSources(userId: UUID) async throws -> [IncomeSource] {
        try await client
            .from("income_sources")
            .select()
            .eq("user_id", value: userId.uuidString)
            .execute()
            .value
    }
}
