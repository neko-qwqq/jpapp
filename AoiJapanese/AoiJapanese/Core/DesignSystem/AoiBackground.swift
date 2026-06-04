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
                .opacity(0.24)
                .ignoresSafeArea()
        }
        .overlay(alignment: .top) {
            LinearGradient(
                colors: [
                    AoiTheme.Colors.sakuraSoft.opacity(0.58),
                    AoiTheme.Colors.porcelain.opacity(0.44),
                    AoiTheme.Colors.softBlue.opacity(0.22),
                    .clear
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: 340)
            .ignoresSafeArea()
        }
        .overlay(alignment: .bottom) {
            LinearGradient(
                colors: [
                    .clear,
                    AoiTheme.Colors.sakuraSoft.opacity(0.26),
                    AoiTheme.Colors.porcelain.opacity(0.76)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 260)
            .ignoresSafeArea()
        }
        .overlay(alignment: .topTrailing) {
            SakuraPetalField()
                .frame(width: 220, height: 310)
                .padding(.top, 20)
                .padding(.trailing, 0)
        }
        .overlay(alignment: .topLeading) {
            SakuraPetalField()
                .scaleEffect(x: -0.72, y: 0.72)
                .frame(width: 170, height: 240)
                .padding(.top, 130)
                .padding(.leading, -18)
                .opacity(0.62)
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
        (24, 12, -18, 0.74),
        (112, 34, 12, 0.60),
        (62, 82, 34, 0.42),
        (162, 112, -28, 0.52),
        (34, 176, 22, 0.40),
        (132, 214, 46, 0.34),
        (196, 256, -12, 0.30)
    ]

    var body: some View {
        ZStack {
            ForEach(Array(petals.enumerated()), id: \.offset) { _, petal in
                SakuraPetal()
                    .fill(AoiTheme.Colors.sakura.opacity(0.22))
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
