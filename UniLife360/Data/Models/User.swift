import Foundation

struct AppUser: Codable, Identifiable, Hashable {
    let id: UUID
    var fullName: String?
    var email: String?
    var avatarUrl: String?
    var university: String?
    var fieldOfStudy: String?
    var studyYear: String?
    var bio: String?
    var onboardingCompleted: Bool
    var role: UserRole
    var xpPoints: Int
    var streakDays: Int
    var socialLinks: [String: String]?
    let createdAt: Date
    var updatedAt: Date?

    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case email
        case avatarUrl = "avatar_url"
        case university
        case fieldOfStudy = "field_of_study"
        case studyYear = "study_year"
        case bio
        case onboardingCompleted = "onboarding_completed"
        case role
        case xpPoints = "xp_points"
        case streakDays = "streak_days"
        case socialLinks = "social_links"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
