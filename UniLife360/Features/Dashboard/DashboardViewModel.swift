import SwiftUI
import Supabase

@Observable
final class DashboardViewModel {
    var userName = "Étudiant"
    var isLoading = true
    var aiSuggestion: String?
    var aiLoading = true

    // Stats
    var totalBudget: Decimal = 1200
    var totalExpenses: Decimal = 946.28
    var todayCourses: [(time: String, name: String, room: String, isActive: Bool)] = [
        ("08:30", "Algorithmique", "Amphi B2", false),
        ("10:00", "Mathématiques", "Salle 204", true),
        ("14:00", "Base de données", "Labo Info", false),
    ]

    var budgetUsedPercent: Int {
        guard totalBudget > 0 else { return 0 }
        return min(100, Int((totalExpenses / totalBudget) * 100))
    }

    var remainingBudget: Decimal {
        totalBudget - totalExpenses
    }

    private let supabase = SupabaseManager.shared.client

    var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        if hour < 6 { return "Bonne nuit" }
        if hour < 12 { return "Bonjour" }
        if hour < 18 { return "Bon après-midi" }
        return "Bonsoir"
    }

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.dateFormat = "EEEE d MMMM yyyy"
        return formatter.string(from: Date()).capitalized
    }

    func loadData() async {
        do {
            // Load user name
            let session = try await supabase.auth.session
            if let fullName = session.user.userMetadata["full_name"]?.stringValue {
                userName = fullName.components(separatedBy: " ").first ?? fullName
            }

            // Load financial data
            let expenses: [Expense] = try await supabase.from("expenses")
                .select()
                .eq("user_id", value: session.user.id.uuidString)
                .execute()
                .value

            let monthStart = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Date()))!
            let monthExpenses = expenses.filter { $0.date >= monthStart && $0.transactionType == .expense }
            totalExpenses = monthExpenses.reduce(0) { $0 + $1.amount }

            if let profile: FinancialProfile = try? await supabase.from("financial_profiles")
                .select()
                .eq("user_id", value: session.user.id.uuidString)
                .single()
                .execute()
                .value {
                totalBudget = profile.monthlyBudget
            }
        } catch {
            // Use demo data on error
        }

        isLoading = false

        // Load AI suggestion
        aiSuggestion = "📚 Organise tes notes de cours et prépare tes fiches de révision. L'IA peut t'aider à résumer tes cours !"
        aiLoading = false
    }
}
