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
            "零基础"
        case .n5:
            "JLPT N5"
        case .n4:
            "JLPT N4"
        case .n3:
            "JLPT N3"
        }
    }

    var shortName: String {
        switch self {
        case .zero:
            "入门"
        case .n5:
            "N5"
        case .n4:
            "N4"
        case .n3:
            "N3"
        }
    }

    var gradient: LinearGradient {
        switch self {
        case .zero:
            LinearGradient(
                colors: [AoiTheme.Colors.softBlue, AoiTheme.Colors.primaryBlue],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .n5:
            LinearGradient(
                colors: [AoiTheme.Colors.indigo, AoiTheme.Colors.primaryBlue],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .n4:
            LinearGradient(
                colors: [AoiTheme.Colors.matcha, Color(red: 0.34, green: 0.52, blue: 0.54)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .n3:
            LinearGradient(
                colors: [AoiTheme.Colors.sakura, Color(red: 0.76, green: 0.34, blue: 0.52)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
}
