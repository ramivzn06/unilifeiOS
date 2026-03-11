import SwiftUI

struct FriendProfileView: View {
    let userId: UUID
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
                    // Avatar
                    VStack(spacing: 12) {
                        Text(String(user.fullName?.prefix(1) ?? "?").uppercased())
                            .font(.system(size: 36, weight: .bold))
                            .frame(width: 80, height: 80)
                            .background(
                                LinearGradient(
                                    colors: [ModuleColors.social, ModuleColors.studies],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .clipShape(SwiftUI.Circle())
                            .overlay(SwiftUI.Circle().stroke(Theme.border, lineWidth: 2))
                            .shadow(color: .black.opacity(0.85), radius: 0, x: 3, y: 3)

                        Text(user.fullName ?? "Utilisateur")
                            .font(.title2)
                            .fontWeight(.bold)

                        if let university = user.university {
                            Text(university)
                                .font(.subheadline)
                                .foregroundColor(Theme.textSecondary)
                        }

                        if let bio = user.bio {
                            Text(bio)
                                .font(.body)
                                .foregroundColor(Theme.textSecondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 32)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .brutalistCard(backgroundColor: ModuleColors.social.opacity(0.08))

                    // Stats
                    HStack(spacing: 12) {
                        profileStat(value: "\(user.xpPoints)", label: "XP")
                        profileStat(value: "\(user.streakDays)", label: "Streak")
                    }
                    .padding(.horizontal)

                    // Info
                    VStack(alignment: .leading, spacing: 12) {
                        if let field = user.fieldOfStudy {
                            Label(field, systemImage: "graduationcap")
                                .font(.subheadline)
                        }
                        if let year = user.studyYear {
                            Label(year, systemImage: "calendar")
                                .font(.subheadline)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .brutalistCard()
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
        }
        .background(Theme.background.ignoresSafeArea())
        .navigationTitle("Profil")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            user = try? await repository.getUser(id: userId)
            isLoading = false
        }
    }

    private func profileStat(value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
            Text(label)
                .font(.caption)
                .foregroundColor(Theme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .brutalistCard(backgroundColor: ModuleColors.socialLight)
    }
}
