import SwiftUI

struct FriendsView: View {
    @State private var friends: [Friendship] = []
    @State private var pendingRequests: [FriendRequest] = []
    @State private var isLoading = false
    @State private var selectedTab = 0
    private let repository = FriendsRepository()

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ModuleHeader(
                    title: "Amis",
                    subtitle: "\(friends.count) amis",
                    icon: "person.2.fill",
                    color: ModuleColors.social
                )

                // Pending requests banner
                if !pendingRequests.isEmpty {
                    NavigationLink(value: AppDestination.friendRequests) {
                        HStack {
                            Image(systemName: "person.badge.plus")
                                .foregroundColor(.black)
                            Text("\(pendingRequests.count) demande(s) en attente")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(Theme.text)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(Theme.textSecondary)
                        }
                        .brutalistCard(backgroundColor: ModuleColors.socialLight)
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal)
                }

                // Friends list
                friendsList
            }
            .padding(.bottom, 32)
        }
        .background(Theme.background.ignoresSafeArea())
        .task { await loadData() }
    }

    private var friendsList: some View {
        LazyVStack(spacing: 8) {
            if friends.isEmpty && !isLoading {
                EmptyStateView(
                    icon: "person.2",
                    title: "Aucun ami",
                    message: "Recherchez des utilisateurs pour ajouter des amis"
                )
            } else {
                ForEach(friends) { friendship in
                    friendRow(friendship)
                }
            }
        }
        .padding(.horizontal)
    }

    private func friendRow(_ friendship: Friendship) -> some View {
        let friend = friendship.friend
        return HStack(spacing: 12) {
            // Avatar
            Text(String(friend?.fullName?.prefix(1) ?? "?").uppercased())
                .font(.headline)
                .frame(width: 44, height: 44)
                .background(ModuleColors.social.opacity(0.2))
                .clipShape(SwiftUI.Circle())
                .overlay(SwiftUI.Circle().stroke(Theme.border, lineWidth: 1))

            VStack(alignment: .leading, spacing: 2) {
                Text(friend?.fullName ?? "Utilisateur")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                if let university = friend?.university {
                    Text(university)
                        .font(.caption)
                        .foregroundColor(Theme.textSecondary)
                }
            }

            Spacer()

            if let friend = friend {
                NavigationLink(value: AppDestination.chat(friend)) {
                    Image(systemName: "message.fill")
                        .foregroundColor(ModuleColors.social)
                }
            }
        }
        .brutalistCard()
    }

    private func loadData() async {
        guard let userId = await SupabaseManager.shared.currentUserId else { return }
        isLoading = true
        friends = (try? await repository.getFriends(userId: userId)) ?? []
        pendingRequests = (try? await repository.getPendingRequests(userId: userId)) ?? []
        isLoading = false
    }
}
