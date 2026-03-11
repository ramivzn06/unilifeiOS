import SwiftUI

struct NewEventView: View {
    @Environment(\.dismiss) private var dismiss
    var selectedDate: Date = Date()
    var onSave: (() -> Void)? = nil

    @State private var title = ""
    @State private var description = ""
    @State private var location = ""
    @State private var startTime = Date()
    @State private var endTime = Date()
    @State private var eventType: EventType = .etudes
    @State private var isAllDay = false
    @State private var isSaving = false
    @State private var errorMessage: String?

    private let repository = CalendarRepository()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Title
                    BrutalistInput(placeholder: "Titre de l'événement", text: $title, icon: "pencil")

                    // Type selector
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Type")
                            .font(.subheadline)
                            .fontWeight(.semibold)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(EventType.allCases, id: \.self) { type in
                                    Button(action: {
                                        eventType = type
                                        HapticFeedback.selection()
                                    }) {
                                        Text(type.label)
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 10)
                                            .background(eventType == type ? type.color : Color.white)
                                            .brutalistBorder()
                                            .shadow(color: .black.opacity(eventType == type ? 0.85 : 0.3), radius: 0, x: eventType == type ? 3 : 1, y: eventType == type ? 3 : 1)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }

                    // All day toggle
                    Toggle(isOn: $isAllDay) {
                        Text("Toute la journée")
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    .padding()
                    .background(Color.white)
                    .brutalistBorder()
                    .shadow(color: .black.opacity(0.3), radius: 0, x: 2, y: 2)

                    // Date/Time pickers
                    if !isAllDay {
                        VStack(spacing: 12) {
                            DatePicker("Début", selection: $startTime, displayedComponents: [.date, .hourAndMinute])
                                .environment(\.locale, Locale(identifier: "fr_FR"))
                            DatePicker("Fin", selection: $endTime, displayedComponents: [.date, .hourAndMinute])
                                .environment(\.locale, Locale(identifier: "fr_FR"))
                        }
                        .padding()
                        .background(Color.white)
                        .brutalistBorder()
                        .shadow(color: .black.opacity(0.3), radius: 0, x: 2, y: 2)
                    } else {
                        DatePicker("Date", selection: $startTime, displayedComponents: .date)
                            .environment(\.locale, Locale(identifier: "fr_FR"))
                            .padding()
                            .background(Color.white)
                            .brutalistBorder()
                            .shadow(color: .black.opacity(0.3), radius: 0, x: 2, y: 2)
                    }

                    // Location
                    BrutalistInput(placeholder: "Lieu (optionnel)", text: $location, icon: "mappin")

                    // Description
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description")
                            .font(.subheadline)
                            .fontWeight(.semibold)

                        TextEditor(text: $description)
                            .frame(minHeight: 80)
                            .padding(8)
                            .background(Color.white)
                            .brutalistBorder()
                            .shadow(color: .black.opacity(0.3), radius: 0, x: 2, y: 2)
                    }

                    if let errorMessage {
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundColor(.red)
                    }

                    // Save button
                    BrutalistButton(
                        title: "Créer l'événement",
                        icon: "checkmark",
                        color: ModuleColors.schedule,
                        isLoading: isSaving,
                        action: saveEvent
                    )
                }
                .padding()
            }
            .background(Theme.background.ignoresSafeArea())
            .navigationTitle("Nouvel événement")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Annuler") { dismiss() }
                }
            }
        }
        .onAppear {
            let calendar = Calendar.current
            startTime = calendar.date(bySettingHour: 9, minute: 0, second: 0, of: selectedDate) ?? selectedDate
            endTime = calendar.date(bySettingHour: 10, minute: 0, second: 0, of: selectedDate) ?? selectedDate
        }
    }

    private func saveEvent() {
        guard !title.isEmpty else {
            errorMessage = "Le titre est requis"
            return
        }

        isSaving = true
        Task {
            guard let userId = await SupabaseManager.shared.currentUserId else { return }

            let event = CalendarEvent(
                id: UUID(),
                userId: userId,
                title: title,
                description: description.isEmpty ? nil : description,
                startTime: startTime,
                endTime: isAllDay ? Calendar.current.date(byAdding: .day, value: 1, to: startTime)! : endTime,
                location: location.isEmpty ? nil : location,
                type: eventType,
                color: nil,
                isAllDay: isAllDay,
                recurrenceRule: nil,
                createdAt: Date()
            )

            do {
                try await repository.addEvent(event)
                HapticFeedback.success()
                onSave?()
                dismiss()
            } catch {
                errorMessage = error.localizedDescription
                HapticFeedback.error()
            }
            isSaving = false
        }
    }
}
