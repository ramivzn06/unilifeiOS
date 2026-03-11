import Foundation

enum NoteVisibility: String, Codable {
    case `private` = "private"
    case courseShared = "course_shared"
    case `public` = "public"
}

enum AIConversationContext: String, Codable {
    case finance, tutor, scheduler, summarizer
    case examGenerator = "exam_generator"
}

enum ExamQuestionType: String, Codable {
    case multipleChoice = "multiple_choice"
    case trueFalse = "true_false"
    case shortAnswer = "short_answer"
    case essay
}
