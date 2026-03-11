import Foundation
import Supabase

@Observable
final class AuthService {
    static let shared = AuthService()

    private(set) var currentUser: AppUser?
    private(set) var isAuthenticated = false

    private init() {}

    func loadCurrentUser() async {
        guard let userId = await SupabaseManager.shared.currentUserId else {
            isAuthenticated = false
            currentUser = nil
            return
        }

        do {
            let user: AppUser = try await SupabaseManager.shared.client
                .from("users")
                .select()
                .eq("id", value: userId.uuidString)
                .single()
                .execute()
                .value

            currentUser = user
            isAuthenticated = true
        } catch {
            print("Error loading user: \(error)")
            isAuthenticated = false
        }
    }

    func signIn(email: String, password: String) async throws {
        try await SupabaseManager.shared.client.auth.signIn(
            email: email,
            password: password
        )
        await loadCurrentUser()
    }

    func signUp(email: String, password: String, fullName: String) async throws {
        try await SupabaseManager.shared.client.auth.signUp(
            email: email,
            password: password,
            data: [
                "full_name": .string(fullName),
                "onboarding_completed": .bool(false)
            ]
        )
        await loadCurrentUser()
    }

    func signOut() async throws {
        try await SupabaseManager.shared.client.auth.signOut()
        currentUser = nil
        isAuthenticated = false
    }

    func updateOnboardingCompleted() async throws {
        try await SupabaseManager.shared.client.auth.update(
            user: UserAttributes(
                data: ["onboarding_completed": .bool(true)]
            )
        )
    }
}
