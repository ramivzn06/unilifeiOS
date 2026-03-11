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
        }
    }
}
