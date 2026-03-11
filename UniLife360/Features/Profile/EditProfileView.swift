import SwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var fullName = ""
    @State private var bio = ""
    @State private var university = ""
    @State private var fieldOfStudy = ""
    @State private var studyYear = ""
    @State private var isSaving = false
    @State private var user: AppUser?
    private let repository = UserRepository()

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                BrutalistInput(placeholder: "Nom complet", text: $fullName, icon: "person")
                BrutalistInput(placeholder: "Université", text: $university, icon: "building.columns")
                BrutalistInput(placeholder: "Filière", text: $fieldOfStudy, icon: "graduationcap")
                BrutalistInput(placeholder: "Année d'étude", text: $studyYear, icon: "calendar")

                VStack(alignment: .leading, spacing: 8) {
                    Text("Bio")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    TextEditor(text: $bio)
                        .frame(minHeight: 80)
                        .padding(8)
                        .background(Color.white)
                        .brutalistBorder()
                        .shadow(color: .black.opacity(0.3), radius: 0, x: 2, y: 2)
                }

                BrutalistButton(
                    title: "Enregistrer",
                    icon: "checkmark",
                    color: ModuleColors.studies,
                    isLoading: isSaving,
                    action: save
                )
            }
            .padding()
        }
        .background(Theme.background.ignoresSafeArea())
        .navigationTitle("Modifier le profil")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            guard let userId = await SupabaseManager.shared.currentUserId else { return }
            if let u = try? await repository.getUser(id: userId) {
                user = u
                fullName = u.fullName ?? ""
                bio = u.bio ?? ""
                university = u.university ?? ""
                fieldOfStudy = u.fieldOfStudy ?? ""
                studyYear = u.studyYear ?? ""
            }
        }
    }

    private func save() {
        guard var user else { return }
        isSaving = true

        user.fullName = fullName.isEmpty ? nil : fullName
        user.bio = bio.isEmpty ? nil : bio
        user.university = university.isEmpty ? nil : university
        user.fieldOfStudy = fieldOfStudy.isEmpty ? nil : fieldOfStudy
        user.studyYear = studyYear.isEmpty ? nil : studyYear
        user.updatedAt = Date()

        Task {
            do {
                try await repository.updateUser(user)
                HapticFeedback.success()
                dismiss()
            } catch {
                HapticFeedback.error()
            }
            isSaving = false
        }
    }
}
