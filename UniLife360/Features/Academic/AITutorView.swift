import SwiftUI

struct AITutorView: View {
    @State private var messages: [AIMessage] = []
    @State private var inputText = ""
    @State private var isStreaming = false
    @State private var streamingText = ""

    var body: some View {
        VStack(spacing: 0) {
            // Messages
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        // Welcome message
                        if messages.isEmpty {
                            welcomeCard
                        }

                        ForEach(messages) { message in
                            messageBubble(message)
                        }

                        if isStreaming {
                            streamingBubble
                        }
                    }
                    .padding()
                    .id("bottom")
                }
                .onChange(of: messages.count) { _, _ in
                    withAnimation {
                        proxy.scrollTo("bottom", anchor: .bottom)
                    }
                }
            }

            Divider()

            // Input
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
                        .background(ModuleColors.studies)
                        .brutalistBorder()
                        .shadow(color: .black.opacity(0.85), radius: 0, x: 2, y: 2)
                }
                .disabled(inputText.isEmpty || isStreaming)
            }
            .padding()
            .background(Theme.background)
        }
        .background(Theme.background.ignoresSafeArea())
        .navigationTitle("Tuteur IA")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var welcomeCard: some View {
        VStack(spacing: 12) {
            Image(systemName: "sparkles")
                .font(.largeTitle)
                .foregroundColor(ModuleColors.studies)

            Text("Tuteur IA")
                .font(.title3)
                .fontWeight(.bold)

            Text("Posez vos questions sur vos cours, demandez des explications ou de l'aide pour vos exercices.")
                .font(.subheadline)
                .foregroundColor(Theme.textSecondary)
                .multilineTextAlignment(.center)

            // Quick suggestions
            VStack(spacing: 8) {
                ForEach(["Explique-moi les pointeurs en C",
                         "Aide-moi avec les intégrales",
                         "Résume le chapitre sur les algorithmes"], id: \.self) { suggestion in
                    Button(action: {
                        inputText = suggestion
                        sendMessage()
                    }) {
                        Text(suggestion)
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(ModuleColors.studiesLight)
                            .brutalistBorder()
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .brutalistCard(backgroundColor: ModuleColors.studies.opacity(0.08))
    }

    private func messageBubble(_ message: AIMessage) -> some View {
        HStack {
            if message.role == "user" { Spacer() }

            VStack(alignment: message.role == "user" ? .trailing : .leading, spacing: 4) {
                Text(message.content)
                    .font(.subheadline)
                    .foregroundColor(Theme.text)
            }
            .padding(12)
            .background(message.role == "user" ? ModuleColors.studiesLight : Color.white)
            .brutalistBorder(cornerRadius: 16)
            .shadow(color: .black.opacity(0.3), radius: 0, x: 2, y: 2)

            if message.role == "assistant" { Spacer() }
        }
    }

    private var streamingBubble: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(streamingText)
                    .font(.subheadline)
                if streamingText.isEmpty {
                    ProgressView()
                        .tint(ModuleColors.studies)
                }
            }
            .padding(12)
            .background(Color.white)
            .brutalistBorder(cornerRadius: 16)
            .shadow(color: .black.opacity(0.3), radius: 0, x: 2, y: 2)

            Spacer()
        }
    }

    private func sendMessage() {
        let content = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !content.isEmpty else { return }

        let userMessage = AIMessage(role: "user", content: content)
        messages.append(userMessage)
        inputText = ""
        isStreaming = true
        streamingText = ""

        Task {
            do {
                try await AIService.shared.streamChat(
                    context: .tutor,
                    messages: messages
                ) { chunk in
                    streamingText += chunk
                }

                let assistantMessage = AIMessage(role: "assistant", content: streamingText)
                messages.append(assistantMessage)
            } catch {
                let errorMsg = AIMessage(role: "assistant", content: "Erreur: \(error.localizedDescription)")
                messages.append(errorMsg)
            }
            isStreaming = false
            streamingText = ""
        }
    }
}
