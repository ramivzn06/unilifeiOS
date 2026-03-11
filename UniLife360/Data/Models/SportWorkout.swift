import Foundation

struct SportWorkout: Codable, Identifiable {
    let id: UUID
    let userId: UUID
    var name: String
    var type: String
    var duration: Int // in minutes
    var caloriesBurned: Int?
    var notes: String?
    var date: Date
    var exercises: [WorkoutExercise]?
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case name, type, duration
        case caloriesBurned = "calories_burned"
        case notes, date, exercises
        case createdAt = "created_at"
    }
}

struct WorkoutExercise: Codable, Hashable {
    var name: String
    var sets: Int?
    var reps: Int?
    var weight: Double?
    var duration: Int? // in seconds
}
