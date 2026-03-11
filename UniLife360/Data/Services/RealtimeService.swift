import Foundation
import Supabase
import Realtime

@Observable
final class RealtimeService {
    static let shared = RealtimeService()

    private var channels: [String: RealtimeChannelV2] = [:]

    private init() {}

    func subscribeToMessages(
        userId: UUID,
        otherUserId: UUID,
        onMessage: @escaping (DirectMessage) -> Void
    ) async {
        let channelKey = "messages:\(userId):\(otherUserId)"

        // Remove existing channel if any
        if let existing = channels[channelKey] {
            await existing.unsubscribe()
        }

        let channel = SupabaseManager.shared.client.realtimeV2.channel(channelKey)

        // Listen for messages sent TO me from this user
        let changes = channel.postgresChange(
            InsertAction.self,
            table: "direct_messages",
            filter: "receiver_id=eq.\(userId.uuidString)"
        )

        await channel.subscribe()
        channels[channelKey] = channel

        Task {
            for await change in changes {
                if let message = try? change.decodeRecord(as: DirectMessage.self, decoder: JSONDecoder()) {
                    // Only show messages from the other user in this conversation
                    if message.senderId == otherUserId {
                        await MainActor.run {
                            onMessage(message)
                        }
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
