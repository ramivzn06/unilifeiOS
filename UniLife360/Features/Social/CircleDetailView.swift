import SwiftUI

struct CircleDetailView: View {
    let circle: Circle

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Header
                VStack(spacing: 12) {
                    Text(String(circle.name.prefix(1)).uppercased())
                        .font(.system(size: 36, weight: .bold))
                        .frame(width: 72, height: 72)
                        .background(ModuleColors.social.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Theme.border, lineWidth: 2)
                        )
                        .shadow(color: .black.opacity(0.85), radius: 0, x: 3, y: 3)

                    Text(circle.name)
                        .font(.title2)
                        .fontWeight(.bold)

                    HStack(spacing: 16) {
                        Label("\(circle.memberCount) membres", systemImage: "person.2")
                        if circle.isPublic {
                            Label("Public", systemImage: "globe")
                        }
                    }
                    .font(.subheadline)
                    .foregroundColor(Theme.textSecondary)
                }
                .frame(maxWidth: .infinity)
                .brutalistCard(backgroundColor: ModuleColors.social.opacity(0.08))

                // Description
                if let description = circle.description {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("À propos")
                            .font(.headline)
                        Text(description)
                            .font(.body)
                            .foregroundColor(Theme.textSecondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .brutalistCard()
                }

                // Channels placeholder
                VStack(alignment: .leading, spacing: 12) {
                    Text("Channels")
                        .font(.headline)

                    ForEach(["general", "annonces"], id: \.self) { channel in
                        HStack {
                            Image(systemName: "number")
                                .foregroundColor(ModuleColors.social)
                            Text(channel)
                                .font(.subheadline)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(Theme.textSecondary)
                        }
                        .padding(.vertical, 8)
                        if channel != "annonces" {
                            Divider()
                        }
                    }
                }
                .brutalistCard()
            }
            .padding()
        }
        .background(Theme.background.ignoresSafeArea())
        .navigationTitle(circle.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
