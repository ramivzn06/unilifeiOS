import Foundation

struct CareerRepository {
    private let client = SupabaseManager.shared.client

    func getJobs(type: JobType? = nil, isRemote: Bool? = nil) async throws -> [Job] {
        var query = client
            .from("jobs")
            .select("*, company:companies(*)")
            .eq("is_active", value: "true")

        if let type {
            query = query.eq("type", value: type.rawValue)
        }

        if let isRemote {
            query = query.eq("is_remote", value: String(isRemote))
        }

        return try await query
            .order("created_at", ascending: false)
            .limit(30)
            .execute()
            .value
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
        var application: [String: String] = [
            "job_id": jobId.uuidString,
            "user_id": userId.uuidString,
            "status": "pending"
        ]
        if let coverLetter { application["cover_letter"] = coverLetter }
        if let resumeUrl { application["resume_url"] = resumeUrl }

        try await client
            .from("applications")
            .insert(application)
            .execute()
    }
}
