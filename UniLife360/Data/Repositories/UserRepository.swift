import Foundation

struct UserRepository {
    private let client = SupabaseManager.shared.client

    func getUser(id: UUID) async throws -> AppUser {
        try await client
            .from("users")
            .select()
            .eq("id", value: id.uuidString)
            .single()
            .execute()
            .value
    }

    func updateUser(_ user: AppUser) async throws {
        try await client
            .from("users")
            .update(user)
            .eq("id", value: user.id.uuidString)
            .execute()
    }

    func searchUsers(query: String) async throws -> [AppUser] {
        try await client
            .from("users")
            .select()
            .ilike("full_name", pattern: "%\(query)%")
            .limit(20)
            .execute()
            .value
    }
}
