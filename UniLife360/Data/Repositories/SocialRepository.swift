import Foundation

struct SocialRepository {
    private let client = SupabaseManager.shared.client

    // MARK: - Social Events
    func getEvents(limit: Int = 20) async throws -> [SocialEvent] {
        try await client
            .from("social_events")
            .select("*, organizer:users(*)")
            .eq("status", value: "published")
            .order("start_date")
            .limit(limit)
            .execute()
            .value
    }

    func getEvent(id: UUID) async throws -> SocialEvent {
        try await client
            .from("social_events")
            .select("*, organizer:users(*)")
            .eq("id", value: id.uuidString)
            .single()
            .execute()
            .value
    }

    // MARK: - Circles
    func getCircles(userId: UUID) async throws -> [Circle] {
        try await client
            .from("circle_members")
            .select("circle:circles(*)")
            .eq("user_id", value: userId.uuidString)
            .execute()
            .value
    }

    func discoverCircles(query: String? = nil) async throws -> [Circle] {
        var dbQuery = client
            .from("circles")
            .select()
            .eq("is_public", value: true)
            .order("member_count", ascending: false)
            .limit(20)

        if let query, !query.isEmpty {
            dbQuery = dbQuery.ilike("name", pattern: "%\(query)%")
        }

        return try await dbQuery.execute().value
    }

    func joinCircle(circleId: UUID, userId: UUID) async throws {
        let member = CircleMember(
            id: UUID(),
            circleId: circleId,
            userId: userId,
            role: .member,
            joinedAt: Date()
        )
        try await client
            .from("circle_members")
            .insert(member)
            .execute()
    }
}
