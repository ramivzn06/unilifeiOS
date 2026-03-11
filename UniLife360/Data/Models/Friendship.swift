import Foundation

// Matches DB table: friendships (user_id, friend_id)
struct Friendship: Codable, Identifiable {
    let id: UUID
    let userId: UUID
    let friendId: UUID
    let createdAt: Date

    // Joined
    var friend: AppUser?

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case friendId = "friend_id"
        case createdAt = "created_at"
        case friend
    }
}

// Matches DB table: friend_requests (from_user_id, to_user_id, status)
struct FriendRequest: Codable, Identifiable {
    let id: UUID
    let fromUserId: UUID
    let toUserId: UUID
    var status: String // "pending", "accepted", "declined"
    let createdAt: Date

    // Joined
    var fromUser: AppUser?

    enum CodingKeys: String, CodingKey {
        case id
        case fromUserId = "from_user_id"
        case toUserId = "to_user_id"
        case status
        case createdAt = "created_at"
        case fromUser = "from_user"
    }
}
