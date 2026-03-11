import SwiftUI
import Supabase

@main
struct UniLife360App: App {
    @State private var router = AppRouter()

    init() {
        // Configure custom fonts
        Typography.registerFonts()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(router)
                .onOpenURL { url in
                    // Handle OAuth callback (Google Sign-In redirect)
                    Task {
                        try? await SupabaseManager.shared.client.auth.session(from: url)
                    }
                }
        }
    }
}
