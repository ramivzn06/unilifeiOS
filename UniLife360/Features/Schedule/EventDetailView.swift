import SwiftUI

struct EventDetailView: View {
    let event: CalendarEvent

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(event.type.label)
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(event.type.color)
                            .clipShape(Capsule())

                        Text(event.title)
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    Spacer()
                }
                .brutalistCard(backgroundColor: event.type.color.opacity(0.15))

                // Date & Time
                VStack(alignment: .leading, spacing: 12) {
                    Label {
                        Text(dateString(event.startTime))
                            .font(.subheadline)
                    } icon: {
                        Image(systemName: "calendar")
                            .foregroundColor(ModuleColors.schedule)
                    }

                    Label {
                        Text("\(timeString(event.startTime)) - \(timeString(event.endTime))")
                            .font(.subheadline)
                    } icon: {
                        Image(systemName: "clock")
                            .foregroundColor(ModuleColors.schedule)
                    }

                    if let location = event.location {
                        Label {
                            Text(location)
                                .font(.subheadline)
                        } icon: {
                            Image(systemName: "mappin.and.ellipse")
                                .foregroundColor(ModuleColors.schedule)
                        }
                    }
                }
                .brutalistCard()

                // Description
                if let description = event.description, !description.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description")
                            .font(.headline)
                        Text(description)
                            .font(.body)
                            .foregroundColor(Theme.textSecondary)
                    }
                    .brutalistCard()
                }
            }
            .padding()
        }
        .background(Theme.background.ignoresSafeArea())
        .navigationTitle("Détails")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func dateString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }

    private func timeString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}
