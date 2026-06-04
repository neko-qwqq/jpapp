import SwiftUI

struct GlassCard<Content: View>: View {
    let padding: CGFloat
    let content: Content

    init(padding: CGFloat = 18, @ViewBuilder content: () -> Content) {
        self.padding = padding
        self.content = content()
    }

    var body: some View {
        content
            .padding(padding)
            .background {
                RoundedRectangle(cornerRadius: AoiTheme.Layout.cardRadius, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                AoiTheme.Colors.cardFill,
                                AoiTheme.Colors.sakuraSoft.opacity(0.22),
                                AoiTheme.Colors.porcelain.opacity(0.84)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .background {
                        RoundedRectangle(cornerRadius: AoiTheme.Layout.cardRadius, style: .continuous)
                            .fill(.regularMaterial)
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: AoiTheme.Layout.cardRadius, style: .continuous)
                            .stroke(AoiTheme.Colors.cardStroke, lineWidth: 1)
                    }
                    .overlay(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: AoiTheme.Layout.cardRadius, style: .continuous)
                            .stroke(AoiTheme.Colors.sakuraSoft.opacity(0.36), lineWidth: 0.8)
                            .blur(radius: 0.2)
                    }
            }
            .softShadow()
    }
}
