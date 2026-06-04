import SwiftUI

struct LevelBadge: View {
    let level: JLPTLevel

    var body: some View {
        Text(level.displayName)
            .font(AoiTheme.Typography.title(13, weight: .bold))
            .foregroundStyle(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(level.gradient)
            }
            .shadow(color: AoiTheme.Colors.primaryBlue.opacity(0.16), radius: 10, x: 0, y: 6)
    }
}
