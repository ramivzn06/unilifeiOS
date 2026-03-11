import SwiftUI

struct CircleDiscoverView: View {
    @State private var circles: [StudyCircle] = []
    @State private var searchText = ""
    @State private var isLoading = false
    private let repository = SocialRepository()

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Search
                BrutalistInput(placeholder: "Rechercher un cercle...", text: $searchText, icon: "magnifyingglass")
                    .padding(.horizontal)
                    .onChange(of: searchText) { _, _ in
                        Task { await search() }
                    }

                if isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, minHeight: 200)
                } else if circles.isEmpty {
                    EmptyStateView(
                        icon: "person.3",
                        title: "Aucun cercle trouvé",
                        message: "Essayez une autre recherche"
                    )
                } else {
                    LazyVStack(spacing: 12) {
                        ForEach(circles) { circle in
                            discoverCard(circle)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .background(Theme.background.ignoresSafeArea())
        .navigationTitle("Découvrir")
        .navigationBarTitleDisplayMode(.inline)
        .task { await search() }
    }

    private func discoverCard(_ circle: StudyCircle) -> some View {
        HStack(spacing: 12) {
            Text(String(circle.name.prefix(1)).uppercased())
                .font(.title3)
                .fontWeight(.bold)
                .frame(width: 48, height: 48)
                .background(ModuleColors.social.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 2) {
                Text(circle.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                if let description = circle.description {
                    Text(description)
                        .font(.caption)
                        .foregroundColor(Theme.textSecondary)
                        .lineLimit(1)
                }
                Text("\(circle.memberCount) membres")
                    .font(.caption2)
                    .foregroundColor(Theme.textSecondary)
            }

            Spacer()

            Button("Rejoindre") {}
                .font(.caption)
                .fontWeight(.bold)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(ModuleColors.social)
                .clipShape(Capsule())
                .overlay(Capsule().stroke(Theme.border, lineWidth: 1))
        }
        .brutalistCard()
    }

    private func search() async {
        isLoading = true
        circles = (try? await repository.discoverCircles(query: searchText.isEmpty ? nil : searchText)) ?? []
        isLoading = false
    }
}
