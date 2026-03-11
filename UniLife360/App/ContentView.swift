import SwiftUI
import Supabase

struct ContentView: View {
    @Environment(AppRouter.self) private var router
    @State private var isAuthenticated = false
    @State private var isLoading = true
    @State private var needsOnboarding = false

    var body: some View {
        Group {
            if isLoading {
                splashView
            } else if !isAuthenticated {
                LoginView()
            } else if needsOnboarding {
                OnboardingView(onComplete: {
                    needsOnboarding = false
                })
            } else {
                TabBarView()
            }
        }
        .task {
            // Initial check
            await checkAuth()

            // Listen for auth state changes (login, logout, token refresh)
            for await (event, session) in SupabaseManager.shared.client.auth.authStateChanges {
                switch event {
                case .signedIn:
                    await handleSignedIn(session: session)
                case .signedOut:
                    await MainActor.run {
                        isAuthenticated = false
                        needsOnboarding = false
                    }
                case .userUpdated:
                    if let session {
                        await checkOnboarding(session: session)
                    }
                default:
                    break
                }
            }
        }
    }

    private var splashView: some View {
        ZStack {
            Theme.background
                .ignoresSafeArea()
            VStack(spacing: 16) {
                Text("U")
                    .font(.system(size: 64, weight: .black, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [ModuleColors.finance, ModuleColors.studies, ModuleColors.social],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .padding(24)
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Theme.border, lineWidth: 2)
                            )
                            .shadow(color: .black, radius: 0, x: 4, y: 4)
                    }
                Text("UniLife 360")
                    .font(.title2)
                    .fontWeight(.bold)
                ProgressView()
                    .tint(ModuleColors.finance)
            }
        }
    }

    private func checkAuth() async {
        do {
            let session = try await SupabaseManager.shared.client.auth.session
            await handleSignedIn(session: session)
        } catch {
            isAuthenticated = false
        }
        isLoading = false
    }

    private func handleSignedIn(session: Session?) async {
        guard let session else { return }

        // Ensure user exists in public.users table
        await ensureUserInDB(session: session)

        await checkOnboarding(session: session)

        await MainActor.run {
            isAuthenticated = true
            if isLoading { isLoading = false }
        }
    }

    private func checkOnboarding(session: Session) async {
        if let metadata = session.user.userMetadata["onboarding_completed"],
           case .bool(let completed) = metadata {
            await MainActor.run {
                needsOnboarding = !completed
            }
        } else {
            await MainActor.run {
                needsOnboarding = true
            }
        }
    }

    /// Creates a row in public.users if it doesn't exist yet (for OAuth/Apple sign-ins)
    private func ensureUserInDB(session: Session) async {
        let userId = session.user.id
        do {
            // Check if user already exists
            let existing: [AppUser] = try await SupabaseManager.shared.client
                .from("users")
                .select()
                .eq("id", value: userId.uuidString)
                .execute()
                .value

            if existing.isEmpty {
                // Create user row from auth metadata
                let fullName = session.user.userMetadata["full_name"]?.stringValue
                    ?? session.user.userMetadata["name"]?.stringValue
                    ?? session.user.email?.components(separatedBy: "@").first
                    ?? "Utilisateur"

                let newUser: [String: String] = [
                    "id": userId.uuidString,
                    "full_name": fullName,
                    "email": session.user.email ?? "",
                    "role": "student",
                    "onboarding_completed": "false"
                ]

                try await SupabaseManager.shared.client
                    .from("users")
                    .insert(newUser)
                    .execute()
            }
        } catch {
            print("ensureUserInDB error: \(error)")
        }
    }
}
