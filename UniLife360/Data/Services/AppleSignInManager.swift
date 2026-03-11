import AuthenticationServices
import CryptoKit
import Foundation

/// Manages the Apple Sign-In flow: nonce generation and ASAuthorization
final class AppleSignInManager: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {

    private var currentNonce: String?
    private var completion: ((Result<(idToken: String, nonce: String, fullName: String?), Error>) -> Void)?

    // MARK: - Public API

    func signIn(completion: @escaping (Result<(idToken: String, nonce: String, fullName: String?), Error>) -> Void) {
        self.completion = completion

        let nonce = randomNonceString()
        currentNonce = nonce

        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }

    // MARK: - ASAuthorizationControllerDelegate

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let tokenData = credential.identityToken,
              let idToken = String(data: tokenData, encoding: .utf8),
              let nonce = currentNonce else {
            completion?(.failure(AppleSignInError.missingToken))
            return
        }

        var fullName: String?
        if let givenName = credential.fullName?.givenName,
           let familyName = credential.fullName?.familyName {
            fullName = "\(givenName) \(familyName)"
        }

        completion?(.success((idToken: idToken, nonce: nonce, fullName: fullName)))
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // User cancelled — not a real error
        if (error as? ASAuthorizationError)?.code == .canceled {
            return
        }
        completion?(.failure(error))
    }

    // MARK: - Presentation

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first else {
            return ASPresentationAnchor()
        }
        return window
    }

    // MARK: - Nonce Helpers

    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce: \(errorCode)")
        }
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        return String(randomBytes.map { charset[Int($0) % charset.count] })
    }

    private func sha256(_ input: String) -> String {
        let data = Data(input.utf8)
        let hash = SHA256.hash(data: data)
        return hash.compactMap { String(format: "%02x", $0) }.joined()
    }
}

enum AppleSignInError: LocalizedError {
    case missingToken

    var errorDescription: String? {
        switch self {
        case .missingToken:
            return "Impossible de récupérer le token Apple"
        }
    }
}
