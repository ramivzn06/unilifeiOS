import Foundation

struct Exam: Codable, Identifiable {
    let id: UUID
    let userId: UUID
    var courseId: UUID?
    var title: String
    var description: String?
    var questions: [ExamQuestion]?
    var generatedByAI: Bool
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case courseId = "course_id"
        case title, description, questions
        case generatedByAI = "generated_by_ai"
        case createdAt = "created_at"
    }
}

struct ExamQuestion: Codable, Hashable {
    var question: String
    var type: ExamQuestionType
    var options: [String]?
    var correctAnswer: String?
    var explanation: String?

    enum CodingKeys: String, CodingKey {
        case question, type, options
        case correctAnswer = "correct_answer"
        case explanation
    }
}
