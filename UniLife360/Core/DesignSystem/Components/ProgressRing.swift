import SwiftUI

struct ProgressRing: View {
    var progress: Double // 0.0 to 1.0
    var lineWidth: CGFloat = 12
    var size: CGFloat = 120
    var backgroundColor: Color = Color.gray.opacity(0.15)
    var foregroundColor: Color = ModuleColors.finance
    var showLabel: Bool = true

    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(backgroundColor, lineWidth: lineWidth)

            // Progress arc
            Circle()
                .trim(from: 0, to: min(progress, 1.0))
                .stroke(
                    foregroundColor,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.spring(response: 0.8, dampingFraction: 0.7), value: progress)

            // Label
            if showLabel {
                Text("\(Int(progress * 100))%")
                    .font(.system(size: size * 0.22, weight: .bold, design: .rounded))
                    .foregroundColor(Theme.text)
            }
        }
        .frame(width: size, height: size)
    }
}
