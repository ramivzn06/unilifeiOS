import Foundation

enum CircleRole: String, Codable {
    case owner, admin, member
}

enum UserRole: String, Codable {
    case student, company, admin
}

enum FriendStatus: String, Codable {
    case none, friends
    case requestSent = "request_sent"
    case requestReceived = "request_received"
    case `self`
}
