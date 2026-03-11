import SwiftUI

struct NewApplicationView: View {
    let job: Job
    @Environment(\.dismiss) private var dismiss
    @State private var coverLetter = ""
    @State private var isSaving = false
    @State private var errorMessage: String?
    private let repository = CareerRepository()

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Job info
                VStack(alignment: .leading, spacing: 8) {
                    Text(job.title)
                        .font(.headline)
                    if let company = job.company {
                        Text(company.name)
                            .font(.subheadline)
                            .foregroundColor(Theme.textSecondary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .brutalistCard(backgroundColor: ModuleColors.sport.opacity(0.08))

                // Cover letter
                VStack(alignment: .leading, spacing: 8) {
                    Text("Lettre de motivation")
                        .font(.subheadline)
                        .fontWeight(.semibold)

                    TextEditor(text: $coverLetter)
                        .frame(minHeight: 200)
                        .padding(8)
                        .background(Color.white)
                        .brutalistBorder()
                        .shadow(color: .black.opacity(0.3), radius: 0, x: 2, y: 2)
                }

                if let errorMessage {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                }

                BrutalistButton(
                    title: "Envoyer la candidature",
                    icon: "paperplane.fill",
                    color: ModuleColors.sport,
                    isLoading: isSaving,
                    action: submit
                )
            }
            .padding()
        }
        .background(Theme.background.ignoresSafeArea())
        .navigationTitle("Postuler")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func submit() {
        isSaving = true
        Task {
            guard let userId = await SupabaseManager.shared.currentUserId else { return }

            do {
                try await repository.apply(
                    jobId: job.id,
                    userId: userId,
                    coverLetter: coverLetter.isEmpty ? nil : coverLetter,
                    resumeUrl: nil
                )
                HapticFeedback.success()
                dismiss()
            } catch {
                errorMessage = error.localizedDescription
                HapticFeedback.error()
            }
            isSaving = false
        }
    }
}
