import SwiftUI

struct SocialEventDetailView: View {
    let event: SocialEvent

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Header image placeholder
                ZStack {
                    RoundedRectangle(cornerRadius: Theme.cornerRadius)
                        .fill(
                            LinearGradient(
                                colors: [ModuleColors.social, ModuleColors.socialLight],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(height: 200)

                    VStack {
                        Image(systemName: "party.popper.fill")
                            .font(.system(size: 48))
                            .foregroundColor(.white)
                        Text(event.title)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                    }
                }
                .brutalistBorder()
                .shadow(color: .black.opacity(0.85), radius: 0, x: 4, y: 4)

                // Info cards
                VStack(spacing: 12) {
                    infoRow(icon: "calendar", label: "Date", value: dateString(event.startDate))
                    if let location = event.location {
                        infoRow(icon: "mappin.and.ellipse", label: "Lieu", value: location)
                    }
                    infoRow(icon: "person.2", label: "Participants", value: "\(event.currentParticipants)\(event.maxParticipants.map { "/\($0)" } ?? "")")
                    if let price = event.price {
                        infoRow(icon: "banknote", label: "Prix", value: price > 0 ? String(format: "%.2f€", price) : "Gratuit")
                    }
                }
                .brutalistCard()

                // Description
                if let description = event.description {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description")
                            .font(.headline)
                        Text(description)
                            .font(.body)
                            .foregroundColor(Theme.textSecondary)
                    }
                    .brutalistCard()
                }

                // Reserve button
                BrutalistButton(
                    title: "Réserver une place",
                    icon: "ticket",
                    color: ModuleColors.social,
                    action: {}
                )
            }
            .padding()
        }
        .background(Theme.background.ignoresSafeArea())
        .navigationTitle("Événement")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func infoRow(icon: String, label: String, value: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(ModuleColors.social)
                .frame(width: 24)
            Text(label)
                .font(.subheadline)
                .foregroundColor(Theme.textSecondary)
            Spacer()
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
        }
    }

    private func dateString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
