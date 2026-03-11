import SwiftUI

struct CareerView: View {
    @State private var jobs: [Job] = []
    @State private var applications: [JobApplication] = []
    @State private var selectedTab = 0
    @State private var selectedType: JobType?
    @State private var isLoading = false
    private let repository = CareerRepository()

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ModuleHeader(
                    title: "Carrière",
                    subtitle: "Offres & Candidatures",
                    icon: "briefcase.fill",
                    color: ModuleColors.sport
                )

                // Tab selector
                HStack(spacing: 0) {
                    tabButton("Offres", index: 0)
                    tabButton("Candidatures", index: 1)
                }
                .background(Color.white)
                .brutalistBorder()
                .shadow(color: .black.opacity(0.3), radius: 0, x: 2, y: 2)
                .padding(.horizontal)

                if selectedTab == 0 {
                    jobsContent
                } else {
                    applicationsContent
                }
            }
            .padding(.bottom, 32)
        }
        .background(Theme.background.ignoresSafeArea())
        .task { await loadData() }
    }

    private func tabButton(_ title: String, index: Int) -> some View {
        Button(action: {
            withAnimation(.spring(response: 0.3)) { selectedTab = index }
            HapticFeedback.selection()
        }) {
            Text(title)
                .font(.subheadline)
                .fontWeight(selectedTab == index ? .bold : .medium)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(selectedTab == index ? ModuleColors.sport.opacity(0.3) : Color.clear)
        }
        .buttonStyle(.plain)
    }

    private var jobsContent: some View {
        VStack(spacing: 12) {
            // Type filter
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    filterChip("Tous", isSelected: selectedType == nil) {
                        selectedType = nil
                        Task { await loadData() }
                    }
                    ForEach(JobType.allCases, id: \.self) { type in
                        filterChip(type.label, isSelected: selectedType == type) {
                            selectedType = type
                            Task { await loadData() }
                        }
                    }
                }
                .padding(.horizontal)
            }

            LazyVStack(spacing: 12) {
                if jobs.isEmpty {
                    EmptyStateView(
                        icon: "briefcase",
                        title: "Aucune offre",
                        message: "Les offres apparaîtront ici"
                    )
                } else {
                    ForEach(jobs) { job in
                        NavigationLink(value: AppDestination.jobDetail(job)) {
                            jobCard(job)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.horizontal)
        }
    }

    private func filterChip(_ label: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: {
            action()
            HapticFeedback.selection()
        }) {
            Text(label)
                .font(.caption)
                .fontWeight(.semibold)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(isSelected ? ModuleColors.sport : Color.white)
                .brutalistBorder()
        }
        .buttonStyle(.plain)
    }

    private func jobCard(_ job: Job) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(job.type.label)
                    .font(.caption2)
                    .fontWeight(.bold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(ModuleColors.sportLight)
                    .clipShape(Capsule())

                if job.isRemote {
                    Text("Remote")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(ModuleColors.financeLight)
                        .clipShape(Capsule())
                }
                Spacer()
            }

            Text(job.title)
                .font(.headline)
                .foregroundColor(Theme.text)

            if let company = job.company {
                Text(company.name)
                    .font(.subheadline)
                    .foregroundColor(Theme.textSecondary)
            }

            HStack(spacing: 16) {
                if let location = job.location {
                    Label(location, systemImage: "mappin")
                        .font(.caption2)
                        .foregroundColor(Theme.textSecondary)
                }
                if let salary = job.salary {
                    Label(salary, systemImage: "banknote")
                        .font(.caption2)
                        .foregroundColor(ModuleColors.finance)
                }
            }
        }
        .brutalistCard()
    }

    private var applicationsContent: some View {
        LazyVStack(spacing: 12) {
            if applications.isEmpty {
                EmptyStateView(
                    icon: "doc.text",
                    title: "Aucune candidature",
                    message: "Postulez à des offres pour voir vos candidatures ici"
                )
            } else {
                ForEach(applications) { application in
                    applicationCard(application)
                }
            }
        }
        .padding(.horizontal)
    }

    private func applicationCard(_ application: JobApplication) -> some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(application.job?.title ?? "Poste")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text(application.job?.company?.name ?? "Entreprise")
                    .font(.caption)
                    .foregroundColor(Theme.textSecondary)
            }

            Spacer()

            Text(application.status.label)
                .font(.caption2)
                .fontWeight(.bold)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(application.status.color.opacity(0.3))
                .clipShape(Capsule())
        }
        .brutalistCard()
    }

    private func loadData() async {
        isLoading = true
        jobs = (try? await repository.getJobs(type: selectedType)) ?? []
        if let userId = await SupabaseManager.shared.currentUserId {
            applications = (try? await repository.getApplications(userId: userId)) ?? []
        }
        isLoading = false
    }
}
