import SwiftUI

struct WordsView: View {
    @State private var viewModel = WordsViewModel()

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 18) {
                    header
                    levelPicker
                    summaryCard
                    wordsList
                }
                .aoiPagePadding()
                .padding(.top, 14)
                .padding(.bottom, AoiTheme.Layout.tabBarContentInset)
            }
            .background(AoiBackground())
            .searchable(text: $viewModel.searchText, prompt: "搜索单词、假名或中文")
            .navigationTitle("单词")
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(for: VocabularyItem.self) { word in
                WordStudyView(word: word)
            }
        }
    }

    private var header: some View {
        SectionHeader("单词复习", subtitle: "用 SRS 的节奏，把词慢慢放进长期记忆")
    }

    private var levelPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach([JLPTLevel.n5, .n4, .n3]) { level in
                    Button {
                        withAnimation(.smooth(duration: 0.25)) {
                            viewModel.selectedLevel = level
                        }
                    } label: {
                        Text(level.shortName)
                            .font(AoiTheme.Typography.title(14, weight: .bold))
                            .foregroundStyle(viewModel.selectedLevel == level ? .white : AoiTheme.Colors.indigo)
                            .padding(.horizontal, 18)
                            .padding(.vertical, 10)
                            .background {
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .fill(viewModel.selectedLevel == level ? AoiTheme.Colors.indigo : Color.white.opacity(0.72))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                                            .stroke(Color.white.opacity(0.86), lineWidth: 1)
                                    }
                            }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var summaryCard: some View {
        GlassCard {
            HStack(spacing: 14) {
                MetricPill(icon: "checkmark.seal.fill", title: "已掌握", value: "\(viewModel.masteredCount)", tint: AoiTheme.Colors.matcha)
                MetricPill(icon: "calendar.badge.clock", title: "今日复习", value: "18", tint: AoiTheme.Colors.primaryBlue)
            }
        }
    }

    private var wordsList: some View {
        VStack(spacing: 12) {
            if viewModel.filteredWords.isEmpty {
                AoiEmptyState(
                    icon: "magnifyingglass",
                    title: "这里还很安静",
                    message: "当前等级或搜索条件下还没有单词。换一个等级，或者清空搜索再试。"
                )
                .padding(.top, 10)
            } else {
                ForEach(viewModel.filteredWords) { word in
                    NavigationLink(value: word) {
                        WordRow(
                            word: word,
                            favoriteAction: {
                                viewModel.toggleFavorite(for: word)
                            }
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

private struct WordRow: View {
    let word: VocabularyItem
    let favoriteAction: () -> Void

    var body: some View {
        GlassCard(padding: 16) {
            HStack(spacing: 14) {
                VStack(spacing: 3) {
                    Text(word.word)
                        .font(AoiTheme.Typography.japanese(24, weight: .bold))
                        .foregroundStyle(AoiTheme.Colors.deepText)
                    Text(word.kana)
                        .font(AoiTheme.Typography.japanese(13, weight: .semibold))
                        .foregroundStyle(AoiTheme.Colors.primaryBlue)
                }
                .frame(width: 86)

                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(word.meaningZh)
                            .font(AoiTheme.Typography.title(17, weight: .bold))
                            .foregroundStyle(AoiTheme.Colors.deepText)

                        Text(word.partOfSpeech)
                            .font(AoiTheme.Typography.title(11, weight: .bold))
                            .foregroundStyle(AoiTheme.Colors.secondaryText)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.white.opacity(0.76), in: RoundedRectangle(cornerRadius: 7, style: .continuous))
                    }

                    ProgressView(value: word.mastery)
                        .tint(AoiTheme.Colors.primaryBlue)

                    Text(word.exampleJa)
                        .font(AoiTheme.Typography.japanese(13, weight: .medium))
                        .foregroundStyle(AoiTheme.Colors.secondaryText)
                        .lineLimit(1)
                }

                Spacer(minLength: 0)

                Button(action: favoriteAction) {
                    Image(systemName: word.isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(word.isFavorite ? AoiTheme.Colors.sakura : AoiTheme.Colors.secondaryText)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

private struct WordStudyView: View {
    let word: VocabularyItem
    @State private var flipped = false

    var body: some View {
        ZStack {
            AoiBackground()

            VStack(spacing: 22) {
                Spacer(minLength: 20)

        GlassCard(padding: 28) {
                    VStack(spacing: 18) {
                        LevelBadge(level: word.jlptLevel)

                        Text(flipped ? word.meaningZh : word.word)
                            .font(flipped ? AoiTheme.Typography.display(38) : AoiTheme.Typography.japanese(56, weight: .bold))
                            .foregroundStyle(AoiTheme.Colors.deepText)
                            .minimumScaleFactor(0.7)

                        Text(flipped ? word.exampleZh : word.kana)
                            .font(flipped ? AoiTheme.Typography.body(20, weight: .semibold) : AoiTheme.Typography.japanese(20, weight: .semibold))
                            .foregroundStyle(AoiTheme.Colors.primaryBlue)

                        Text(flipped ? word.exampleJa : word.romaji)
                            .font(AoiTheme.Typography.body(15, weight: .medium))
                            .foregroundStyle(AoiTheme.Colors.secondaryText)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 320)
                }
                .rotation3DEffect(.degrees(flipped ? 4 : 0), axis: (x: 0, y: 1, z: 0))
                .onTapGesture {
                    withAnimation(AoiTheme.Motion.gentle) {
                        flipped.toggle()
                    }
                }

                HStack(spacing: 12) {
                    Button {
                        withAnimation(.smooth(duration: 0.25)) {
                            flipped = true
                        }
                    } label: {
                        Label("认识", systemImage: "checkmark.circle.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(PrimaryAoiButtonStyle(tint: AoiTheme.Colors.matcha))

                    Button {
                        withAnimation(.smooth(duration: 0.25)) {
                            flipped = false
                        }
                    } label: {
                        Label("再看", systemImage: "arrow.clockwise")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(PrimaryAoiButtonStyle(tint: AoiTheme.Colors.primaryBlue))
                }

                Spacer()
            }
            .aoiPagePadding()
        }
        .navigationTitle("单词卡")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PrimaryAoiButtonStyle: ButtonStyle {
    let tint: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AoiTheme.Typography.title(16, weight: .bold))
            .foregroundStyle(.white)
            .padding(.vertical, 15)
            .background {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(tint)
                    .opacity(configuration.isPressed ? 0.82 : 1)
            }
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(AoiTheme.Motion.quick, value: configuration.isPressed)
    }
}
