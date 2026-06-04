import SwiftUI

struct AoiBackground: View {
    var body: some View {
        LinearGradient(
            colors: [
                AoiTheme.Colors.backgroundTop,
                AoiTheme.Colors.backgroundMiddle,
                AoiTheme.Colors.backgroundBottom
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
        .overlay {
            WashiTexture()
                .opacity(0.34)
                .ignoresSafeArea()
        }
        .overlay(alignment: .top) {
            LinearGradient(
                colors: [
                    AoiTheme.Colors.sakuraSoft.opacity(0.46),
                    AoiTheme.Colors.softBlue.opacity(0.18),
                    .clear
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: 260)
            .ignoresSafeArea()
        }
        .overlay(alignment: .topTrailing) {
            SakuraPetalField()
                .frame(width: 170, height: 230)
                .padding(.top, 18)
                .padding(.trailing, 10)
        }
    }
}

private struct WashiTexture: View {
    var body: some View {
        Canvas { context, size in
            let lineColor = AoiTheme.Colors.inkStroke
            for index in 0..<18 {
                var path = Path()
                let y = size.height * CGFloat(index) / 18.0
                path.move(to: CGPoint(x: 0, y: y))
                path.addCurve(
                    to: CGPoint(x: size.width, y: y + CGFloat(index % 3 - 1) * 8),
                    control1: CGPoint(x: size.width * 0.33, y: y + 10),
                    control2: CGPoint(x: size.width * 0.66, y: y - 8)
                )
                context.stroke(path, with: .color(lineColor), lineWidth: 0.6)
            }
        }
    }
}

private struct SakuraPetalField: View {
    private let petals: [(x: CGFloat, y: CGFloat, rotation: Double, scale: CGFloat)] = [
        (24, 12, -18, 0.72),
        (112, 34, 12, 0.58),
        (62, 82, 34, 0.42),
        (136, 128, -28, 0.48),
        (34, 176, 22, 0.38)
    ]

    var body: some View {
        ZStack {
            ForEach(Array(petals.enumerated()), id: \.offset) { _, petal in
                SakuraPetal()
                    .fill(AoiTheme.Colors.sakura.opacity(0.16))
                    .frame(width: 30 * petal.scale, height: 44 * petal.scale)
                    .rotationEffect(.degrees(petal.rotation))
                    .position(x: petal.x, y: petal.y)
            }
        }
        .accessibilityHidden(true)
    }
}

private struct SakuraPetal: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addCurve(
            to: CGPoint(x: rect.maxX, y: rect.midY),
            control1: CGPoint(x: rect.maxX, y: rect.minY + rect.height * 0.10),
            control2: CGPoint(x: rect.maxX, y: rect.midY - rect.height * 0.18)
        )
        path.addCurve(
            to: CGPoint(x: rect.midX, y: rect.maxY),
            control1: CGPoint(x: rect.maxX, y: rect.midY + rect.height * 0.24),
            control2: CGPoint(x: rect.midX + rect.width * 0.12, y: rect.maxY)
        )
        path.addCurve(
            to: CGPoint(x: rect.minX, y: rect.midY),
            control1: CGPoint(x: rect.midX - rect.width * 0.12, y: rect.maxY),
            control2: CGPoint(x: rect.minX, y: rect.midY + rect.height * 0.24)
        )
        path.addCurve(
            to: CGPoint(x: rect.midX, y: rect.minY),
            control1: CGPoint(x: rect.minX, y: rect.midY - rect.height * 0.18),
            control2: CGPoint(x: rect.minX, y: rect.minY + rect.height * 0.10)
        )
        return path
    }
}
