import SwiftUI

struct IdentityStepView: View {
    @Bindable var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: 20) {
            // Full name
            VStack(alignment: .leading, spacing: 6) {
                Label("Nom complet", systemImage: "person.fill")
                    .font(.system(size: 13, weight: .bold))

                TextField("Ton nom et prénom", text: $viewModel.fullName)
                    .textContentType(.name)
                    .padding(14)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(hex: "#0a0a0a"), lineWidth: 2)
                    )
            }

            // University
            VStack(alignment: .leading, spacing: 6) {
                Label("Université", systemImage: "building.columns.fill")
                    .font(.system(size: 13, weight: .bold))

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(viewModel.universities, id: \.self) { uni in
                            Button {
                                HapticFeedback.tap()
                                viewModel.university = uni
                            } label: {
                                Text(uni)
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundStyle(viewModel.university == uni ? .white : Color(hex: "#0a0a0a"))
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 10)
                                    .background(viewModel.university == uni ? Color(hex: "#0a0a0a") : Color.white)
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

            // Field of study
            VStack(alignment: .leading, spacing: 6) {
                Label("Filière", systemImage: "graduationcap.fill")
                    .font(.system(size: 13, weight: .bold))

                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 8)], spacing: 8) {
                    ForEach(viewModel.fields, id: \.self) { field in
                        Button {
                            HapticFeedback.tap()
                            viewModel.fieldOfStudy = field
                        } label: {
                            Text(field)
                                .font(.system(size: 12, weight: .bold))
                                .foregroundStyle(viewModel.fieldOfStudy == field ? .white : Color(hex: "#0a0a0a"))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 10)
                                .frame(maxWidth: .infinity)
                                .background(viewModel.fieldOfStudy == field
                                            ? Color(hex: "#d8b4fe")
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
