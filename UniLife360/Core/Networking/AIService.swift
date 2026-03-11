import Foundation

@Observable
final class AIService {
    static let shared = AIService()

    private init() {}

    func streamChat(
        context: AIConversationContext,
        messages: [AIMessage],
        onChunk: @escaping (String) -> Void
    ) async throws {
        guard let session = try? await SupabaseManager.shared.client.auth.session else {
            throw AIError.notAuthenticated
        }

        let endpoint: String
        switch context {
        case .finance: endpoint = "/api/ai/finance"
        case .tutor: endpoint = "/api/ai/tutor"
        case .scheduler: endpoint = "/api/ai/scheduler"
        case .summarizer: endpoint = "/api/ai/summarizer"
        case .examGenerator: endpoint = "/api/ai/exam-generator"
        }

        let url = AppConfig.apiBaseURL.appendingPathComponent(endpoint)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(session.accessToken)", forHTTPHeaderField: "Authorization")

        let body: [String: Any] = [
            "messages": messages.map { ["role": $0.role, "content": $0.content] }
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (bytes, response) = try await URLSession.shared.bytes(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw AIError.serverError
        }

        for try await line in bytes.lines {
            if line.hasPrefix("data: ") {
                let data = String(line.dropFirst(6))
                if data == "[DONE]" { break }
                if let jsonData = data.data(using: .utf8),
                   let json = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any],
                   let choices = json["choices"] as? [[String: Any]],
                   let delta = choices.first?["delta"] as? [String: Any],
                   let content = delta["content"] as? String {
                    onChunk(content)
                }
            }
        }
    }
}

enum AIError: LocalizedError {
    case notAuthenticated
    case serverError
    case invalidResponse

    var errorDescription: String? {
        switch self {
        case .notAuthenticated: "Vous devez être connecté"
        case .serverError: "Erreur serveur"
        case .invalidResponse: "Réponse invalide"
        }
    }
}
