import Foundation

struct CalendarRepository {
    private let client = SupabaseManager.shared.client

    func getEvents(userId: UUID, from startDate: Date, to endDate: Date) async throws -> [CalendarEvent] {
        let formatter = ISO8601DateFormatter()

        return try await client
            .from("calendar_events")
            .select()
            .eq("user_id", value: userId.uuidString)
            .gte("start_time", value: formatter.string(from: startDate))
            .lte("start_time", value: formatter.string(from: endDate))
            .order("start_time")
            .execute()
            .value
    }

    func addEvent(_ event: CalendarEvent) async throws {
        try await client
            .from("calendar_events")
            .insert(event)
            .execute()
    }

    func updateEvent(_ event: CalendarEvent) async throws {
        try await client
            .from("calendar_events")
            .update(event)
            .eq("id", value: event.id.uuidString)
            .execute()
    }

    func deleteEvent(id: UUID) async throws {
        try await client
            .from("calendar_events")
            .delete()
            .eq("id", value: id.uuidString)
            .execute()
    }
}
