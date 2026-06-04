import SwiftUI

struct HomeView: View {
    @State private var viewModel = HomeViewModel()
    @State private var appeared = false

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    header
                        .opacity(appeared ? 1 : 0)
                        .offset(y: appeared ? 0 : 12)

                    progressCard
                        .opacity(appeared ? 1 : 0)
                        .offset(y: appeared ? 0 : 18)

                    metricsGrid
                        .opacity(appeared ? 1 : 0)
                        .offset(y: appeared ? 0 : 22)

                    todayStudySection
                        .opacity(appeared ? 1 : 0)
                        .offset(y: appeared ? 0 : 26)

                    studyTimeSection
                        .opacity(appeared ? 1 : 0)
                        .offset(y: appeared ? 0 : 30)

                    aiAssistantCard
                        .opacity(appeared ? 1 : 0)
                        .offset(y: appeared ? 0 : 34)
                }
                .aoiPagePadding()
                .padding(.top, 14)
                .padding(.bottom, 96)
            }
            .background(AoiBackground())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(for: VocabularyItem.self) { word in
                WordDetailView(word: word)
            }
            .navigationDestination(for: GrammarPoint.self) { grammar in
                GrammarDetailView(grammar: grammar)
            }
            .onAppear {
                withAnimation(.smooth(duration: 0.65)) {
                    appeared = true
                }
            }
        }
    }

    private var header: some View {
        HStack(alignment: .center, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(viewModel.greeting)
                    .font(AoiTheme.Typography.body(15, weight: .medium))
                    .foregroundStyle(AoiTheme.Colors.secondaryText)

                Text(viewModel.profile.nickname)
                    .font(AoiTheme.Typography.display(30))
                    .foregroundStyle(AoiTheme.Colors.deepText)
            }

            Spacer()

            LevelBadge(level: viewModel.profile.level)
        }
    }

    private var progressCard: some View {
        GlassCard {
            HStack(spacing: 20) {
                ProgressRing(progress: viewModel.summary.progress, lineWidth: 11, size: 112)

                VStack(alignment: .leading, spacing: 12) {
                    Text("今日学习进度")
                        .font(AoiTheme.Typography.title(20, weight: .bold))
                        .foregroundStyle(AoiTheme.Colors.deepText)

                    Text(viewModel.remainingMinutesText)
                        .font(AoiTheme.Typography.body(14, weight: .medium))
                        .foregroundStyle(AoiTheme.Colors.secondaryText)

                    HStack(spacing: 8) {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 13, weight: .semibold))
                        Text("\(viewModel.summary.studiedMinutes)/\(viewModel.summary.targetMinutes) 分钟")
                            .font(AoiTheme.Typography.title(13, weight: .semibold))
                    }
                    .foregroundStyle(AoiTheme.Colors.indigo)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(AoiTheme.Colors.softBlue.opacity(0.30), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                }

                Spacer(minLength: 0)
            }
        }
    }

    private var metricsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            MetricPill(icon: "flame.fill", title: "连续打卡", value: "\(viewModel.profile.streakDays) 天", tint: AoiTheme.Colors.sakura)
            MetricPill(icon: "character.book.closed.fill", title: "今日单词", value: "\(viewModel.summary.todayWordsCount) 个", tint: AoiTheme.Colors.primaryBlue)
            MetricPill(icon: "text.alignleft", title: "今日语法", value: "\(viewModel.summary.todayGrammarCount) 个", tint: AoiTheme.Colors.matcha)
            MetricPill(icon: "sparkles", title: "AI 练习", value: "\(viewModel.summary.aiPracticeCount) 次", tint: AoiTheme.Colors.lemon)
        }
    }

    private var todayStudySection: some View {
        VStack(spacing: 12) {
            SectionHeader("今日任务", subtitle: "轻轻完成一小段，也算很好的一天")

            NavigationLink(value: viewModel.todayWord) {
                HomeTaskRow(
                    icon: "text.book.closed.fill",
                    title: viewModel.todayWord.word,
                    subtitle: "\(viewModel.todayWord.kana) · \(viewModel.todayWord.meaningZh)",
                    tag: "单词",
                    tint: AoiTheme.Colors.primaryBlue
                )
            }
            .buttonStyle(.plain)

            NavigationLink(value: viewModel.todayGrammar) {
                HomeTaskRow(
                    icon: "text.alignleft",
                    title: viewModel.todayGrammar.title,
                    subtitle: viewModel.todayGrammar.meaningZh,
                    tag: "语法",
                    tint: AoiTheme.Colors.matcha
                )
            }
            .buttonStyle(.plain)
        }
    }

    private var studyTimeSection: some View {
        VStack(spacing: 12) {
            SectionHeader("学习时间统计", subtitle: "本周学习节奏")
            GlassCard {
                StudyTimeBars(minutes: viewModel.profile.weeklyStudyMinutes)
            }
        }
    }

    private var aiAssistantCard: some View {
        NavigationLink {
            AIChatView()
        } label: {
            GlassCard {
                HStack(spacing: 16) {
                    AoiIllustrationMark(symbol: "sparkles")
                        .frame(width: 58, height: 58)

                    VStack(alignment: .leading, spacing: 5) {
                        Text("AI 学习助手")
                            .font(AoiTheme.Typography.title(18, weight: .bold))
                            .foregroundStyle(AoiTheme.Colors.deepText)

                        Text("用 N5 难度练一句便利店日语")
                            .font(AoiTheme.Typography.body(13, weight: .medium))
                            .foregroundStyle(AoiTheme.Colors.secondaryText)
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(AoiTheme.Colors.secondaryText)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

private struct HomeTaskRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let tag: String
    let tint: Color

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 42, height: 42)
                .background(tint.gradient, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                .shadow(color: tint.opacity(0.16), radius: 10, x: 0, y: 6)

            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 8) {
                    Text(title)
                        .font(AoiTheme.Typography.title(17, weight: .bold))
                        .foregroundStyle(AoiTheme.Colors.deepText)
                        .lineLimit(1)

                    Text(tag)
                        .font(AoiTheme.Typography.title(11, weight: .bold))
                        .foregroundStyle(tint)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(tint.opacity(0.12), in: RoundedRectangle(cornerRadius: 7, style: .continuous))
                }

                Text(subtitle)
                    .font(AoiTheme.Typography.body(13, weight: .medium))
                    .foregroundStyle(AoiTheme.Colors.secondaryText)
                    .lineLimit(2)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(AoiTheme.Colors.secondaryText.opacity(0.7))
        }
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: AoiTheme.Layout.cardRadius, style: .continuous)
                .fill(Color.white.opacity(0.72))
                .overlay {
                    RoundedRectangle(cornerRadius: AoiTheme.Layout.cardRadius, style: .continuous)
                        .stroke(Color.white.opacity(0.78), lineWidth: 1)
                }
        }
    }
}

private struct StudyTimeBars: View {
    let minutes: [Int]
    private let weekdays = ["一", "二", "三", "四", "五", "六", "日"]
    @State private var animated = false

    var body: some View {
        HStack(alignment: .bottom, spacing: 12) {
            ForEach(Array(minutes.enumerated()), id: \.offset) { index, value in
                VStack(spacing: 8) {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    AoiTheme.Colors.indigo,
                                    AoiTheme.Colors.primaryBlue,
                                    AoiTheme.Colors.sakura.opacity(0.82)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(height: animated ? max(CGFloat(value) * 3.0, 18) : 18)
                        .animation(.spring(response: 0.72, dampingFraction: 0.82).delay(Double(index) * 0.045), value: animated)

                    Text(weekdays[index])
                        .font(AoiTheme.Typography.title(11, weight: .semibold))
                        .foregroundStyle(AoiTheme.Colors.secondaryText)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(height: 132)
        .onAppear {
            animated = true
        }
    }
}

private struct WordDetailView: View {
    let word: VocabularyItem

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                GlassCard {
                    VStack(spacing: 12) {
                        LevelBadge(level: word.jlptLevel)

                        Text(word.word)
                            .font(AoiTheme.Typography.japanese(48, weight: .bold))
                            .foregroundStyle(AoiTheme.Colors.deepText)

                        Text(word.kana)
                            .font(AoiTheme.Typography.japanese(22, weight: .semibold))
                            .foregroundStyle(AoiTheme.Colors.primaryBlue)

                        Text(word.meaningZh)
                            .font(AoiTheme.Typography.body(18, weight: .medium))
                            .foregroundStyle(AoiTheme.Colors.secondaryText)
                    }
                    .frame(maxWidth: .infinity)
                }

                GlassCard {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("例句")
                            .font(AoiTheme.Typography.title(18, weight: .bold))
                        Text(word.exampleJa)
                            .font(AoiTheme.Typography.japanese(22, weight: .semibold))
                        Text(word.exampleZh)
                            .font(AoiTheme.Typography.body(15, weight: .medium))
                            .foregroundStyle(AoiTheme.Colors.secondaryText)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .aoiPagePadding()
            .padding(.top, 16)
            .padding(.bottom, 40)
        }
        .background(AoiBackground())
        .navigationTitle("单词详情")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct GrammarDetailView: View {
    let grammar: GrammarPoint

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                GlassCard {
                    VStack(alignment: .leading, spacing: 14) {
                        LevelBadge(level: grammar.jlptLevel)
                        Text(grammar.title)
                            .font(AoiTheme.Typography.display(30))
                            .foregroundStyle(AoiTheme.Colors.deepText)
                        Text(grammar.pattern)
                            .font(AoiTheme.Typography.japanese(17, weight: .semibold))
                            .foregroundStyle(AoiTheme.Colors.primaryBlue)
                        Text(grammar.meaningZh)
                            .font(AoiTheme.Typography.body(15, weight: .medium))
                            .foregroundStyle(AoiTheme.Colors.secondaryText)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                GlassCard {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("例句")
                            .font(AoiTheme.Typography.title(18, weight: .bold))
                        Text(grammar.exampleJa)
                            .font(AoiTheme.Typography.japanese(22, weight: .semibold))
                        Text(grammar.exampleZh)
                            .font(AoiTheme.Typography.body(15, weight: .medium))
                            .foregroundStyle(AoiTheme.Colors.secondaryText)
                        Divider()
                        Text(grammar.tip)
                            .font(AoiTheme.Typography.body(14, weight: .medium))
                            .foregroundStyle(AoiTheme.Colors.secondaryText)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .aoiPagePadding()
            .padding(.top, 16)
            .padding(.bottom, 40)
        }
        .background(AoiBackground())
        .navigationTitle("语法详情")
        .navigationBarTitleDisplayMode(.inline)
    }
}
