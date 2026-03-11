import Foundation

enum AppConfig {
    static let supabaseURL = URL(string: "https://wpankbozgzatrprryzra.supabase.co")!
    static let supabaseAnonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndwYW5rYm96Z3phdHJwcnJ5enJhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzA2ODU3MzIsImV4cCI6MjA4NjI2MTczMn0.K2rvElovl3u_1ByLw0cVMf2D3pgk9E8Gv9X4jeC2Q-g"

    // API base URL for AI features (Next.js deployed app)
    static let apiBaseURL = URL(string: "https://unilife360.vercel.app")!

    static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    static let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
}
