import Foundation

struct SportRepository {
    private let client = SupabaseManager.shared.client

    func getWorkouts(userId: UUID, limit: Int = 20) async throws -> [SportWorkout] {
        try await client
            .from("sport_workouts")
            .select()
            .eq("user_id", value: userId.uuidString)
            .order("date", ascending: false)
            .limit(limit)
            .execute()
            .value
    }

    func addWorkout(_ workout: SportWorkout) async throws {
        try await client
            .from("sport_workouts")
            .insert(workout)
            .execute()
    }

    func deleteWorkout(id: UUID) async throws {
        try await client
            .from("sport_workouts")
            .delete()
            .eq("id", value: id.uuidString)
            .execute()
    }

    func getWeeklyStats(userId: UUID) async throws -> (workouts: Int, totalMinutes: Int, totalCalories: Int) {
        let calendar = Calendar.current
        let now = Date()
        let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now))!
        let formatter = ISO8601DateFormatter()

        let workouts: [SportWorkout] = try await client
            .from("sport_workouts")
            .select()
            .eq("user_id", value: userId.uuidString)
            .gte("date", value: formatter.string(from: weekStart))
            .execute()
            .value

        let totalMinutes = workouts.reduce(0) { $0 + $1.duration }
        let totalCalories = workouts.reduce(0) { $0 + ($1.caloriesBurned ?? 0) }

        return (workouts.count, totalMinutes, totalCalories)
    }
}
