import SwiftUI

struct FriendsView: View {
    @State private var friends: [Friendship] = []
    @State private var conversations: [DMConversation] = []
    @State private var pendingRequests: [Friendship] = []
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

                // Tab selector
                HStack(spacing: 0) {
                    tabButton("Amis", index: 0)
                    tabButton("Messages", index: 1)
                }
                .background(Color.white)
                .brutalistBorder()
                .shadow(color: .black.opacity(0.3), radius: 0, x: 2, y: 2)
                .padding(.horizontal)

                if selectedTab == 0 {
                    friendsList
                } else {
                    messagesList
                }
            }
            .padding(.bottom, 32)
        }
        .background(Theme.background.ignoresSafeArea())
        .task { await loadData() }
    }

    private func tabButton(_ title: String, index: Int) -> some View {
        Button(action: {
            withAnimation(.spring(response: 0.3)) { selectedTab = index }
            HapticFeedback.selection()
        }) {
            Text(title)
                .font(.subheadline)
                .fontWeight(selectedTab == index ? .bold : .medium)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(selectedTab == index ? ModuleColors.social.opacity(0.3) : Color.clear)
        }
        .buttonStyle(.plain)
    }

    private var friendsList: some View {
        LazyVStack(spacing: 8) {
            if friends.isEmpty {
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
        let friend = friendship.requester ?? friendship.addressee
        return HStack(spacing: 12) {
            // Avatar
            Text(String(friend?.fullName?.prefix(1) ?? "?").uppercased())
                .font(.headline)
                .frame(width: 44, height: 44)
                .background(ModuleColors.social.opacity(0.2))
                .clipShape(Circle())
                .overlay(Circle().stroke(Theme.border, lineWidth: 1))

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

            Button(action: {}) {
                Image(systemName: "message.fill")
                    .foregroundColor(ModuleColors.social)
            }
        }
        .brutalistCard()
    }

    private var messagesList: some View {
        LazyVStack(spacing: 8) {
            if conversations.isEmpty {
                EmptyStateView(
                    icon: "message",
                    title: "Aucune conversation",
                    message: "Envoyez un message à un ami pour commencer"
                )
            } else {
                ForEach(conversations) { conversation in
                    NavigationLink(value: AppDestination.chat(conversation)) {
                        conversationRow(conversation)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.horizontal)
    }

    private func conversationRow(_ conversation: DMConversation) -> some View {
        HStack(spacing: 12) {
            Text("?")
                .font(.headline)
                .frame(width: 44, height: 44)
                .background(ModuleColors.social.opacity(0.2))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text(conversation.otherUser?.fullName ?? "Conversation")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.text)
                if let lastMessage = conversation.lastMessage {
                    Text(lastMessage)
                        .font(.caption)
                        .foregroundColor(Theme.textSecondary)
                        .lineLimit(1)
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                if let lastAt = conversation.lastMessageAt {
                    Text(lastAt, style: .relative)
                        .font(.caption2)
                        .foregroundColor(Theme.textSecondary)
                }
                if conversation.unreadCount > 0 {
                    Text("\(conversation.unreadCount)")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(width: 20, height: 20)
                        .background(ModuleColors.social)
                        .clipShape(Circle())
                }
            }
        }
        .brutalistCard()
    }

    private func loadData() async {
        guard let userId = await SupabaseManager.shared.currentUserId else { return }
        isLoading = true
        friends = (try? await repository.getFriends(userId: userId)) ?? []
        conversations = (try? await repository.getConversations(userId: userId)) ?? []
        pendingRequests = (try? await repository.getPendingRequests(userId: userId)) ?? []
        isLoading = false
    }
}
