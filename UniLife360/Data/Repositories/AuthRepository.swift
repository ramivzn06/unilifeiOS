import Foundation
import Supabase

struct AuthRepository {
    private let client = SupabaseManager.shared.client

    func getCurrentSession() async throws -> Session {
        try await client.auth.session
    }

    func signIn(email: String, password: String) async throws -> Session {
        try await client.auth.signIn(email: email, password: password)
    }

    func signUp(email: String, password: String, data: [String: AnyJSON]) async throws {
        try await client.auth.signUp(email: email, password: password, data: data)
    }

    func signOut() async throws {
        try await client.auth.signOut()
    }

    func updateUserMetadata(_ data: [String: AnyJSON]) async throws {
        try await client.auth.update(user: UserAttributes(data: data))
    }
}
