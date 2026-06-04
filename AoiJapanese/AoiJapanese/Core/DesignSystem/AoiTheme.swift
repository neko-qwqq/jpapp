import SwiftUI

enum AoiTheme {
    enum Colors {
        static let backgroundTop = Color(red: 0.985, green: 0.975, blue: 0.965)
        static let backgroundMiddle = Color(red: 0.955, green: 0.972, blue: 0.992)
        static let backgroundBottom = Color(red: 0.988, green: 0.948, blue: 0.958)
        static let porcelain = Color(red: 0.996, green: 0.992, blue: 0.982)
        static let washi = Color(red: 0.965, green: 0.948, blue: 0.922)
        static let primaryBlue = Color(red: 0.20, green: 0.40, blue: 0.72)
        static let indigo = Color(red: 0.13, green: 0.22, blue: 0.42)
        static let softBlue = Color(red: 0.72, green: 0.84, blue: 0.96)
        static let deepText = Color(red: 0.10, green: 0.12, blue: 0.17)
        static let secondaryText = Color(red: 0.43, green: 0.47, blue: 0.55)
        static let tertiaryText = Color(red: 0.60, green: 0.62, blue: 0.68)
        static let sakura = Color(red: 0.96, green: 0.62, blue: 0.70)
        static let sakuraSoft = Color(red: 1.0, green: 0.86, blue: 0.89)
        static let matcha = Color(red: 0.47, green: 0.62, blue: 0.48)
        static let lemon = Color(red: 0.93, green: 0.74, blue: 0.28)
        static let inkStroke = Color(red: 0.18, green: 0.23, blue: 0.30).opacity(0.08)
        static let cardFill = Color.white.opacity(0.74)
        static let cardStroke = Color.white.opacity(0.88)
    }

    enum Layout {
        static let screenPadding: CGFloat = 20
        static let cardRadius: CGFloat = 8
        static let compactRadius: CGFloat = 8
        static let controlRadius: CGFloat = 14
    }

    enum Shadow {
        static let soft = Color(red: 0.20, green: 0.25, blue: 0.34).opacity(0.10)
        static let lifted = Color(red: 0.16, green: 0.20, blue: 0.28).opacity(0.16)
    }

    enum Motion {
        static let gentle = Animation.spring(response: 0.62, dampingFraction: 0.86)
        static let quick = Animation.spring(response: 0.32, dampingFraction: 0.82)
    }

    enum Typography {
        static func display(_ size: CGFloat, weight: Font.Weight = .bold) -> Font {
            .system(size: size, weight: weight, design: .rounded)
        }

        static func title(_ size: CGFloat, weight: Font.Weight = .semibold) -> Font {
            .system(size: size, weight: weight, design: .rounded)
        }

        static func body(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
            .system(size: size, weight: weight, design: .default)
        }

        static func japanese(_ size: CGFloat, weight: Font.Weight = .semibold) -> Font {
            .system(size: size, weight: weight, design: .default)
        }
    }
}

extension View {
    func aoiPagePadding() -> some View {
        padding(.horizontal, AoiTheme.Layout.screenPadding)
    }

    func softShadow() -> some View {
        shadow(color: AoiTheme.Shadow.soft, radius: 18, x: 0, y: 10)
    }

    func liftedShadow() -> some View {
        shadow(color: AoiTheme.Shadow.lifted, radius: 28, x: 0, y: 16)
    }
}
