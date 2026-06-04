import SwiftUI

enum AoiTheme {
    enum Colors {
        static let backgroundTop = Color(red: 1.00, green: 0.955, blue: 0.972)
        static let backgroundMiddle = Color(red: 0.995, green: 0.972, blue: 0.990)
        static let backgroundBottom = Color(red: 0.972, green: 0.952, blue: 1.00)
        static let porcelain = Color(red: 1.00, green: 0.985, blue: 0.990)
        static let washi = Color(red: 0.985, green: 0.930, blue: 0.948)
        static let primaryBlue = Color(red: 0.925, green: 0.330, blue: 0.540)
        static let indigo = Color(red: 0.365, green: 0.145, blue: 0.335)
        static let softBlue = Color(red: 0.900, green: 0.805, blue: 0.980)
        static let deepText = Color(red: 0.165, green: 0.105, blue: 0.165)
        static let secondaryText = Color(red: 0.500, green: 0.405, blue: 0.500)
        static let tertiaryText = Color(red: 0.665, green: 0.565, blue: 0.650)
        static let sakura = Color(red: 1.00, green: 0.465, blue: 0.635)
        static let sakuraSoft = Color(red: 1.00, green: 0.780, blue: 0.865)
        static let matcha = Color(red: 0.560, green: 0.680, blue: 0.520)
        static let lemon = Color(red: 0.960, green: 0.760, blue: 0.330)
        static let inkStroke = Color(red: 0.420, green: 0.180, blue: 0.330).opacity(0.055)
        static let cardFill = Color.white.opacity(0.80)
        static let cardStroke = Color.white.opacity(0.94)
    }

    enum Layout {
        static let screenPadding: CGFloat = 20
        static let cardRadius: CGFloat = 8
        static let compactRadius: CGFloat = 8
        static let controlRadius: CGFloat = 14
        static let tabBarContentInset: CGFloat = 40
    }

    enum Shadow {
        static let soft = Color(red: 0.72, green: 0.28, blue: 0.48).opacity(0.115)
        static let lifted = Color(red: 0.58, green: 0.20, blue: 0.40).opacity(0.18)
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
