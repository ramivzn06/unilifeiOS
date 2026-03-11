import Foundation
import Supabase
import Realtime

@Observable
final class RealtimeService {
    static let shared = RealtimeService()

    private var channels: [String: RealtimeChannelV2] = [:]

    private init() {}

    func subscribeToMessages(
        conversationId: UUID,
        onMessage: @escaping (DirectMessage) -> Void
    ) async {
        let channelKey = "messages:\(conversationId)"

        // Remove existing channel if any
        if let existing = channels[channelKey] {
            await existing.unsubscribe()
        }

        let channel = SupabaseManager.shared.client.realtimeV2.channel(channelKey)

        let changes = channel.postgresChange(
            InsertAction.self,
            table: "direct_messages",
            filter: "conversation_id=eq.\(conversationId.uuidString)"
        )

        await channel.subscribe()
        channels[channelKey] = channel

        Task {
            for await change in changes {
                if let message = try? change.decodeRecord(as: DirectMessage.self, decoder: JSONDecoder()) {
                    await MainActor.run {
                        onMessage(message)
                    }
                }
            }
        }
    }

    func unsubscribe(from channelKey: String) async {
        if let channel = channels[channelKey] {
            await channel.unsubscribe()
            channels.removeValue(forKey: channelKey)
        }
    }

    func unsubscribeAll() async {
        for (_, channel) in channels {
            await channel.unsubscribe()
        }
        channels.removeAll()
    }
}
