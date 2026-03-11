import Foundation

struct AcademicRepository {
    private let client = SupabaseManager.shared.client

    // MARK: - Courses
    func getCourses(userId: UUID) async throws -> [Course] {
        try await client
            .from("courses")
            .select()
            .eq("user_id", value: userId.uuidString)
            .order("name")
            .execute()
            .value
    }

    func addCourse(_ course: Course) async throws {
        try await client
            .from("courses")
            .insert(course)
            .execute()
    }

    func deleteCourse(id: UUID) async throws {
        try await client
            .from("courses")
            .delete()
            .eq("id", value: id.uuidString)
            .execute()
    }

    // MARK: - Notes
    func getNotes(userId: UUID, courseId: UUID? = nil) async throws -> [Note] {
        var query = client
            .from("notes")
            .select()
            .eq("user_id", value: userId.uuidString)
            .order("updated_at", ascending: false)

        if let courseId {
            query = query.eq("course_id", value: courseId.uuidString)
        }

        return try await query.execute().value
    }

    func getNote(id: UUID) async throws -> Note {
        try await client
            .from("notes")
            .select()
            .eq("id", value: id.uuidString)
            .single()
            .execute()
            .value
    }

    // MARK: - Exams
    func getExams(userId: UUID, courseId: UUID? = nil) async throws -> [Exam] {
        var query = client
            .from("exams")
            .select()
            .eq("user_id", value: userId.uuidString)

        if let courseId {
            query = query.eq("course_id", value: courseId.uuidString)
        }

        return try await query.execute().value
    }
}
