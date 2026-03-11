import SwiftUI

struct FinanceAdvisorView: View {
    @State private var messages: [AIMessage] = []
    @State private var inputText = ""
    @State private var isStreaming = false
    @State private var streamingText = ""

    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        if messages.isEmpty {
                            welcomeCard
                        }

                        ForEach(messages) { message in
                            messageBubble(message)
                        }

                        if isStreaming {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(streamingText)
                                        .font(.subheadline)
                                    if streamingText.isEmpty {
                                        ProgressView()
                                            .tint(ModuleColors.finance)
                                    }
                                }
                                .padding(12)
                                .background(Color.white)
                                .brutalistBorder(cornerRadius: 16)
                                Spacer()
                            }
                        }
                    }
                    .padding()
                    .id("bottom")
                }
                .onChange(of: messages.count) { _, _ in
                    withAnimation { proxy.scrollTo("bottom", anchor: .bottom) }
                }
            }

            Divider()

            HStack(spacing: 12) {
                TextField("Posez votre question...", text: $inputText)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color.white)
                    .brutalistBorder()

                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .font(.title3)
                        .foregroundColor(.black)
                        .frame(width: 44, height: 44)
                        .background(ModuleColors.finance)
                        .brutalistBorder()
                        .shadow(color: .black.opacity(0.85), radius: 0, x: 2, y: 2)
                }
                .disabled(inputText.isEmpty || isStreaming)
            }
            .padding()
            .background(Theme.background)
        }
        .background(Theme.background.ignoresSafeArea())
        .navigationTitle("Conseiller Finance IA")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var welcomeCard: some View {
        VStack(spacing: 12) {
            Image(systemName: "sparkles")
                .font(.largeTitle)
                .foregroundColor(ModuleColors.finance)

            Text("Conseiller Finance")
                .font(.title3)
                .fontWeight(.bold)

            Text("Posez vos questions sur votre budget, vos dépenses ou demandez des conseils d'épargne.")
                .font(.subheadline)
                .foregroundColor(Theme.textSecondary)
                .multilineTextAlignment(.center)

            VStack(spacing: 8) {
                ForEach(["Comment réduire mes dépenses ?",
                         "Aide-moi à planifier mon budget",
                         "Conseils pour épargner en tant qu'étudiant"], id: \.self) { suggestion in
                    Button(action: {
                        inputText = suggestion
                        sendMessage()
                    }) {
                        Text(suggestion)
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(ModuleColors.financeLight)
                            .brutalistBorder()
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .brutalistCard(backgroundColor: ModuleColors.finance.opacity(0.08))
    }

    private func messageBubble(_ message: AIMessage) -> some View {
        HStack {
            if message.role == "user" { Spacer() }
            Text(message.content)
                .font(.subheadline)
                .padding(12)
                .background(message.role == "user" ? ModuleColors.financeLight : Color.white)
                .brutalistBorder(cornerRadius: 16)
                .shadow(color: .black.opacity(0.3), radius: 0, x: 2, y: 2)
            if message.role == "assistant" { Spacer() }
        }
    }

    private func sendMessage() {
        let content = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !content.isEmpty else { return }

        messages.append(AIMessage(role: "user", content: content))
        inputText = ""
        isStreaming = true
        streamingText = ""

        Task {
            do {
                try await AIService.shared.streamChat(
                    context: .finance,
                    messages: messages
                ) { chunk in
                    streamingText += chunk
                }
                messages.append(AIMessage(role: "assistant", content: streamingText))
            } catch {
                messages.append(AIMessage(role: "assistant", content: "Erreur: \(error.localizedDescription)"))
            }
            isStreaming = false
            streamingText = ""
        }
    }
}
