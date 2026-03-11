import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("hapticEnabled") private var hapticEnabled = true
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Appearance
                VStack(alignment: .leading, spacing: 12) {
                    Text("Apparence")
                        .font(.headline)

                    Toggle(isOn: $isDarkMode) {
                        Label("Mode sombre", systemImage: "moon.fill")
                            .font(.subheadline)
                    }
                    .tint(ModuleColors.studies)
                }
                .brutalistCard()

                // Haptics
                VStack(alignment: .leading, spacing: 12) {
                    Text("Retour haptique")
                        .font(.headline)

                    Toggle(isOn: $hapticEnabled) {
                        Label("Vibrations", systemImage: "iphone.radiowaves.left.and.right")
                            .font(.subheadline)
                    }
                    .tint(ModuleColors.sport)
                }
                .brutalistCard()

                // Notifications
                VStack(alignment: .leading, spacing: 12) {
                    Text("Notifications")
                        .font(.headline)

                    Toggle(isOn: $notificationsEnabled) {
                        Label("Activer les notifications", systemImage: "bell.fill")
                            .font(.subheadline)
                    }
                    .tint(ModuleColors.social)
                }
                .brutalistCard()

                // About
                VStack(alignment: .leading, spacing: 12) {
                    Text("À propos")
                        .font(.headline)

                    HStack {
                        Text("Version")
                            .font(.subheadline)
                        Spacer()
                        Text("\(AppConfig.appVersion) (\(AppConfig.buildNumber))")
                            .font(.subheadline)
                            .foregroundColor(Theme.textSecondary)
                    }

                    Divider()

                    HStack {
                        Text("Plateforme")
                            .font(.subheadline)
                        Spacer()
                        Text("iOS")
                            .font(.subheadline)
                            .foregroundColor(Theme.textSecondary)
                    }
                }
                .brutalistCard()

                // Sign out
                Button(action: signOut) {
                    HStack {
                        Spacer()
                        Label("Se déconnecter", systemImage: "rectangle.portrait.and.arrow.right")
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                        Spacer()
                    }
                    .padding(.vertical, 14)
                    .background(Color(hex: "#fca5a5").opacity(0.2))
                    .brutalistBorder(color: .red.opacity(0.5))
                }
                .buttonStyle(.plain)
            }
            .padding()
        }
        .background(Theme.background.ignoresSafeArea())
        .navigationTitle("Paramètres")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func signOut() {
        Task {
            try? await SupabaseManager.shared.signOut()
            HapticFeedback.medium()
        }
    }
}
