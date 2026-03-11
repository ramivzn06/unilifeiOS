import SwiftUI

struct RegisterView: View {
    @State private var viewModel = AuthViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // MARK: - Header
                VStack(spacing: 8) {
                    Text("Créer un compte")
                        .font(.system(size: 28, weight: .heavy, design: .rounded))

                    Text("Rejoins la communauté UniLife 360")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 20)

                // MARK: - Form
                VStack(spacing: 16) {
                    // Full name
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Nom complet")
                            .font(.system(size: 13, weight: .bold))

                        TextField("Ton nom complet", text: $viewModel.fullName)
                            .textContentType(.name)
                            .padding(14)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(hex: "#0a0a0a"), lineWidth: 2)
                            )
                    }

                    // Email
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Email")
                            .font(.system(size: 13, weight: .bold))

                        TextField("ton.email@universite.be", text: $viewModel.email)
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .padding(14)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(hex: "#0a0a0a"), lineWidth: 2)
                            )
                    }

                    // Password
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Mot de passe")
                            .font(.system(size: 13, weight: .bold))

                        SecureField("Minimum 6 caractères", text: $viewModel.password)
                            .textContentType(.newPassword)
                            .padding(14)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(hex: "#0a0a0a"), lineWidth: 2)
                            )
                    }

                    // Confirm password
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Confirmer le mot de passe")
                            .font(.system(size: 13, weight: .bold))

                        SecureField("Retape le mot de passe", text: $viewModel.confirmPassword)
                            .textContentType(.newPassword)
                            .padding(14)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(hex: "#0a0a0a"), lineWidth: 2)
                            )
                    }

                    // Sign up button
                    Button {
                        HapticFeedback.tap()
                        Task { await viewModel.signUp() }
                    } label: {
                        HStack(spacing: 8) {
                            if viewModel.isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text("S'inscrire")
                                    .font(.system(size: 16, weight: .heavy))
                                Image(systemName: "sparkles")
                                    .font(.system(size: 14, weight: .bold))
                            }
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color(hex: "#0a0a0a"))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(color: .black.opacity(0.3), radius: 0, x: 3, y: 3)
                    }
                    .disabled(viewModel.isLoading)
                }
                .padding(24)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(hex: "#0a0a0a"), lineWidth: 2)
                )
                .shadow(color: .black, radius: 0, x: 4, y: 4)

                // MARK: - Back to login
                HStack(spacing: 4) {
                    Text("Déjà un compte ?")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.secondary)

                    Button("Se connecter") {
                        HapticFeedback.tap()
                        dismiss()
                    }
                    .font(.system(size: 14, weight: .heavy))
                    .foregroundStyle(Color(hex: "#0a0a0a"))
                }
                .padding(.bottom, 20)
            }
            .padding(.horizontal, 24)
        }
        .background(Color(hex: "#fefce8"))
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(Color(hex: "#0a0a0a"))
                        .frame(width: 40, height: 40)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(hex: "#0a0a0a"), lineWidth: 2)
                        )
                        .shadow(color: .black, radius: 0, x: 2, y: 2)
                }
            }
        }
        .alert("Erreur", isPresented: $viewModel.showError) {
            Button("OK") {}
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
}

#Preview {
    NavigationStack {
        RegisterView()
    }
}
