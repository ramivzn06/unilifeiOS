import Foundation

struct FriendsRepository {
    private let client = SupabaseManager.shared.client

    // MARK: - Friendships (bidirectional: user_id / friend_id)
    func getFriends(userId: UUID) async throws -> [Friendship] {
        try await client
            .from("friendships")
            .select("*, friend:users!friend_id(*)")
            .eq("user_id", value: userId.uuidString)
            .execute()
            .value
    }

    // MARK: - Friend Requests (from_user_id / to_user_id / status)
    func getPendingRequests(userId: UUID) async throws -> [FriendRequest] {
        try await client
            .from("friend_requests")
            .select("*, from_user:users!from_user_id(*)")
            .eq("to_user_id", value: userId.uuidString)
            .eq("status", value: "pending")
            .order("created_at", ascending: false)
            .execute()
            .value
    }

    func sendFriendRequest(from senderId: UUID, to receiverId: UUID) async throws {
        let request: [String: String] = [
            "from_user_id": senderId.uuidString,
            "to_user_id": receiverId.uuidString,
            "status": "pending"
        ]
        try await client
            .from("friend_requests")
            .insert(request)
            .execute()
    }

    func acceptFriendRequest(id: UUID, fromUserId: UUID, toUserId: UUID) async throws {
        // 1. Update request status
        try await client
            .from("friend_requests")
            .update(["status": "accepted"])
            .eq("id", value: id.uuidString)
            .execute()

        // 2. Create bidirectional friendships
        let friendship1: [String: String] = [
            "user_id": fromUserId.uuidString,
            "friend_id": toUserId.uuidString
        ]
        let friendship2: [String: String] = [
            "user_id": toUserId.uuidString,
            "friend_id": fromUserId.uuidString
        ]
        try await client
            .from("friendships")
            .insert([friendship1, friendship2])
            .execute()
    }

    func declineFriendRequest(id: UUID) async throws {
        try await client
            .from("friend_requests")
            .update(["status": "declined"])
            .eq("id", value: id.uuidString)
            .execute()
    }

    func removeFriend(userId: UUID, friendId: UUID) async throws {
        // Delete both directions
        try await client
            .from("friendships")
            .delete()
            .eq("user_id", value: userId.uuidString)
            .eq("friend_id", value: friendId.uuidString)
            .execute()

        try await client
            .from("friendships")
            .delete()
            .eq("user_id", value: friendId.uuidString)
            .eq("friend_id", value: userId.uuidString)
            .execute()
    }

    // MARK: - Direct Messages
    func getMessages(senderId: UUID, receiverId: UUID, limit: Int = 50) async throws -> [DirectMessage] {
        try await client
            .from("direct_messages")
            .select("*, sender:users!sender_id(*)")
            .or("and(sender_id.eq.\(senderId.uuidString),receiver_id.eq.\(receiverId.uuidString)),and(sender_id.eq.\(receiverId.uuidString),receiver_id.eq.\(senderId.uuidString))")
            .order("created_at", ascending: true)
            .limit(limit)
            .execute()
            .value
    }

    func sendMessage(senderId: UUID, receiverId: UUID, content: String) async throws {
        let message: [String: String] = [
            "sender_id": senderId.uuidString,
            "receiver_id": receiverId.uuidString,
            "content": content,
            "message_type": "text"
        ]
        try await client
            .from("direct_messages")
            .insert(message)
            .execute()
    }

    func markMessagesAsRead(senderId: UUID, receiverId: UUID) async throws {
        let now = ISO8601DateFormatter().string(from: Date())
        try await client
            .from("direct_messages")
            .update(["read_at": now])
            .eq("sender_id", value: senderId.uuidString)
            .eq("receiver_id", value: receiverId.uuidString)
            .is("read_at", value: nil)
            .execute()
    }
}
