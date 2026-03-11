import SwiftUI

struct BrutalistButton: View {
    let title: String
    var icon: String? = nil
    var color: Color = ModuleColors.finance
    var textColor: Color = .black
    var fullWidth: Bool = true
    var isLoading: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .tint(textColor)
                } else {
                    if let icon {
                        Image(systemName: icon)
                    }
                    Text(title)
                }
            }
        }
        .buttonStyle(BrutalistButtonStyle(color: color, textColor: textColor, fullWidth: fullWidth))
        .disabled(isLoading)
    }
}
