import Foundation

enum AppDestination: Hashable {
    // Finance
    case financeDetail
    case newTransaction
    case budgetSettings
    case financeAdvisor

    // Schedule
    case eventDetail(CalendarEvent)
    case newEvent

    // Academic
    case courseDetail(Course)
    case noteDetail(Note)
    case aiTutor
    case examPractice

    // Social
    case socialEventDetail(SocialEvent)
    case circleDetail(Circle)
    case circleDiscover

    // Friends
    case friendProfile(UUID)
    case chat(AppUser)
    case friendRequests

    // Career
    case jobDetail(Job)
    case applicationDetail(JobApplication)
    case newApplication(Job)

    // Profile
    case profile
    case editProfile
    case settings

    // Sport
    case sportDetail
    case newWorkout
}
