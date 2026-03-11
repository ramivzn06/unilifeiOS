import SwiftUI

struct LoginView: View {
    @State private var viewModel = AuthViewModel()
    @State private var showRegister = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 32) {
                    // MARK: - Logo & Branding
                    VStack(spacing: 12) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
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
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color(hex: "#0a0a0a"), lineWidth: 2)
                                )
                                .shadow(color: .black, radius: 0, x: 4, y: 4)

                            Text("U")
                                .font(.system(size: 36, weight: .black, design: .rounded))
                                .foregroundStyle(Color(hex: "#0a0a0a"))
                        }

                        Text("UniLife 360")
                            .font(.system(size: 28, weight: .heavy, design: .rounded))

                        Text("Ton OS de Vie Étudiant")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 40)

                    // MARK: - Login Form
                    VStack(spacing: 16) {
                        Text("Connexion")
                            .font(.system(size: 22, weight: .heavy))
                            .frame(maxWidth: .infinity, alignment: .leading)

                        // Email field
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

                        // Password field
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Mot de passe")
                                .font(.system(size: 13, weight: .bold))

                            SecureField("••••••••", text: $viewModel.password)
                                .textContentType(.password)
                                .padding(14)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color(hex: "#0a0a0a"), lineWidth: 2)
                                )
                        }

                        // Sign in button
                        Button {
                            HapticFeedback.tap()
                            Task { await viewModel.signIn() }
                        } label: {
                            HStack(spacing: 8) {
                                if viewModel.isLoading {
                                    ProgressView()
                                        .tint(.white)
                                } else {
                                    Text("Se connecter")
                                        .font(.system(size: 16, weight: .heavy))
                                    Image(systemName: "arrow.right")
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

                    // MARK: - Divider
                    HStack {
                        Rectangle()
                            .fill(Color(hex: "#0a0a0a").opacity(0.2))
                            .frame(height: 1)
                        Text("ou")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(.secondary)
                        Rectangle()
                            .fill(Color(hex: "#0a0a0a").opacity(0.2))
                            .frame(height: 1)
                    }

                    // MARK: - Social Sign-In Buttons
                    VStack(spacing: 12) {
                        // Apple Sign-In
                        Button {
                            HapticFeedback.tap()
                            viewModel.startAppleSignIn()
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "apple.logo")
                                    .font(.system(size: 18))
                                Text("Continuer avec Apple")
                                    .font(.system(size: 15, weight: .bold))
                            }
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color(hex: "#0a0a0a"))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(hex: "#0a0a0a"), lineWidth: 2)
                            )
                            .shadow(color: .black.opacity(0.3), radius: 0, x: 3, y: 3)
                        }
                        .disabled(viewModel.isLoading)

                        // Google Sign-In
                        Button {
                            HapticFeedback.tap()
                            Task { await viewModel.startGoogleSignIn() }
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "globe")
                                    .font(.system(size: 16, weight: .semibold))
                                Text("Continuer avec Google")
                                    .font(.system(size: 15, weight: .bold))
                            }
                            .foregroundStyle(Color(hex: "#0a0a0a"))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(hex: "#0a0a0a"), lineWidth: 2)
                            )
                            .shadow(color: .black.opacity(0.3), radius: 0, x: 3, y: 3)
                        }
                        .disabled(viewModel.isLoading)
                    }

                    // MARK: - Register Link
                    HStack(spacing: 4) {
                        Text("Pas encore de compte ?")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(.secondary)

                        Button("S'inscrire") {
                            HapticFeedback.tap()
                            showRegister = true
                        }
                        .font(.system(size: 14, weight: .heavy))
                        .foregroundStyle(Color(hex: "#0a0a0a"))
                    }
                    .padding(.bottom, 20)
                }
                .padding(.horizontal, 24)
            }
            .background(Color(hex: "#fefce8"))
            .navigationDestination(isPresented: $showRegister) {
                RegisterView()
            }
            .alert("Erreur", isPresented: $viewModel.showError) {
                Button("OK") {}
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
    }
}

#Preview {
    LoginView()
}
