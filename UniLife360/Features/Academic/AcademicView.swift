import SwiftUI

struct AcademicView: View {
    @State private var viewModel = AcademicViewModel()
    @State private var selectedTab = 0

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ModuleHeader(
                    title: "Études",
                    subtitle: "\(viewModel.courses.count) cours",
                    icon: "book.fill",
                    color: ModuleColors.studies
                )

                // Tab selector
                HStack(spacing: 0) {
                    tabButton("Cours", index: 0)
                    tabButton("Notes", index: 1)
                }
                .background(Color.white)
                .brutalistBorder()
                .shadow(color: .black.opacity(0.3), radius: 0, x: 2, y: 2)
                .padding(.horizontal)

                if selectedTab == 0 {
                    coursesContent
                } else {
                    notesContent
                }
            }
            .padding(.bottom, 32)
        }
        .background(Theme.background.ignoresSafeArea())
        .task {
            await viewModel.loadCourses()
            await viewModel.loadNotes()
        }
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
                .background(selectedTab == index ? ModuleColors.studies.opacity(0.3) : Color.clear)
        }
        .buttonStyle(.plain)
    }

    private var coursesContent: some View {
        LazyVStack(spacing: 12) {
            if viewModel.courses.isEmpty && !viewModel.isLoading {
                EmptyStateView(
                    icon: "book.closed",
                    title: "Aucun cours",
                    message: "Ajoutez vos cours pour commencer"
                )
            } else {
                ForEach(viewModel.courses) { course in
                    NavigationLink(value: AppDestination.courseDetail(course)) {
                        courseCard(course)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.horizontal)
    }

    private func courseCard(_ course: Course) -> some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(hex: course.color ?? "#d8b4fe"))
                .frame(width: 8)
                .frame(maxHeight: .infinity)

            VStack(alignment: .leading, spacing: 4) {
                if let code = course.code {
                    Text(code)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(Theme.textSecondary)
                }
                Text(course.name)
                    .font(.headline)
                    .foregroundColor(Theme.text)

                if let professor = course.professor {
                    HStack(spacing: 4) {
                        Image(systemName: "person")
                            .font(.caption2)
                        Text(professor)
                            .font(.caption)
                    }
                    .foregroundColor(Theme.textSecondary)
                }
            }

            Spacer()

            if let credits = course.credits {
                Text("\(credits) ECTS")
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(ModuleColors.studiesLight)
                    .clipShape(Capsule())
            }

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(Theme.textSecondary)
        }
        .brutalistCard()
    }

    private var notesContent: some View {
        LazyVStack(spacing: 12) {
            if viewModel.notes.isEmpty {
                EmptyStateView(
                    icon: "doc.text",
                    title: "Aucune note",
                    message: "Vos notes apparaîtront ici"
                )
            } else {
                ForEach(viewModel.notes) { note in
                    NavigationLink(value: AppDestination.noteDetail(note)) {
                        noteCard(note)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.horizontal)
    }

    private func noteCard(_ note: Note) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(note.title)
                    .font(.headline)
                    .foregroundColor(Theme.text)
                Spacer()
                Image(systemName: visibilityIcon(note.visibility))
                    .font(.caption)
                    .foregroundColor(Theme.textSecondary)
            }

            if let preview = note.plainTextContent?.prefix(100) {
                Text(preview)
                    .font(.caption)
                    .foregroundColor(Theme.textSecondary)
                    .lineLimit(2)
            }

            HStack {
                if let tags = note.tags, !tags.isEmpty {
                    ForEach(tags.prefix(3), id: \.self) { tag in
                        Text(tag)
                            .font(.caption2)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(ModuleColors.studiesLight)
                            .clipShape(Capsule())
                    }
                }
                Spacer()
                if let updated = note.updatedAt {
                    Text(updated, style: .date)
                        .font(.caption2)
                        .foregroundColor(Theme.textSecondary)
                }
            }
        }
        .brutalistCard()
    }

    private func visibilityIcon(_ visibility: NoteVisibility) -> String {
        switch visibility {
        case .private: "lock"
        case .courseShared: "person.2"
        case .public: "globe"
        }
    }
}
