import SwiftUI

struct ApplicationDetailView: View {
    let application: JobApplication

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Status
                HStack {
                    Text(application.status.label)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 6)
                        .background(application.status.color.opacity(0.2))
                        .clipShape(Capsule())
                    Spacer()
                    Text(application.createdAt, style: .date)
                        .font(.caption)
                        .foregroundColor(Theme.textSecondary)
                }
                .brutalistCard()

                // Job info
                if let job = application.job {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(job.title)
                            .font(.title3)
                            .fontWeight(.bold)
                        if let company = job.company {
                            Text(company.name)
                                .font(.subheadline)
                                .foregroundColor(Theme.textSecondary)
                        }
                    }
                    .brutalistCard()
                }

                // Cover letter
                if let coverLetter = application.coverLetter {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Lettre de motivation")
                            .font(.headline)
                        Text(coverLetter)
                            .font(.body)
                            .foregroundColor(Theme.textSecondary)
                    }
                    .brutalistCard()
                }
            }
            .padding()
        }
        .background(Theme.background.ignoresSafeArea())
        .navigationTitle("Candidature")
        .navigationBarTitleDisplayMode(.inline)
    }
}
