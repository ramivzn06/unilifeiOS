import Foundation

struct SocialRepository {
    private let client = SupabaseManager.shared.client

    // MARK: - Social Events (uses social_events view → events table)
    func getEvents(limit: Int = 20) async throws -> [SocialEvent] {
        try await client
            .from("social_events")
            .select("*, organizer:users!created_by(*)")
            .eq("status", value: "published")
            .order("start_time", ascending: true)
            .limit(limit)
            .execute()
            .value
    }

    func getEvent(id: UUID) async throws -> SocialEvent {
        try await client
            .from("social_events")
            .select("*, organizer:users!created_by(*)")
            .eq("id", value: id.uuidString)
            .single()
            .execute()
            .value
    }

    func getEventsByCircle(circleId: UUID) async throws -> [SocialEvent] {
        try await client
            .from("social_events")
            .select("*, organizer:users!created_by(*)")
            .eq("circle_id", value: circleId.uuidString)
            .order("start_time", ascending: true)
            .execute()
            .value
    }

    // MARK: - Event Tickets
    func registerForEvent(eventId: UUID, userId: UUID) async throws {
        let ticket: [String: String] = [
            "event_id": eventId.uuidString,
            "user_id": userId.uuidString,
            "status": "reserved"
        ]
        try await client
            .from("event_tickets")
            .insert(ticket)
            .execute()
    }

    func cancelRegistration(eventId: UUID, userId: UUID) async throws {
        try await client
            .from("event_tickets")
            .update(["status": "cancelled"])
            .eq("event_id", value: eventId.uuidString)
            .eq("user_id", value: userId.uuidString)
            .execute()
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

    func getCircle(id: UUID) async throws -> Circle {
        try await client
            .from("circles")
            .select()
            .eq("id", value: id.uuidString)
            .single()
            .execute()
            .value
    }

    func discoverCircles(query: String? = nil) async throws -> [Circle] {
        var dbQuery = client
            .from("circles")
            .select()
            .eq("is_public", value: true)
            .limit(20)

        if let query, !query.isEmpty {
            dbQuery = dbQuery.ilike("name", pattern: "%\(query)%")
        }

        return try await dbQuery.execute().value
    }

    func joinCircle(circleId: UUID, userId: UUID) async throws {
        let member: [String: String] = [
            "circle_id": circleId.uuidString,
            "user_id": userId.uuidString,
            "role": "member"
        ]
        try await client
            .from("circle_members")
            .insert(member)
            .execute()
    }

    func leaveCircle(circleId: UUID, userId: UUID) async throws {
        try await client
            .from("circle_members")
            .delete()
            .eq("circle_id", value: circleId.uuidString)
            .eq("user_id", value: userId.uuidString)
            .execute()
    }

    func getCircleMembers(circleId: UUID) async throws -> [CircleMember] {
        try await client
            .from("circle_members")
            .select("*, user:users(*)")
            .eq("circle_id", value: circleId.uuidString)
            .execute()
            .value
    }
}
