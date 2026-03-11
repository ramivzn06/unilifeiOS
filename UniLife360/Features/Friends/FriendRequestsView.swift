import SwiftUI

struct FriendRequestsView: View {
    @State private var requests: [FriendRequest] = []
    @State private var isLoading = false
    private let repository = FriendsRepository()

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                if requests.isEmpty && !isLoading {
                    EmptyStateView(
                        icon: "person.badge.plus",
                        title: "Aucune demande",
                        message: "Vous n'avez pas de demandes d'amis en attente"
                    )
                } else {
                    ForEach(requests) { request in
                        requestCard(request)
                    }
                }
            }
            .padding()
        }
        .background(Theme.background.ignoresSafeArea())
        .navigationTitle("Demandes d'amis")
        .navigationBarTitleDisplayMode(.inline)
        .task { await loadRequests() }
    }

    private func requestCard(_ request: FriendRequest) -> some View {
        HStack(spacing: 12) {
            Text(String(request.fromUser?.fullName?.prefix(1) ?? "?").uppercased())
                .font(.headline)
                .frame(width: 44, height: 44)
                .background(ModuleColors.social.opacity(0.2))
                .clipShape(SwiftUI.Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text(request.fromUser?.fullName ?? "Utilisateur")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                if let university = request.fromUser?.university {
                    Text(university)
                        .font(.caption)
                        .foregroundColor(Theme.textSecondary)
                }
            }

            Spacer()

            HStack(spacing: 8) {
                Button(action: { accept(request) }) {
                    Image(systemName: "checkmark")
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .frame(width: 36, height: 36)
                        .background(ModuleColors.finance)
                        .clipShape(SwiftUI.Circle())
                        .overlay(SwiftUI.Circle().stroke(Theme.border, lineWidth: 1))
                }

                Button(action: { decline(request) }) {
                    Image(systemName: "xmark")
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .frame(width: 36, height: 36)
                        .background(Color(hex: "#fca5a5"))
                        .clipShape(SwiftUI.Circle())
                        .overlay(SwiftUI.Circle().stroke(Theme.border, lineWidth: 1))
                }
            }
        }
        .brutalistCard()
    }

    private func accept(_ request: FriendRequest) {
        Task {
            try? await repository.acceptFriendRequest(
                id: request.id,
                fromUserId: request.fromUserId,
                toUserId: request.toUserId
            )
            requests.removeAll { $0.id == request.id }
            HapticFeedback.success()
        }
    }

    private func decline(_ request: FriendRequest) {
        Task {
            try? await repository.declineFriendRequest(id: request.id)
            requests.removeAll { $0.id == request.id }
            HapticFeedback.medium()
        }
    }

    private func loadRequests() async {
        guard let userId = await SupabaseManager.shared.currentUserId else { return }
        isLoading = true
        requests = (try? await repository.getPendingRequests(userId: userId)) ?? []
        isLoading = false
    }
}
