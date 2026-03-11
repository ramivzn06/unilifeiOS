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
                NavigationStack {
                    LoginView()
                }
            } else if needsOnboarding {
                NavigationStack {
                    OnboardingView(onComplete: {
                        needsOnboarding = false
                    })
                }
            } else {
                TabBarView()
            }
        }
        .task {
            await checkAuth()
        }
        .onChange(of: isAuthenticated) { _, newValue in
            if !newValue {
                needsOnboarding = false
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
            isAuthenticated = true

            // Check onboarding
            if let metadata = session.user.userMetadata["onboarding_completed"],
               case .bool(let completed) = metadata {
                needsOnboarding = !completed
            } else {
                needsOnboarding = true
            }
        } catch {
            isAuthenticated = false
        }
        isLoading = false
    }
}
