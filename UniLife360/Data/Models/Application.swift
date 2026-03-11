import Foundation

struct JobApplication: Codable, Identifiable {
    let id: UUID
    let jobId: UUID
    let userId: UUID
    var coverLetter: String?
    var resumeUrl: String?
    var status: ApplicationStatus
    let createdAt: Date
    var updatedAt: Date?

    // Joined
    var job: Job?

    enum CodingKeys: String, CodingKey {
        case id
        case jobId = "job_id"
        case userId = "user_id"
        case coverLetter = "cover_letter"
        case resumeUrl = "resume_url"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case job
    }
}
