import SwiftUI

struct NewWorkoutView: View {
    @Environment(\.dismiss) private var dismiss
    var onSave: (() -> Void)? = nil

    @State private var name = ""
    @State private var type = "Musculation"
    @State private var duration = 30
    @State private var calories = ""
    @State private var notes = ""
    @State private var isSaving = false

    private let types = ["Musculation", "Course", "Natation", "Vélo", "Yoga", "HIIT", "Football", "Basketball", "Autre"]
    private let repository = SportRepository()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    BrutalistInput(placeholder: "Nom de l'entraînement", text: $name, icon: "pencil")

                    // Type
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Type")
                            .font(.subheadline)
                            .fontWeight(.semibold)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(types, id: \.self) { t in
                                    Button(action: {
                                        type = t
                                        HapticFeedback.selection()
                                    }) {
                                        Text(t)
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .padding(.horizontal, 14)
                                            .padding(.vertical, 8)
                                            .background(type == t ? ModuleColors.sport : Color.white)
                                            .brutalistBorder()
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }

                    // Duration
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Durée : \(duration) min")
                            .font(.subheadline)
                            .fontWeight(.semibold)

                        Slider(value: Binding(
                            get: { Double(duration) },
                            set: { duration = Int($0) }
                        ), in: 5...180, step: 5)
                        .tint(ModuleColors.sport)
                    }
                    .padding()
                    .background(Color.white)
                    .brutalistBorder()
                    .shadow(color: .black.opacity(0.3), radius: 0, x: 2, y: 2)

                    // Calories
                    BrutalistInput(placeholder: "Calories brûlées (optionnel)", text: $calories, icon: "flame.fill", keyboardType: .numberPad)

                    // Notes
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notes")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        TextEditor(text: $notes)
                            .frame(minHeight: 60)
                            .padding(8)
                            .background(Color.white)
                            .brutalistBorder()
                    }

                    BrutalistButton(
                        title: "Enregistrer",
                        icon: "checkmark",
                        color: ModuleColors.sport,
                        isLoading: isSaving,
                        action: save
                    )
                }
                .padding()
            }
            .background(Theme.background.ignoresSafeArea())
            .navigationTitle("Nouvel entraînement")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Annuler") { dismiss() }
                }
            }
        }
    }

    private func save() {
        guard !name.isEmpty else { return }
        isSaving = true

        Task {
            guard let userId = await SupabaseManager.shared.currentUserId else { return }

            let workout = SportWorkout(
                id: UUID(),
                userId: userId,
                name: name,
                type: type,
                duration: duration,
                caloriesBurned: Int(calories),
                notes: notes.isEmpty ? nil : notes,
                date: Date(),
                exercises: nil,
                createdAt: Date()
            )

            do {
                try await repository.addWorkout(workout)
                HapticFeedback.success()
                onSave?()
                dismiss()
            } catch {
                HapticFeedback.error()
            }
            isSaving = false
        }
    }
}
