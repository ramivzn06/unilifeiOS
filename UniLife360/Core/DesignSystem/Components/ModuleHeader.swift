import SwiftUI

struct ModuleHeader: View {
    let title: String
    var subtitle: String? = nil
    var icon: String
    var color: Color
    var showBack: Bool = false
    var onBack: (() -> Void)? = nil

    var body: some View {
        HStack(spacing: 12) {
            if showBack {
                Button(action: { onBack?() }) {
                    Image(systemName: "chevron.left")
                        .font(.title3.bold())
                        .foregroundColor(Theme.text)
                        .frame(width: 36, height: 36)
                        .background(Color.white)
                        .brutalistBorder(cornerRadius: 10)
                        .shadow(color: .black.opacity(0.85), radius: 0, x: 2, y: 2)
                }
            }

            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.black)
                .frame(width: 44, height: 44)
                .background(color)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Theme.border, lineWidth: 2)
                )
                .shadow(color: .black.opacity(0.85), radius: 0, x: 3, y: 3)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)

                if let subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(Theme.textSecondary)
                }
            }

            Spacer()
        }
        .padding(.horizontal)
    }
}
