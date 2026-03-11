import SwiftUI
import Supabase

@Observable
final class OnboardingViewModel {
    // Step 1: Identity
    var fullName = ""
    var university = ""
    var fieldOfStudy = ""

    // Step 2: Studies
    var yearOfStudy = 1
    var favoriteSubjects: [String] = []

    // Step 3: Finance
    var monthlyBudget: String = "800"
    var currency = "EUR"

    // Navigation
    var currentStep = 0
    var isLoading = false
    var errorMessage: String?

    let totalSteps = 4

    let universities = [
        "ULB", "UCLouvain", "VUB", "ULiège", "UNamur",
        "UMons", "KU Leuven", "UGent", "Autre"
    ]

    let fields = [
        "Informatique", "Sciences éco", "Droit", "Médecine",
        "Ingénierie", "Sciences politiques", "Psychologie",
        "Lettres", "Sciences", "Architecture", "Autre"
    ]

    let subjects = [
        "Algorithmique", "Mathématiques", "Physique", "Chimie",
        "Économie", "Droit civil", "Philosophie", "Langues",
        "Marketing", "Comptabilité", "Biologie", "Sociologie"
    ]

    private let supabase = SupabaseManager.shared.client

    var canProceed: Bool {
        switch currentStep {
        case 0: return !fullName.isEmpty && !university.isEmpty && !fieldOfStudy.isEmpty
        case 1: return yearOfStudy >= 1
        case 2: return !monthlyBudget.isEmpty
        case 3: return true
        default: return false
        }
    }

    var stepTitle: String {
        switch currentStep {
        case 0: return "Ton identité"
        case 1: return "Tes études"
        case 2: return "Ton budget"
        case 3: return "Récapitulatif"
        default: return ""
        }
    }

    var stepSubtitle: String {
        switch currentStep {
        case 0: return "Dis-nous qui tu es"
        case 1: return "Parle-nous de tes études"
        case 2: return "Configure ton budget"
        case 3: return "Tout est prêt !"
        default: return ""
        }
    }

    func nextStep() {
        HapticFeedback.tap()
        if currentStep < totalSteps - 1 {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                currentStep += 1
            }
        }
    }

    func previousStep() {
        HapticFeedback.tap()
        if currentStep > 0 {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                currentStep -= 1
            }
        }
    }

    func toggleSubject(_ subject: String) {
        HapticFeedback.tap()
        if favoriteSubjects.contains(subject) {
            favoriteSubjects.removeAll { $0 == subject }
        } else {
            favoriteSubjects.append(subject)
        }
    }

    func completeOnboarding() async {
        isLoading = true

        do {
            // Update user metadata
            try await supabase.auth.update(user: .init(data: [
                "full_name": .string(fullName),
                "onboarding_completed": .bool(true)
            ]))

            // Create or update user profile in the users table
            let userId = try await supabase.auth.session.user.id

            try await supabase.from("users").upsert([
                "id": userId.uuidString,
                "full_name": fullName,
                "university": university,
                "field_of_study": fieldOfStudy,
                "year_of_study": "\(yearOfStudy)"
            ] as [String: String]).execute()

            // Create financial profile
            if let budget = Decimal(string: monthlyBudget) {
                try await supabase.from("financial_profiles").upsert([
                    "user_id": userId.uuidString,
                    "country_code": "BE",
                    "currency_code": currency,
                    "monthly_budget": "\(budget)"
                ] as [String: String]).execute()
            }

            HapticFeedback.success()
        } catch {
            errorMessage = "Erreur: \(error.localizedDescription)"
            HapticFeedback.error()
        }

        isLoading = false
    }
}
