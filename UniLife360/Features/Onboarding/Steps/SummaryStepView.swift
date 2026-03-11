import SwiftUI

struct SummaryStepView: View {
    @Bindable var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: 20) {
            // Success illustration
            VStack(spacing: 12) {
                ZStack {
                    SwiftUI.Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(hex: "#86efac"),
                                    Color(hex: "#d8b4fe"),
                                    Color(hex: "#f9a8d4")
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 80, height: 80)
                        .overlay(
                            SwiftUI.Circle()
                                .stroke(Color(hex: "#0a0a0a"), lineWidth: 2)
                        )
                        .shadow(color: .black, radius: 0, x: 3, y: 3)

                    Image(systemName: "checkmark")
                        .font(.system(size: 32, weight: .heavy))
                        .foregroundStyle(Color(hex: "#0a0a0a"))
                }

                Text("Tout est prêt ! 🎉")
                    .font(.system(size: 22, weight: .heavy))

                Text("Voici un récapitulatif de ton profil")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.secondary)
            }

            // Summary cards
            VStack(spacing: 12) {
                summaryRow(icon: "person.fill", label: "Nom", value: viewModel.fullName, color: "#f9a8d4")
                summaryRow(icon: "building.columns.fill", label: "Université", value: viewModel.university, color: "#d8b4fe")
                summaryRow(icon: "graduationcap.fill", label: "Filière", value: viewModel.fieldOfStudy, color: "#d8b4fe")
                summaryRow(icon: "calendar", label: "Année", value: yearLabel, color: "#fdba74")
                summaryRow(icon: "banknote.fill", label: "Budget", value: "\(viewModel.monthlyBudget) €/mois", color: "#86efac")

                if !viewModel.favoriteSubjects.isEmpty {
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 14))
                            .frame(width: 36, height: 36)
                            .background(Color(hex: "#fdba74").opacity(0.3))
                            .clipShape(RoundedRectangle(cornerRadius: 8))

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Matières préférées")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundStyle(.secondary)

                            Text(viewModel.favoriteSubjects.joined(separator: ", "))
                                .font(.system(size: 14, weight: .bold))
                        }

                        Spacer()
                    }
                    .padding(12)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(hex: "#0a0a0a"), lineWidth: 2)
                    )
                }
            }
        }
    }

    private var yearLabel: String {
        if viewModel.yearOfStudy <= 3 {
            return "Bachelier \(viewModel.yearOfStudy)"
        } else {
            return "Master \(viewModel.yearOfStudy - 3)"
        }
    }

    private func summaryRow(icon: String, label: String, value: String, color: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .frame(width: 36, height: 36)
                .background(Color(hex: color).opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.system(size: 14, weight: .bold))
            }

            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(Color(hex: "#16a34a"))
        }
        .padding(12)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(hex: "#0a0a0a"), lineWidth: 2)
        )
    }
}
