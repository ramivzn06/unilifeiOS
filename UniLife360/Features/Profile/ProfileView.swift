import SwiftUI

struct ProfileView: View {
    @State private var user: AppUser?
    @State private var isLoading = true
    private let repository = UserRepository()

    var body: some View {
        ScrollView {
            if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, minHeight: 300)
            } else if let user {
                VStack(spacing: 20) {
                    // Avatar with gradient ring
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        colors: [ModuleColors.finance, ModuleColors.studies, ModuleColors.social, ModuleColors.sport],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 4
                                )
                                .frame(width: 100, height: 100)

                            Text(String(user.fullName?.prefix(1) ?? "?").uppercased())
                                .font(.system(size: 40, weight: .bold))
                                .frame(width: 88, height: 88)
                                .background(Color.white)
                                .clipShape(Circle())
                        }
                        .shadow(color: .black.opacity(0.85), radius: 0, x: 4, y: 4)

                        VStack(spacing: 4) {
                            Text(user.fullName ?? "Utilisateur")
                                .font(.title2)
                                .fontWeight(.bold)

                            if let university = user.university {
                                Text(university)
                                    .font(.subheadline)
                                    .foregroundColor(Theme.textSecondary)
                            }

                            if let field = user.fieldOfStudy, let year = user.studyYear {
                                Text("\(field) • \(year)")
                                    .font(.caption)
                                    .foregroundColor(Theme.textSecondary)
                            }
                        }

                        if let bio = user.bio {
                            Text(bio)
                                .font(.body)
                                .foregroundColor(Theme.textSecondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 24)
                        }
                    }

                    // Stats row
                    HStack(spacing: 12) {
                        statPill(value: "\(user.xpPoints)", label: "XP", color: ModuleColors.finance)
                        statPill(value: "\(user.streakDays)j", label: "Streak", color: ModuleColors.sport)
                    }
                    .padding(.horizontal)

                    // Actions
                    VStack(spacing: 8) {
                        NavigationLink(value: AppDestination.editProfile) {
                            actionRow(icon: "pencil", title: "Modifier le profil", color: ModuleColors.studies)
                        }
                        .buttonStyle(.plain)

                        NavigationLink(value: AppDestination.settings) {
                            actionRow(icon: "gearshape.fill", title: "Paramètres", color: ModuleColors.schedule)
                        }
                        .buttonStyle(.plain)

                        Button(action: signOut) {
                            actionRow(icon: "rectangle.portrait.and.arrow.right", title: "Se déconnecter", color: Color(hex: "#fca5a5"))
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
        }
        .background(Theme.background.ignoresSafeArea())
        .navigationTitle("Profil")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            guard let userId = await SupabaseManager.shared.currentUserId else { return }
            user = try? await repository.getUser(id: userId)
            isLoading = false
        }
    }

    private func statPill(value: String, label: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
            Text(label)
                .font(.caption)
                .foregroundColor(Theme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .brutalistCard(backgroundColor: color.opacity(0.15))
    }

    private func actionRow(icon: String, title: String, color: Color) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.body)
                .foregroundColor(.black)
                .frame(width: 36, height: 36)
                .background(color.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: 10))

            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(Theme.text)

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(Theme.textSecondary)
        }
        .brutalistCard()
    }

    private func signOut() {
        Task {
            try? await SupabaseManager.shared.signOut()
            HapticFeedback.medium()
        }
    }
}
