import SwiftUI
import Supabase

@Observable
final class AuthViewModel {
    var email = ""
    var password = ""
    var fullName = ""
    var confirmPassword = ""
    var isLoading = false
    var errorMessage: String?
    var showError = false

    private let supabase = SupabaseManager.shared.client

    // MARK: - Sign In

    func signIn() async {
        guard !email.isEmpty, !password.isEmpty else {
            showErrorMessage("Veuillez remplir tous les champs")
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            try await supabase.auth.signIn(email: email, password: password)
            HapticFeedback.success()
        } catch {
            showErrorMessage("Email ou mot de passe incorrect")
            HapticFeedback.error()
        }

        isLoading = false
    }

    // MARK: - Sign Up

    func signUp() async {
        guard !fullName.isEmpty, !email.isEmpty, !password.isEmpty else {
            showErrorMessage("Veuillez remplir tous les champs")
            return
        }

        guard password == confirmPassword else {
            showErrorMessage("Les mots de passe ne correspondent pas")
            return
        }

        guard password.count >= 6 else {
            showErrorMessage("Le mot de passe doit contenir au moins 6 caractères")
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            try await supabase.auth.signUp(
                email: email,
                password: password,
                data: [
                    "full_name": .string(fullName),
                    "onboarding_completed": .bool(false)
                ]
            )
            HapticFeedback.success()
        } catch {
            showErrorMessage("Erreur lors de l'inscription: \(error.localizedDescription)")
            HapticFeedback.error()
        }

        isLoading = false
    }

    // MARK: - Sign In with Apple

    func signInWithApple(idToken: String, nonce: String) async {
        isLoading = true

        do {
            try await supabase.auth.signInWithIdToken(
                credentials: .init(provider: .apple, idToken: idToken, nonce: nonce)
            )
            HapticFeedback.success()
        } catch {
            showErrorMessage("Erreur Apple Sign-In")
            HapticFeedback.error()
        }

        isLoading = false
    }

    // MARK: - Sign Out

    func signOut() async {
        do {
            try await supabase.auth.signOut()
        } catch {
            showErrorMessage("Erreur lors de la déconnexion")
        }
    }

    // MARK: - Helpers

    private func showErrorMessage(_ message: String) {
        errorMessage = message
        showError = true
    }
}
