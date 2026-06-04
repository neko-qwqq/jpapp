import Foundation
import Observation

@Observable
final class WordsViewModel {
    var words: [VocabularyItem]
    var selectedLevel: JLPTLevel
    var searchText: String

    init(
        words: [VocabularyItem] = MockData.vocabulary,
        selectedLevel: JLPTLevel = .n5,
        searchText: String = ""
    ) {
        self.words = words
        self.selectedLevel = selectedLevel
        self.searchText = searchText
    }

    var filteredWords: [VocabularyItem] {
        words.filter { word in
            let matchesLevel = word.jlptLevel == selectedLevel
            let matchesSearch = searchText.isEmpty
                || word.word.localizedCaseInsensitiveContains(searchText)
                || word.kana.localizedCaseInsensitiveContains(searchText)
                || word.meaningZh.localizedCaseInsensitiveContains(searchText)
            return matchesLevel && matchesSearch
        }
    }

    var masteredCount: Int {
        words.filter { $0.mastery >= 0.8 }.count
    }

    func toggleFavorite(for word: VocabularyItem) {
        guard let index = words.firstIndex(where: { $0.id == word.id }) else { return }
        words[index].isFavorite.toggle()
    }
}
