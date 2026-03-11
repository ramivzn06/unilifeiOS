import SwiftUI

struct OnboardingView: View {
    @State private var viewModel = OnboardingViewModel()

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Progress Bar
            HStack(spacing: 6) {
                ForEach(0..<viewModel.totalSteps, id: \.self) { step in
                    Capsule()
                        .fill(step <= viewModel.currentStep
                              ? Color(hex: "#0a0a0a")
                              : Color(hex: "#0a0a0a").opacity(0.15))
                        .frame(height: 4)
                        .animation(.easeInOut(duration: 0.3), value: viewModel.currentStep)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)

            // MARK: - Step Header
            VStack(spacing: 6) {
                Text("Étape \(viewModel.currentStep + 1)/\(viewModel.totalSteps)")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)
                    .tracking(1.5)

                Text(viewModel.stepTitle)
                    .font(.system(size: 28, weight: .heavy, design: .rounded))

                Text(viewModel.stepSubtitle)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.secondary)
            }
            .padding(.top, 24)

            // MARK: - Step Content
            ScrollView {
                Group {
                    switch viewModel.currentStep {
                    case 0:
                        IdentityStepView(viewModel: viewModel)
                    case 1:
                        StudiesStepView(viewModel: viewModel)
                    case 2:
                        FinanceStepView(viewModel: viewModel)
                    case 3:
                        SummaryStepView(viewModel: viewModel)
                    default:
                        EmptyView()
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal: .move(edge: .leading).combined(with: .opacity)
                ))
                .id(viewModel.currentStep)
            }

            // MARK: - Navigation Buttons
            HStack(spacing: 12) {
                if viewModel.currentStep > 0 {
                    Button {
                        viewModel.previousStep()
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(Color(hex: "#0a0a0a"))
                            .frame(width: 52, height: 52)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(hex: "#0a0a0a"), lineWidth: 2)
                            )
                            .shadow(color: .black, radius: 0, x: 2, y: 2)
                    }
                }

                Button {
                    if viewModel.currentStep == viewModel.totalSteps - 1 {
                        Task { await viewModel.completeOnboarding() }
                    } else {
                        viewModel.nextStep()
                    }
                } label: {
                    HStack(spacing: 8) {
                        if viewModel.isLoading {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text(viewModel.currentStep == viewModel.totalSteps - 1
                                 ? "Commencer"
                                 : "Continuer")
                                .font(.system(size: 16, weight: .heavy))
                            Image(systemName: viewModel.currentStep == viewModel.totalSteps - 1
                                  ? "sparkles"
                                  : "arrow.right")
                                .font(.system(size: 14, weight: .bold))
                        }
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(viewModel.canProceed
                                ? Color(hex: "#0a0a0a")
                                : Color(hex: "#0a0a0a").opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: .black.opacity(0.3), radius: 0, x: 3, y: 3)
                }
                .disabled(!viewModel.canProceed || viewModel.isLoading)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            .background(
                Color(hex: "#fefce8")
                    .shadow(color: .black.opacity(0.05), radius: 10, y: -5)
            )
        }
        .background(Color(hex: "#fefce8"))
    }
}

#Preview {
    OnboardingView()
}
