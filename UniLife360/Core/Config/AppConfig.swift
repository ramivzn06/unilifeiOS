import Foundation

enum AppConfig {
    static let supabaseURL = URL(string: "https://pzjbjsqfhelgjkpebddl.supabase.co")!
    static let supabaseAnonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InB6amJqc3FmaGVsZ2prcGViZGRsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzMxNjg0NjYsImV4cCI6MjA4ODc0NDQ2Nn0.5D-sH0CHc4WCX7zSnEBHZzj3k3fbuc2XVgp6xcK8zFM"

    // API base URL for AI features (Next.js deployed app)
    static let apiBaseURL = URL(string: "https://unilife360.vercel.app")!

    static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    static let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
}
