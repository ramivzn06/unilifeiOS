import Foundation

struct Job: Codable, Identifiable, Hashable {
    let id: UUID
    let companyId: UUID
    var title: String
    var description: String?
    var location: String?
    var type: JobType
    var salary: String?
    var requirements: [String]?
    var isRemote: Bool
    var isActive: Bool
    var applicationDeadline: Date?
    let createdAt: Date

    // Joined
    var company: Company?

    enum CodingKeys: String, CodingKey {
        case id
        case companyId = "company_id"
        case title, description, location, type, salary, requirements
        case isRemote = "is_remote"
        case isActive = "is_active"
        case applicationDeadline = "application_deadline"
        case createdAt = "created_at"
        case company
    }
}
