import SwiftUI

struct FinanceStepView: View {
    @Bindable var viewModel: OnboardingViewModel

    private let budgetPresets = ["500", "700", "800", "1000", "1200", "1500"]

    var body: some View {
        VStack(spacing: 24) {
            // Budget illustration
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(hex: "#86efac").opacity(0.3))
                    .frame(height: 120)

                VStack(spacing: 8) {
                    Image(systemName: "banknote.fill")
                        .font(.system(size: 36))
                        .foregroundStyle(Color(hex: "#16a34a"))

                    Text("Configure ton budget mensuel")
                        .font(.system(size: 14, weight: .bold))
                }
            }

            // Budget amount
            VStack(alignment: .leading, spacing: 10) {
                Label("Budget mensuel", systemImage: "eurosign.circle.fill")
                    .font(.system(size: 13, weight: .bold))

                HStack(spacing: 0) {
                    TextField("800", text: $viewModel.monthlyBudget)
                        .keyboardType(.decimalPad)
                        .font(.system(size: 28, weight: .heavy))
                        .padding(16)

                    Text("€/mois")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.secondary)
                        .padding(.trailing, 16)
                }
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(hex: "#0a0a0a"), lineWidth: 2)
                )
                .shadow(color: .black, radius: 0, x: 3, y: 3)
            }

            // Quick presets
            VStack(alignment: .leading, spacing: 8) {
                Text("Suggestions rapides")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(.secondary)

                LazyVGrid(columns: [GridItem(.adaptive(minimum: 80), spacing: 8)], spacing: 8) {
                    ForEach(budgetPresets, id: \.self) { preset in
                        Button {
                            HapticFeedback.tap()
                            viewModel.monthlyBudget = preset
                        } label: {
                            Text("\(preset) €")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundStyle(viewModel.monthlyBudget == preset ? .white : Color(hex: "#0a0a0a"))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(viewModel.monthlyBudget == preset
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

            // Info card
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "lightbulb.fill")
                    .font(.system(size: 16))
                    .foregroundStyle(Color(hex: "#fdba74"))

                Text("Tu pourras modifier ton budget à tout moment dans les paramètres Finance.")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.secondary)
            }
            .padding(14)
            .background(Color(hex: "#fdba74").opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(hex: "#fdba74").opacity(0.3), lineWidth: 1)
            )
        }
    }
}
