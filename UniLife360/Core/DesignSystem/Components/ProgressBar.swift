import SwiftUI

struct BrutalistProgressBar: View {
    var progress: Double // 0.0 to 1.0
    var height: CGFloat = 12
    var backgroundColor: Color = Color.gray.opacity(0.15)
    var foregroundColor: Color = ModuleColors.finance
    var showBorder: Bool = true

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(backgroundColor)

                // Progress
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(foregroundColor)
                    .frame(width: geometry.size.width * min(progress, 1.0))
                    .animation(.spring(response: 0.6, dampingFraction: 0.8), value: progress)
            }
            .overlay {
                if showBorder {
                    RoundedRectangle(cornerRadius: height / 2)
                        .stroke(Theme.border, lineWidth: 1.5)
                }
            }
        }
        .frame(height: height)
    }
}
