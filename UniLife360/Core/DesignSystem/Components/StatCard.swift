import SwiftUI

struct StatCard: View {
    let title: String
    let value: String
    var icon: String? = nil
    var color: Color = ModuleColors.finance
    var trend: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                if let icon {
                    Image(systemName: icon)
                        .font(.caption)
                        .foregroundColor(.black)
                        .frame(width: 28, height: 28)
                        .background(color.opacity(0.3))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                Spacer()
                if let trend {
                    Text(trend)
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundColor(trend.hasPrefix("+") ? .green : .red)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(
                            (trend.hasPrefix("+") ? Color.green : Color.red).opacity(0.1)
                        )
                        .clipShape(Capsule())
                }
            }

            Text(value)
                .font(.title2)
                .fontWeight(.bold)

            Text(title)
                .font(.caption)
                .foregroundColor(Theme.textSecondary)
        }
        .brutalistCard(backgroundColor: color.opacity(0.1))
    }
}
