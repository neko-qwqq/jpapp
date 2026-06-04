import SwiftUI

struct MetricPill: View {
    let icon: String
    let title: String
    let value: String
    let tint: Color

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 32, height: 32)
                .background(tint.gradient, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                .shadow(color: tint.opacity(0.18), radius: 10, x: 0, y: 6)

            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(AoiTheme.Typography.title(15, weight: .bold))
                    .foregroundStyle(AoiTheme.Colors.deepText)
                Text(title)
                    .font(AoiTheme.Typography.title(11, weight: .medium))
                    .foregroundStyle(AoiTheme.Colors.secondaryText)
            }

            Spacer(minLength: 0)
        }
        .padding(12)
        .background {
            RoundedRectangle(cornerRadius: AoiTheme.Layout.compactRadius, style: .continuous)
                .fill(Color.white.opacity(0.70))
                .overlay {
                    RoundedRectangle(cornerRadius: AoiTheme.Layout.compactRadius, style: .continuous)
                        .stroke(Color.white.opacity(0.88), lineWidth: 1)
                }
        }
    }
}
