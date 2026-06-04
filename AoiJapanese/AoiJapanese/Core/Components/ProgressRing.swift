import SwiftUI

struct ProgressRing: View {
    let progress: Double
    let lineWidth: CGFloat
    let size: CGFloat
    @State private var renderedProgress = 0.0

    var body: some View {
        ZStack {
            Circle()
                .stroke(AoiTheme.Colors.indigo.opacity(0.08), lineWidth: lineWidth)

            Circle()
                .trim(from: 0, to: renderedProgress.clamped(to: 0...1))
                .stroke(
                    LinearGradient(
                        colors: [
                            AoiTheme.Colors.sakura,
                            AoiTheme.Colors.primaryBlue,
                            AoiTheme.Colors.softBlue
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .shadow(color: AoiTheme.Colors.sakura.opacity(0.24), radius: 9, x: 0, y: 5)

            VStack(spacing: 1) {
                Text("\(Int(renderedProgress.clamped(to: 0...1) * 100))%")
                    .font(AoiTheme.Typography.display(size * 0.20))
                    .foregroundStyle(AoiTheme.Colors.deepText)
                Text("今日")
                    .font(AoiTheme.Typography.title(size * 0.10, weight: .medium))
                    .foregroundStyle(AoiTheme.Colors.secondaryText)
            }
        }
        .frame(width: size, height: size)
        .onAppear {
            withAnimation(.spring(response: 0.95, dampingFraction: 0.82).delay(0.18)) {
                renderedProgress = progress
            }
        }
        .onChange(of: progress) {
            withAnimation(.spring(response: 0.72, dampingFraction: 0.84)) {
                renderedProgress = progress
            }
        }
    }
}

private extension Double {
    func clamped(to range: ClosedRange<Double>) -> Double {
        min(max(self, range.lowerBound), range.upperBound)
    }
}
