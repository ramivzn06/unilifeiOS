import SwiftUI

struct StudiesStepView: View {
    @Bindable var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: 24) {
            // Year of study
            VStack(alignment: .leading, spacing: 10) {
                Label("Année d'études", systemImage: "calendar.badge.clock")
                    .font(.system(size: 13, weight: .bold))

                HStack(spacing: 10) {
                    ForEach(1...5, id: \.self) { year in
                        Button {
                            HapticFeedback.tap()
                            viewModel.yearOfStudy = year
                        } label: {
                            VStack(spacing: 4) {
                                Text("\(year)")
                                    .font(.system(size: 22, weight: .heavy))
                                Text(year <= 3 ? "Bac \(year)" : "Ma \(year - 3)")
                                    .font(.system(size: 10, weight: .bold))
                            }
                            .foregroundStyle(viewModel.yearOfStudy == year ? .white : Color(hex: "#0a0a0a"))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(viewModel.yearOfStudy == year
                                        ? Color(hex: "#d8b4fe")
                                        : Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(hex: "#0a0a0a"), lineWidth: 2)
                            )
                            .shadow(color: viewModel.yearOfStudy == year ? .black : .clear,
                                    radius: 0, x: 2, y: 2)
                        }
                    }
                }
            }

            // Favorite subjects
            VStack(alignment: .leading, spacing: 10) {
                Label("Matières préférées", systemImage: "star.fill")
                    .font(.system(size: 13, weight: .bold))

                Text("Sélectionne tes matières favorites (optionnel)")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.secondary)

                LazyVGrid(columns: [GridItem(.adaptive(minimum: 110), spacing: 8)], spacing: 8) {
                    ForEach(viewModel.subjects, id: \.self) { subject in
                        let isSelected = viewModel.favoriteSubjects.contains(subject)

                        Button {
                            viewModel.toggleSubject(subject)
                        } label: {
                            Text(subject)
                                .font(.system(size: 12, weight: .bold))
                                .foregroundStyle(isSelected ? .white : Color(hex: "#0a0a0a"))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 10)
                                .frame(maxWidth: .infinity)
                                .background(isSelected
                                            ? Color(hex: "#86efac")
                                            : Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color(hex: "#0a0a0a"), lineWidth: 2)
                                )
                        }
                    }
                }
            }
        }
    }
}
