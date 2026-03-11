import SwiftUI

struct JobDetailView: View {
    let job: Job

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Header
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text(job.type.label)
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(ModuleColors.sportLight)
                            .clipShape(Capsule())
                        if job.isRemote {
                            Text("Remote")
                                .font(.caption)
                                .fontWeight(.bold)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(ModuleColors.financeLight)
                                .clipShape(Capsule())
                        }
                        Spacer()
                    }

                    Text(job.title)
                        .font(.title2)
                        .fontWeight(.bold)

                    if let company = job.company {
                        HStack(spacing: 8) {
                            Text(String(company.name.prefix(1)).uppercased())
                                .font(.caption)
                                .fontWeight(.bold)
                                .frame(width: 32, height: 32)
                                .background(ModuleColors.sport.opacity(0.2))
                                .clipShape(RoundedRectangle(cornerRadius: 8))

                            VStack(alignment: .leading) {
                                Text(company.name)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                if let industry = company.industry {
                                    Text(industry)
                                        .font(.caption)
                                        .foregroundColor(Theme.textSecondary)
                                }
                            }
                        }
                    }
                }
                .brutalistCard(backgroundColor: ModuleColors.sport.opacity(0.08))

                // Info
                VStack(spacing: 12) {
                    if let location = job.location {
                        infoRow(icon: "mappin", label: "Lieu", value: location)
                    }
                    if let salary = job.salary {
                        infoRow(icon: "banknote", label: "Salaire", value: salary)
                    }
                    if let deadline = job.applicationDeadline {
                        let formatter = DateFormatter()
                        let _ = formatter.dateStyle = .long
                        let _ = formatter.locale = Locale(identifier: "fr_FR")
                        infoRow(icon: "calendar", label: "Date limite", value: formatter.string(from: deadline))
                    }
                }
                .brutalistCard()

                // Description
                if let description = job.description {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description")
                            .font(.headline)
                        Text(description)
                            .font(.body)
                            .foregroundColor(Theme.textSecondary)
                    }
                    .brutalistCard()
                }

                // Requirements
                if let requirements = job.requirements, !requirements.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Prérequis")
                            .font(.headline)

                        ForEach(requirements, id: \.self) { req in
                            HStack(alignment: .top, spacing: 8) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(ModuleColors.finance)
                                    .font(.caption)
                                Text(req)
                                    .font(.subheadline)
                            }
                        }
                    }
                    .brutalistCard()
                }

                // Apply button
                NavigationLink(value: AppDestination.newApplication(job)) {
                    HStack {
                        Spacer()
                        Label("Postuler", systemImage: "paperplane.fill")
                            .fontWeight(.bold)
                        Spacer()
                    }
                    .padding(.vertical, 14)
                    .background(ModuleColors.sport)
                    .brutalistBorder()
                    .shadow(color: .black.opacity(0.85), radius: 0, x: 4, y: 4)
                }
                .buttonStyle(.plain)
            }
            .padding()
        }
        .background(Theme.background.ignoresSafeArea())
        .navigationTitle("Offre")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func infoRow(icon: String, label: String, value: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(ModuleColors.sport)
                .frame(width: 24)
            Text(label)
                .font(.subheadline)
                .foregroundColor(Theme.textSecondary)
            Spacer()
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
        }
    }
}
