import Foundation

struct CareerRepository {
    private let client = SupabaseManager.shared.client

    func getJobs(type: JobType? = nil, isRemote: Bool? = nil) async throws -> [Job] {
        var query = client
            .from("jobs")
            .select("*, company:companies(*)")
            .eq("is_active", value: true)
            .order("created_at", ascending: false)

        if let type {
            query = query.eq("type", value: type.rawValue)
        }

        if let isRemote {
            query = query.eq("is_remote", value: isRemote)
        }

        return try await query.limit(30).execute().value
    }

    func getJob(id: UUID) async throws -> Job {
        try await client
            .from("jobs")
            .select("*, company:companies(*)")
            .eq("id", value: id.uuidString)
            .single()
            .execute()
            .value
    }

    func getApplications(userId: UUID) async throws -> [JobApplication] {
        try await client
            .from("applications")
            .select("*, job:jobs(*, company:companies(*))")
            .eq("user_id", value: userId.uuidString)
            .order("created_at", ascending: false)
            .execute()
            .value
    }

    func apply(jobId: UUID, userId: UUID, coverLetter: String?, resumeUrl: String?) async throws {
        let application: [String: String?] = [
            "job_id": jobId.uuidString,
            "user_id": userId.uuidString,
            "cover_letter": coverLetter,
            "resume_url": resumeUrl,
            "status": "pending"
        ]
        try await client
            .from("applications")
            .insert(application)
            .execute()
    }
}
