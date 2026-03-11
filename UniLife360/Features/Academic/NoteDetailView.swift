import SwiftUI

struct NoteDetailView: View {
    let note: Note

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text(note.title)
                        .font(.title2)
                        .fontWeight(.bold)

                    HStack(spacing: 12) {
                        Label(visibilityLabel(note.visibility), systemImage: visibilityIcon(note.visibility))
                            .font(.caption)
                            .foregroundColor(Theme.textSecondary)

                        if let updated = note.updatedAt {
                            Text("Modifié \(updated, style: .relative)")
                                .font(.caption)
                                .foregroundColor(Theme.textSecondary)
                        }
                    }

                    if let tags = note.tags, !tags.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 6) {
                                ForEach(tags, id: \.self) { tag in
                                    Text(tag)
                                        .font(.caption2)
                                        .fontWeight(.medium)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(ModuleColors.studiesLight)
                                        .clipShape(Capsule())
                                }
                            }
                        }
                    }
                }
                .brutalistCard(backgroundColor: ModuleColors.studies.opacity(0.1))

                // Content (plain text rendering)
                if let content = note.plainTextContent ?? note.content {
                    Text(content)
                        .font(.body)
                        .lineSpacing(6)
                        .brutalistCard()
                } else {
                    EmptyStateView(
                        icon: "doc.text",
                        title: "Contenu vide",
                        message: "Cette note n'a pas encore de contenu"
                    )
                }
            }
            .padding()
        }
        .background(Theme.background.ignoresSafeArea())
        .navigationTitle("Note")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func visibilityLabel(_ visibility: NoteVisibility) -> String {
        switch visibility {
        case .private: "Privée"
        case .courseShared: "Partagée (cours)"
        case .public: "Publique"
        }
    }

    private func visibilityIcon(_ visibility: NoteVisibility) -> String {
        switch visibility {
        case .private: "lock"
        case .courseShared: "person.2"
        case .public: "globe"
        }
    }
}
