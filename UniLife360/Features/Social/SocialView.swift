import SwiftUI

struct SocialView: View {
    @State private var events: [SocialEvent] = []
    @State private var circles: [Circle] = []
    @State private var isLoading = false
    @State private var selectedTab = 0
    private let repository = SocialRepository()

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ModuleHeader(
                    title: "Social",
                    subtitle: "Événements & Cercles",
                    icon: "person.3.fill",
                    color: ModuleColors.social
                )

                // Tab selector
                HStack(spacing: 0) {
                    tabButton("Événements", index: 0)
                    tabButton("Cercles", index: 1)
                }
                .background(Color.white)
                .brutalistBorder()
                .shadow(color: .black.opacity(0.3), radius: 0, x: 2, y: 2)
                .padding(.horizontal)

                if selectedTab == 0 {
                    eventsContent
                } else {
                    circlesContent
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
                .background(selectedTab == index ? ModuleColors.social.opacity(0.3) : Color.clear)
        }
        .buttonStyle(.plain)
    }

    private var eventsContent: some View {
        LazyVStack(spacing: 12) {
            if events.isEmpty {
                EmptyStateView(
                    icon: "party.popper",
                    title: "Aucun événement",
                    message: "Les événements campus apparaîtront ici"
                )
            } else {
                ForEach(events) { event in
                    NavigationLink(value: AppDestination.socialEventDetail(event)) {
                        socialEventCard(event)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.horizontal)
    }

    private func socialEventCard(_ event: SocialEvent) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                if let category = event.category {
                    Text(category)
                        .font(.caption2)
                        .fontWeight(.bold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(ModuleColors.social.opacity(0.2))
                        .clipShape(Capsule())
                }
                Spacer()
                Text(event.startDate, style: .date)
                    .font(.caption2)
                    .foregroundColor(Theme.textSecondary)
            }

            Text(event.title)
                .font(.headline)
                .foregroundColor(Theme.text)

            if let description = event.description {
                Text(description)
                    .font(.caption)
                    .foregroundColor(Theme.textSecondary)
                    .lineLimit(2)
            }

            HStack(spacing: 16) {
                if let location = event.location {
                    Label(location, systemImage: "mappin")
                        .font(.caption2)
                        .foregroundColor(Theme.textSecondary)
                }

                Label("\(event.currentParticipants)", systemImage: "person.2")
                    .font(.caption2)
                    .foregroundColor(Theme.textSecondary)

                if let price = event.price, price > 0 {
                    Text(String(format: "%.0f€", price))
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(ModuleColors.finance)
                }
            }
        }
        .brutalistCard()
    }

    private var circlesContent: some View {
        VStack(spacing: 12) {
            NavigationLink(value: AppDestination.circleDiscover) {
                HStack {
                    Image(systemName: "magnifyingglass")
                    Text("Découvrir des cercles")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .foregroundColor(Theme.text)
                .brutalistCard(backgroundColor: ModuleColors.socialLight)
            }
            .buttonStyle(.plain)
            .padding(.horizontal)

            LazyVStack(spacing: 12) {
                if circles.isEmpty {
                    EmptyStateView(
                        icon: "person.3",
                        title: "Aucun cercle",
                        message: "Rejoignez un cercle pour commencer"
                    )
                } else {
                    ForEach(circles) { circle in
                        NavigationLink(value: AppDestination.circleDetail(circle)) {
                            circleCard(circle)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.horizontal)
        }
    }

    private func circleCard(_ circle: Circle) -> some View {
        HStack(spacing: 12) {
            Text(String(circle.name.prefix(1)).uppercased())
                .font(.title3)
                .fontWeight(.bold)
                .frame(width: 44, height: 44)
                .background(ModuleColors.social.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Theme.border, lineWidth: 1)
                )

            VStack(alignment: .leading, spacing: 2) {
                Text(circle.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.text)
                Text("\(circle.memberCount) membres")
                    .font(.caption)
                    .foregroundColor(Theme.textSecondary)
            }

            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(Theme.textSecondary)
        }
        .brutalistCard()
    }

    private func loadData() async {
        isLoading = true
        events = (try? await repository.getEvents()) ?? []
        if let userId = await SupabaseManager.shared.currentUserId {
            circles = (try? await repository.getCircles(userId: userId)) ?? []
        }
        isLoading = false
    }
}
