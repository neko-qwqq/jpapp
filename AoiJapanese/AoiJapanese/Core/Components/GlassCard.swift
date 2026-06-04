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
                    .fill(AoiTheme.Colors.cardFill)
                    .background {
                        RoundedRectangle(cornerRadius: AoiTheme.Layout.cardRadius, style: .continuous)
                            .fill(.regularMaterial)
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: AoiTheme.Layout.cardRadius, style: .continuous)
                            .stroke(AoiTheme.Colors.cardStroke, lineWidth: 1)
                    }
            }
            .softShadow()
    }
}
