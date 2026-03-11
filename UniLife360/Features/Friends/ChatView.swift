import SwiftUI

struct ChatView: View {
    let conversation: DMConversation
    @State private var messages: [DirectMessage] = []
    @State private var inputText = ""
    @State private var isLoading = false
    private let repository = FriendsRepository()

    var body: some View {
        VStack(spacing: 0) {
            // Messages
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(messages.reversed()) { message in
                            messageBubble(message)
                                .id(message.id)
                        }
                    }
                    .padding()
                }
                .onChange(of: messages.count) { _, _ in
                    if let last = messages.last {
                        withAnimation { proxy.scrollTo(last.id, anchor: .bottom) }
                    }
                }
            }

            Divider()

            // Input bar
            HStack(spacing: 12) {
                TextField("Message...", text: $inputText)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color.white)
                    .brutalistBorder()

                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .font(.title3)
                        .foregroundColor(.black)
                        .frame(width: 44, height: 44)
                        .background(ModuleColors.social)
                        .brutalistBorder()
                        .shadow(color: .black.opacity(0.85), radius: 0, x: 2, y: 2)
                }
                .disabled(inputText.isEmpty)
            }
            .padding()
            .background(Theme.background)
        }
        .background(Theme.background.ignoresSafeArea())
        .navigationTitle(conversation.otherUser?.fullName ?? "Chat")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await loadMessages()
            await subscribeToNewMessages()
        }
    }

    private func messageBubble(_ message: DirectMessage) -> some View {
        let isMe = message.senderId != (conversation.otherUser?.id ?? UUID())

        return HStack {
            if isMe { Spacer() }

            Text(message.content)
                .font(.subheadline)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(isMe ? ModuleColors.socialLight : Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Theme.border.opacity(0.5), lineWidth: 1)
                )

            if !isMe { Spacer() }
        }
    }

    private func sendMessage() {
        let content = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !content.isEmpty else { return }

        inputText = ""
        HapticFeedback.light()

        Task {
            guard let userId = await SupabaseManager.shared.currentUserId else { return }
            try? await repository.sendMessage(
                conversationId: conversation.id,
                senderId: userId,
                content: content
            )
        }
    }

    private func loadMessages() async {
        messages = (try? await repository.getMessages(conversationId: conversation.id)) ?? []
    }

    private func subscribeToNewMessages() async {
        await RealtimeService.shared.subscribeToMessages(conversationId: conversation.id) { message in
            if !messages.contains(where: { $0.id == message.id }) {
                messages.append(message)
                HapticFeedback.light()
            }
        }
    }
}
