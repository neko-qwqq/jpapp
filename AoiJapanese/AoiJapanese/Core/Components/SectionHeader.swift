import SwiftUI

struct SectionHeader: View {
    let title: String
    let subtitle: String?
    let actionTitle: String?
    let action: (() -> Void)?

    init(
        _ title: String,
        subtitle: String? = nil,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.actionTitle = actionTitle
        self.action = action
    }

    var body: some View {
        HStack(alignment: .lastTextBaseline) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(AoiTheme.Typography.title(20, weight: .bold))
                    .foregroundStyle(AoiTheme.Colors.deepText)

                if let subtitle {
                    Text(subtitle)
                        .font(AoiTheme.Typography.body(13, weight: .regular))
                        .foregroundStyle(AoiTheme.Colors.secondaryText)
                }
            }

            Spacer()

            if let actionTitle, let action {
                Button(action: action) {
                    Text(actionTitle)
                        .font(AoiTheme.Typography.title(13, weight: .semibold))
                        .foregroundStyle(AoiTheme.Colors.primaryBlue)
                }
            }
        }
    }
}

struct AoiEmptyState: View {
    let icon: String
    let title: String
    let message: String

    var body: some View {
        GlassCard(padding: 22) {
            VStack(spacing: 14) {
                AoiIllustrationMark(symbol: icon)
                    .frame(width: 92, height: 92)

                VStack(spacing: 6) {
                    Text(title)
                        .font(AoiTheme.Typography.title(18, weight: .bold))
                        .foregroundStyle(AoiTheme.Colors.deepText)
                    Text(message)
                        .font(AoiTheme.Typography.body(13, weight: .medium))
                        .foregroundStyle(AoiTheme.Colors.secondaryText)
                        .multilineTextAlignment(.center)
                        .lineSpacing(3)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct AoiIllustrationMark: View {
    let symbol: String

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            AoiTheme.Colors.porcelain,
                            AoiTheme.Colors.sakuraSoft.opacity(0.82),
                            AoiTheme.Colors.softBlue.opacity(0.56)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(Color.white.opacity(0.92), lineWidth: 1)
                }

            VStack(spacing: 6) {
                Image(systemName: symbol)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(AoiTheme.Colors.indigo)

                HStack(spacing: 3) {
                    ForEach(0..<3, id: \.self) { index in
                        SakuraPetalMini()
                            .fill(AoiTheme.Colors.sakura.opacity(0.42))
                            .frame(width: 9, height: 12)
                            .rotationEffect(.degrees(Double(index) * 28 - 24))
                    }
                }
            }
        }
        .liftedShadow()
    }
}

private struct SakuraPetalMini: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addCurve(to: CGPoint(x: rect.maxX, y: rect.midY), control1: CGPoint(x: rect.maxX, y: rect.minY), control2: CGPoint(x: rect.maxX, y: rect.midY))
        path.addCurve(to: CGPoint(x: rect.midX, y: rect.maxY), control1: CGPoint(x: rect.maxX, y: rect.maxY), control2: CGPoint(x: rect.midX, y: rect.maxY))
        path.addCurve(to: CGPoint(x: rect.minX, y: rect.midY), control1: CGPoint(x: rect.midX, y: rect.maxY), control2: CGPoint(x: rect.minX, y: rect.maxY))
        path.addCurve(to: CGPoint(x: rect.midX, y: rect.minY), control1: CGPoint(x: rect.minX, y: rect.midY), control2: CGPoint(x: rect.minX, y: rect.minY))
        return path
    }
}
