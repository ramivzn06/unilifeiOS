import Foundation

struct FriendsRepository {
    private let client = SupabaseManager.shared.client

    func getFriends(userId: UUID) async throws -> [Friendship] {
        try await client
            .from("friendships")
            .select("*, requester:users!requester_id(*), addressee:users!addressee_id(*)")
            .or("requester_id.eq.\(userId.uuidString),addressee_id.eq.\(userId.uuidString)")
            .eq("status", value: "friends")
            .execute()
            .value
    }

    func getPendingRequests(userId: UUID) async throws -> [Friendship] {
        try await client
            .from("friendships")
            .select("*, requester:users!requester_id(*)")
            .eq("addressee_id", value: userId.uuidString)
            .eq("status", value: "request_received")
            .execute()
            .value
    }

    func sendFriendRequest(from requesterId: UUID, to addresseeId: UUID) async throws {
        let friendship = [
            "requester_id": requesterId.uuidString,
            "addressee_id": addresseeId.uuidString,
            "status": "request_sent"
        ]
        try await client
            .from("friendships")
            .insert(friendship)
            .execute()
    }

    func acceptFriendRequest(id: UUID) async throws {
        try await client
            .from("friendships")
            .update(["status": "friends"])
            .eq("id", value: id.uuidString)
            .execute()
    }

    func declineFriendRequest(id: UUID) async throws {
        try await client
            .from("friendships")
            .delete()
            .eq("id", value: id.uuidString)
            .execute()
    }

    // MARK: - Conversations
    func getConversations(userId: UUID) async throws -> [DMConversation] {
        try await client
            .from("dm_conversations")
            .select()
            .contains("participants", value: [userId.uuidString])
            .order("last_message_at", ascending: false)
            .execute()
            .value
    }

    func getMessages(conversationId: UUID, limit: Int = 50) async throws -> [DirectMessage] {
        try await client
            .from("direct_messages")
            .select("*, sender:users(*)")
            .eq("conversation_id", value: conversationId.uuidString)
            .order("created_at", ascending: false)
            .limit(limit)
            .execute()
            .value
    }

    func sendMessage(conversationId: UUID, senderId: UUID, content: String) async throws {
        let message: [String: String] = [
            "conversation_id": conversationId.uuidString,
            "sender_id": senderId.uuidString,
            "content": content,
            "message_type": "text"
        ]
        try await client
            .from("direct_messages")
            .insert(message)
            .execute()
    }
}
