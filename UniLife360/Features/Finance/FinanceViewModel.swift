import SwiftUI
import Supabase

@Observable
final class FinanceViewModel {
    var expenses: [Expense] = []
    var incomeSources: [IncomeSource] = []
    var financialProfile: FinancialProfile?
    var isLoading = true
    var selectedFilter: TransactionCategory?
    var showNewTransaction = false

    // New transaction form
    var newAmount = ""
    var newDescription = ""
    var newCategory: TransactionCategory = .groceries
    var newType: TransactionType = .expense
    var newDate = Date()

    private let supabase = SupabaseManager.shared.client

    var monthlyBudget: Decimal {
        financialProfile?.monthlyBudget ?? 1200
    }

    var totalExpenses: Decimal {
        expenses
            .filter { $0.transactionType == .expense }
            .reduce(0) { $0 + $1.amount }
    }

    var totalIncome: Decimal {
        expenses
            .filter { $0.transactionType == .income }
            .reduce(0) { $0 + $1.amount }
    }

    var remainingBudget: Decimal {
        monthlyBudget - totalExpenses
    }

    var budgetUsedPercent: Int {
        guard monthlyBudget > 0 else { return 0 }
        return min(100, Int((totalExpenses / monthlyBudget) * 100))
    }

    var filteredExpenses: [Expense] {
        guard let filter = selectedFilter else { return expenses }
        return expenses.filter { $0.category == filter }
    }

    var expensesByCategory: [(category: TransactionCategory, total: Decimal)] {
        var dict: [TransactionCategory: Decimal] = [:]
        for expense in expenses where expense.transactionType == .expense {
            dict[expense.category, default: 0] += expense.amount
        }
        return dict.sorted { $0.value > $1.value }.map { (category: $0.key, total: $0.value) }
    }

    func loadData() async {
        isLoading = true

        do {
            let session = try await supabase.auth.session
            let userId = session.user.id.uuidString

            // Load expenses for current month
            let monthStart = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Date()))!
            let formatter = ISO8601DateFormatter()

            expenses = try await supabase.from("expenses")
                .select()
                .eq("user_id", value: userId)
                .gte("date", value: formatter.string(from: monthStart))
                .order("date", ascending: false)
                .execute()
                .value

            // Load financial profile
            financialProfile = try? await supabase.from("financial_profiles")
                .select()
                .eq("user_id", value: userId)
                .single()
                .execute()
                .value

            // Load income sources
            incomeSources = try await supabase.from("income_sources")
                .select()
                .eq("user_id", value: userId)
                .execute()
                .value

        } catch {
            // Use empty state — will show demo data prompts
        }

        isLoading = false
    }

    func addTransaction() async {
        guard let amount = Decimal(string: newAmount), amount > 0 else { return }

        do {
            let session = try await supabase.auth.session

            let newExpense: [String: String] = [
                "user_id": session.user.id.uuidString,
                "amount": "\(amount)",
                "category": newCategory.rawValue,
                "description": newDescription,
                "transaction_type": newType.rawValue,
                "date": ISO8601DateFormatter().string(from: newDate),
                "recurrence": "none",
                "is_fixed_charge": "false"
            ]

            try await supabase.from("expenses")
                .insert(newExpense)
                .execute()

            HapticFeedback.success()

            // Reset form
            newAmount = ""
            newDescription = ""
            showNewTransaction = false

            // Reload data
            await loadData()
        } catch {
            HapticFeedback.error()
        }
    }

    func deleteTransaction(id: UUID) async {
        do {
            try await supabase.from("expenses")
                .delete()
                .eq("id", value: id.uuidString)
                .execute()

            expenses.removeAll { $0.id == id }
            HapticFeedback.success()
        } catch {
            HapticFeedback.error()
        }
    }
}
