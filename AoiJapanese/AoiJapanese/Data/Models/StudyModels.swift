import Foundation
import SwiftUI

struct UserProfile: Identifiable {
    let id: UUID
    var nickname: String
    var level: JLPTLevel
    var streakDays: Int
    var totalStudyMinutes: Int
    var weeklyStudyMinutes: [Int]
    var completedLessons: Int
    var totalLessons: Int
}

struct DailyStudySummary {
    var progress: Double
    var targetMinutes: Int
    var studiedMinutes: Int
    var todayWordsCount: Int
    var todayGrammarCount: Int
    var aiPracticeCount: Int
}

struct VocabularyItem: Identifiable, Hashable {
    let id: String
    let jlptLevel: JLPTLevel
    let word: String
    let kana: String
    let romaji: String
    let meaningZh: String
    let partOfSpeech: String
    let exampleJa: String
    let exampleZh: String
    var mastery: Double
    var isFavorite: Bool
}

struct GrammarPoint: Identifiable, Hashable {
    let id: String
    let jlptLevel: JLPTLevel
    let title: String
    let pattern: String
    let meaningZh: String
    let exampleJa: String
    let exampleZh: String
    let tip: String
}

struct CourseUnit: Identifiable, Hashable {
    let id: String
    let level: JLPTLevel
    let title: String
    let subtitle: String
    let order: Int
    let progress: Double
    let lessons: [Lesson]
}

struct Lesson: Identifiable, Hashable {
    let id: String
    let title: String
    let type: LessonType
    let estimatedMinutes: Int
    let isCompleted: Bool
    let isLocked: Bool
}

enum LessonType: String, CaseIterable, Hashable {
    case kana
    case vocabulary
    case grammar
    case listening
    case aiPractice

    var title: String {
        switch self {
        case .kana:
            return "假名"
        case .vocabulary:
            return "单词"
        case .grammar:
            return "语法"
        case .listening:
            return "听力"
        case .aiPractice:
            return "AI"
        }
    }

    var icon: String {
        switch self {
        case .kana:
            return "character.textbox"
        case .vocabulary:
            return "text.book.closed.fill"
        case .grammar:
            return "text.alignleft"
        case .listening:
            return "headphones"
        case .aiPractice:
            return "sparkles"
        }
    }
}

struct AIMessage: Identifiable, Hashable {
    let id: UUID
    let role: AIRole
    let text: String
    let helperText: String?

    init(role: AIRole, text: String, helperText: String? = nil) {
        self.id = UUID()
        self.role = role
        self.text = text
        self.helperText = helperText
    }
}

enum AIRole: Hashable {
    case user
    case assistant
}

struct Achievement: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let icon: String
    let tint: Color
    let isUnlocked: Bool
}
