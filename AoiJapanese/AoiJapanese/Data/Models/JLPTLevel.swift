import SwiftUI

enum JLPTLevel: String, CaseIterable, Identifiable, Codable {
    case zero
    case n5
    case n4
    case n3

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .zero:
            return "零基础"
        case .n5:
            return "JLPT N5"
        case .n4:
            return "JLPT N4"
        case .n3:
            return "JLPT N3"
        }
    }

    var shortName: String {
        switch self {
        case .zero:
            return "入门"
        case .n5:
            return "N5"
        case .n4:
            return "N4"
        case .n3:
            return "N3"
        }
    }

    var gradient: LinearGradient {
        switch self {
        case .zero:
            return LinearGradient(
                colors: [AoiTheme.Colors.sakuraSoft, AoiTheme.Colors.primaryBlue],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .n5:
            return LinearGradient(
                colors: [AoiTheme.Colors.indigo, AoiTheme.Colors.primaryBlue],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .n4:
            return LinearGradient(
                colors: [AoiTheme.Colors.matcha, Color(red: 0.42, green: 0.58, blue: 0.48)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .n3:
            return LinearGradient(
                colors: [AoiTheme.Colors.sakura, AoiTheme.Colors.primaryBlue],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
}
