import Foundation

@Observable
final class AcademicViewModel {
    var courses: [Course] = []
    var notes: [Note] = []
    var isLoading = false
    var errorMessage: String?
    var selectedCourse: Course?

    private let repository = AcademicRepository()

    func loadCourses() async {
        guard let userId = await SupabaseManager.shared.currentUserId else { return }
        isLoading = true

        do {
            courses = try await repository.getCourses(userId: userId)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func loadNotes(courseId: UUID? = nil) async {
        guard let userId = await SupabaseManager.shared.currentUserId else { return }

        do {
            notes = try await repository.getNotes(userId: userId, courseId: courseId)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func deleteCourse(_ course: Course) async {
        do {
            try await repository.deleteCourse(id: course.id)
            courses.removeAll { $0.id == course.id }
            HapticFeedback.success()
        } catch {
            errorMessage = error.localizedDescription
            HapticFeedback.error()
        }
    }
}
