import Foundation
import Observation

@Observable
final class HomeViewModel {
    var profile: UserProfile
    var summary: DailyStudySummary
    var todayWord: VocabularyItem
    var todayGrammar: GrammarPoint

    init(
        profile: UserProfile = MockData.profile,
        summary: DailyStudySummary = MockData.dailySummary,
        todayWord: VocabularyItem = MockData.vocabulary[2],
        todayGrammar: GrammarPoint = MockData.grammar[1]
    ) {
        self.profile = profile
        self.summary = summary
        self.todayWord = todayWord
        self.todayGrammar = todayGrammar
    }

    var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<11:
            "早上好"
        case 11..<17:
            "今天也慢慢来"
        case 17..<22:
            "晚上好"
        default:
            "夜深了，轻轻复习一下"
        }
    }

    var remainingMinutesText: String {
        let remaining = max(summary.targetMinutes - summary.studiedMinutes, 0)
        return remaining == 0 ? "今日目标已完成" : "还差 \(remaining) 分钟"
    }
}
