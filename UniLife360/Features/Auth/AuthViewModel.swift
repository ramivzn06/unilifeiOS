import SwiftUI
import Supabase
import AuthenticationServices

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
    private let appleSignInManager = AppleSignInManager()

    // MARK: - Sign In (Email/Password)

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

    // MARK: - Sign Up (Email/Password)

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

    func startAppleSignIn() {
        isLoading = true
        appleSignInManager.signIn { [weak self] result in
            guard let self else { return }
            Task { @MainActor in
                switch result {
                case .success(let credential):
                    await self.completeAppleSignIn(
                        idToken: credential.idToken,
                        nonce: credential.nonce,
                        fullName: credential.fullName
                    )
                case .failure(let error):
                    self.isLoading = false
                    if (error as? ASAuthorizationError)?.code != .canceled {
                        self.showErrorMessage("Erreur Apple Sign-In: \(error.localizedDescription)")
                        HapticFeedback.error()
                    }
                }
            }
        }
    }

    private func completeAppleSignIn(idToken: String, nonce: String, fullName: String?) async {
        do {
            try await supabase.auth.signInWithIdToken(
                credentials: .init(provider: .apple, idToken: idToken, nonce: nonce)
            )

            // Update full name if Apple provided it (first sign-in only)
            if let fullName, !fullName.isEmpty {
                try? await supabase.auth.update(
                    user: UserAttributes(
                        data: ["full_name": .string(fullName)]
                    )
                )
            }

            HapticFeedback.success()
        } catch {
            showErrorMessage("Erreur Apple Sign-In")
            HapticFeedback.error()
        }

        isLoading = false
    }

    // MARK: - Sign In with Google

    func startGoogleSignIn() async {
        isLoading = true

        do {
            try await supabase.auth.signInWithOAuth(
                provider: .google,
                redirectTo: URL(string: "com.unilife360.app://login-callback")
            )
        } catch {
            showErrorMessage("Erreur Google Sign-In: \(error.localizedDescription)")
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
