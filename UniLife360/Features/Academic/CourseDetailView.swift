import SwiftUI

struct CourseDetailView: View {
    let course: Course
    @State private var notes: [Note] = []
    @State private var exams: [Exam] = []
    @State private var selectedTab = 0
    private let repository = AcademicRepository()

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Course header
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        if let code = course.code {
                            Text(code)
                                .font(.caption)
                                .fontWeight(.bold)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color(hex: course.color ?? "#d8b4fe"))
                                .clipShape(Capsule())
                        }
                        Spacer()
                        if let credits = course.credits {
                            Text("\(credits) ECTS")
                                .font(.subheadline)
                                .fontWeight(.bold)
                        }
                    }

                    Text(course.name)
                        .font(.title2)
                        .fontWeight(.bold)

                    if let professor = course.professor {
                        Label(professor, systemImage: "person.fill")
                            .font(.subheadline)
                            .foregroundColor(Theme.textSecondary)
                    }

                    if let location = course.location {
                        Label(location, systemImage: "mappin")
                            .font(.subheadline)
                            .foregroundColor(Theme.textSecondary)
                    }
                }
                .brutalistCard(backgroundColor: Color(hex: course.color ?? "#d8b4fe").opacity(0.15))

                // Tabs
                HStack(spacing: 0) {
                    ForEach(["Notes", "Examens"], id: \.self) { tab in
                        let index = tab == "Notes" ? 0 : 1
                        Button(action: {
                            withAnimation { selectedTab = index }
                        }) {
                            Text(tab)
                                .font(.subheadline)
                                .fontWeight(selectedTab == index ? .bold : .medium)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(selectedTab == index ? ModuleColors.studies.opacity(0.3) : Color.clear)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .background(Color.white)
                .brutalistBorder()
                .shadow(color: .black.opacity(0.3), radius: 0, x: 2, y: 2)

                // Content
                if selectedTab == 0 {
                    if notes.isEmpty {
                        EmptyStateView(icon: "doc.text", title: "Aucune note", message: "Pas de notes pour ce cours")
                    } else {
                        ForEach(notes) { note in
                            NavigationLink(value: AppDestination.noteDetail(note)) {
                                noteRow(note)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                } else {
                    if exams.isEmpty {
                        EmptyStateView(icon: "checkmark.circle", title: "Aucun examen", message: "Pas d'examens pour ce cours")
                    } else {
                        ForEach(exams) { exam in
                            examRow(exam)
                        }
                    }
                }
            }
            .padding()
        }
        .background(Theme.background.ignoresSafeArea())
        .navigationTitle(course.name)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            guard let userId = await SupabaseManager.shared.currentUserId else { return }
            notes = (try? await repository.getNotes(userId: userId, courseId: course.id)) ?? []
            exams = (try? await repository.getExams(userId: userId, courseId: course.id)) ?? []
        }
    }

    private func noteRow(_ note: Note) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(note.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.text)
                if let updated = note.updatedAt {
                    Text(updated, style: .date)
                        .font(.caption2)
                        .foregroundColor(Theme.textSecondary)
                }
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(Theme.textSecondary)
        }
        .brutalistCard()
    }

    private func examRow(_ exam: Exam) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(exam.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Spacer()
                if exam.generatedByAI {
                    Label("IA", systemImage: "sparkles")
                        .font(.caption2)
                        .foregroundColor(ModuleColors.studies)
                }
            }
            if let questions = exam.questions {
                Text("\(questions.count) questions")
                    .font(.caption)
                    .foregroundColor(Theme.textSecondary)
            }
        }
        .brutalistCard()
    }
}
