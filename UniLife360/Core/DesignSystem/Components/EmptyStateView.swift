import SwiftUI

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    var buttonTitle: String? = nil
    var buttonColor: Color = ModuleColors.finance
    var action: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: icon)
                .font(.system(size: 48))
                .foregroundColor(Theme.textSecondary.opacity(0.5))
                .frame(width: 96, height: 96)
                .background(Color.gray.opacity(0.08))
                .clipShape(Circle())

            VStack(spacing: 8) {
                Text(title)
                    .font(.title3)
                    .fontWeight(.bold)

                Text(message)
                    .font(.subheadline)
                    .foregroundColor(Theme.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }

            if let buttonTitle, let action {
                BrutalistButton(
                    title: buttonTitle,
                    color: buttonColor,
                    fullWidth: false,
                    action: action
                )
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
}
