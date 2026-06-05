import SwiftUI

struct AIChatView: View {
    @State private var viewModel = AIChatViewModel()
    @FocusState private var isInputFocused: Bool

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                scenePicker
                    .padding(.horizontal, AoiTheme.Layout.screenPadding)
                    .padding(.top, 10)
                    .padding(.bottom, 12)

                ScrollViewReader { proxy in
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 14) {
                            assistantHeader

                            if viewModel.selectedScene == .realtime {
                                RealtimeVoicePanel(viewModel: viewModel)
                                    .transition(.opacity.combined(with: .move(edge: .top)))
                            } else if viewModel.selectedScene == .n3Sprint {
                                N3SprintPanel(viewModel: viewModel)
                                    .transition(.opacity.combined(with: .move(edge: .top)))
                            }

                            chatSectionTitle

                            ForEach(viewModel.messages) { message in
                                MessageBubble(message: message)
                                    .id(message.id)
                            }

                            if viewModel.isThinking {
                                ThinkingBubble()
                                    .id("thinking")
                            }
                        }
                        .padding(.horizontal, AoiTheme.Layout.screenPadding)
                        .padding(.top, 6)
                        .padding(.bottom, 20)
                    }
                    .onChange(of: viewModel.messages.count) {
                        scrollToBottom(proxy: proxy)
                    }
                    .onChange(of: viewModel.isThinking) {
                        scrollToBottom(proxy: proxy)
                    }
                    .onChange(of: viewModel.selectedScene) {
                        scrollToBottom(proxy: proxy)
                    }
                }

                inputBar
                    .padding(.horizontal, AoiTheme.Layout.screenPadding)
                    .padding(.vertical, 12)
                    .background(.ultraThinMaterial)
            }
            .background(AoiBackground())
            .navigationTitle("AI 日语老师")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    private var scenePicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(AIPracticeScene.allCases) { scene in
                    Button {
                        withAnimation(AoiTheme.Motion.quick) {
                            viewModel.selectedScene = scene
                        }
                    } label: {
                        HStack(spacing: 7) {
                            Image(systemName: scene.icon)
                            Text(scene.title)
                        }
                        .font(AoiTheme.Typography.title(14, weight: .bold))
                        .foregroundStyle(viewModel.selectedScene == scene ? .white : AoiTheme.Colors.primaryBlue)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background {
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(
                                    viewModel.selectedScene == scene
                                        ? AoiTheme.Colors.primaryBlue
                                        : Color.white.opacity(0.76)
                                )
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

    private var assistantHeader: some View {
        GlassCard {
            HStack(spacing: 14) {
                AoiIllustrationMark(symbol: viewModel.selectedScene.icon)
                    .frame(width: 56, height: 56)

                VStack(alignment: .leading, spacing: 5) {
                    Text(viewModel.selectedScene.title)
                        .font(AoiTheme.Typography.title(19, weight: .bold))
                        .foregroundStyle(AoiTheme.Colors.deepText)
                    Text(viewModel.selectedScene.subtitle)
                        .font(AoiTheme.Typography.body(13, weight: .medium))
                        .foregroundStyle(AoiTheme.Colors.secondaryText)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()
            }
        }
    }

    private var chatSectionTitle: some View {
        HStack {
            Label("老师反馈", systemImage: "bubble.left.and.bubble.right.fill")
                .font(AoiTheme.Typography.title(14, weight: .bold))
                .foregroundStyle(AoiTheme.Colors.primaryBlue)

            Spacer()

            Text(chatModeBadge)
                .font(AoiTheme.Typography.title(11, weight: .bold))
                .foregroundStyle(AoiTheme.Colors.secondaryText)
                .padding(.horizontal, 9)
                .padding(.vertical, 5)
                .background(Color.white.opacity(0.62), in: Capsule())
        }
        .padding(.top, 2)
    }

    private var chatModeBadge: String {
        if viewModel.selectedScene == .realtime {
            return "voice live"
        }

        if viewModel.selectedScene == .n3Sprint {
            return "N3 adaptive"
        }

        return "daily"
    }

    private var inputBar: some View {
        HStack(spacing: 10) {
            TextField("输入日语回答，例：最近、朝早く起きるようにしています", text: $viewModel.inputText, axis: .vertical)
                .font(AoiTheme.Typography.body(15, weight: .medium))
                .foregroundStyle(AoiTheme.Colors.deepText)
                .lineLimit(1...4)
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(Color.white.opacity(0.82), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(isInputFocused ? AoiTheme.Colors.primaryBlue.opacity(0.42) : Color.white.opacity(0.82), lineWidth: 1)
                }
                .focused($isInputFocused)

            Button {
                viewModel.sendCurrentMessage()
                isInputFocused = false
            } label: {
                Image(systemName: "paperplane.fill")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 46, height: 46)
                    .background(AoiTheme.Colors.primaryBlue, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
            }
            .disabled(viewModel.inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            .opacity(viewModel.inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.45 : 1)
        }
    }

    private func scrollToBottom(proxy: ScrollViewProxy) {
        withAnimation(.smooth(duration: 0.32)) {
            if viewModel.isThinking {
                proxy.scrollTo("thinking", anchor: .bottom)
            } else if let last = viewModel.messages.last {
                proxy.scrollTo(last.id, anchor: .bottom)
            }
        }
    }
}

private struct RealtimeVoicePanel: View {
    let viewModel: AIChatViewModel

    var body: some View {
        VStack(spacing: 14) {
            RealtimeHero(viewModel: viewModel)
            RealtimeVoiceSelector(viewModel: viewModel)
            RealtimeCapabilityGrid(items: viewModel.realtimeChecklist)
            RealtimeTranscriptCard(lines: viewModel.realtimeTranscript, status: viewModel.realtimeStatus)
            RealtimeBackendCard(voice: viewModel.realtimeVoice)
        }
    }
}

private struct RealtimeHero: View {
    let viewModel: AIChatViewModel

    var body: some View {
        GlassCard(padding: 18) {
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 14) {
                    RealtimeOrb(status: viewModel.realtimeStatus)
                        .frame(width: 96, height: 96)

                    VStack(alignment: .leading, spacing: 8) {
                        Label("Realtime 语音老师", systemImage: "waveform.and.mic")
                            .font(AoiTheme.Typography.title(13, weight: .bold))
                            .foregroundStyle(AoiTheme.Colors.primaryBlue)

                        Text(viewModel.realtimeStatus.title)
                            .font(AoiTheme.Typography.title(22, weight: .bold))
                            .foregroundStyle(AoiTheme.Colors.deepText)

                        Text("像和老师通话一样练日语：短反馈、可打断、实时转写。")
                            .font(AoiTheme.Typography.body(13, weight: .medium))
                            .foregroundStyle(AoiTheme.Colors.secondaryText)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    Spacer(minLength: 0)
                }

                HStack(spacing: 10) {
                    RealtimeMetricPill(title: "延迟", value: viewModel.realtimeLatencyMs > 0 ? "\(viewModel.realtimeLatencyMs)ms" : "--")
                    RealtimeMetricPill(title: "打断", value: "\(viewModel.realtimeInterruptions)")
                    RealtimeMetricPill(title: "模型", value: "Realtime")
                }

                HStack(spacing: 10) {
                    Button {
                        if viewModel.realtimeStatus == .idle {
                            viewModel.startRealtimePractice()
                        } else if viewModel.realtimeStatus == .speaking {
                            viewModel.interruptRealtimeTeacher()
                        } else if viewModel.realtimeStatus == .interrupted {
                            viewModel.startRealtimePractice()
                        } else {
                            viewModel.stopRealtimePractice()
                        }
                    } label: {
                        HStack(spacing: 7) {
                            Image(systemName: actionIcon)
                            Text(viewModel.realtimeStatus.actionTitle)
                        }
                        .font(AoiTheme.Typography.title(14, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(AoiTheme.Colors.primaryBlue, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                    }
                    .buttonStyle(.plain)

                    Button {
                        viewModel.interruptRealtimeTeacher()
                    } label: {
                        Image(systemName: "hand.raised.fill")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(AoiTheme.Colors.primaryBlue)
                            .frame(width: 48, height: 44)
                            .background(Color.white.opacity(0.74), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                    }
                    .buttonStyle(.plain)
                    .disabled(viewModel.realtimeStatus == .idle || viewModel.realtimeStatus == .connecting)
                    .opacity(viewModel.realtimeStatus == .idle || viewModel.realtimeStatus == .connecting ? 0.45 : 1)
                }
            }
        }
    }

    private var actionIcon: String {
        switch viewModel.realtimeStatus {
        case .idle:
            return "mic.fill"
        case .connecting:
            return "antenna.radiowaves.left.and.right"
        case .listening:
            return "stop.fill"
        case .speaking:
            return "hand.raised.fill"
        case .interrupted:
            return "play.fill"
        }
    }
}

private struct RealtimeVoiceSelector: View {
    let viewModel: AIChatViewModel

    var body: some View {
        HStack(spacing: 10) {
            ForEach(RealtimeVoiceProfile.allCases) { voice in
                Button {
                    withAnimation(AoiTheme.Motion.quick) {
                        viewModel.realtimeVoice = voice
                    }
                } label: {
                    VStack(spacing: 4) {
                        Text(voice.title)
                            .font(AoiTheme.Typography.title(14, weight: .bold))
                        Text(voice.subtitle)
                            .font(AoiTheme.Typography.body(11, weight: .medium))
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                    }
                    .foregroundStyle(viewModel.realtimeVoice == voice ? .white : AoiTheme.Colors.deepText)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 11)
                    .background {
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(viewModel.realtimeVoice == voice ? AoiTheme.Colors.primaryBlue : Color.white.opacity(0.72))
                            .overlay {
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .stroke(Color.white.opacity(0.88), lineWidth: 1)
                            }
                    }
                }
                .buttonStyle(.plain)
            }
        }
    }
}

private struct RealtimeCapabilityGrid: View {
    let items: [RealtimeCapability]

    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
            ForEach(items) { item in
                VStack(alignment: .leading, spacing: 8) {
                    Image(systemName: item.icon)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(AoiTheme.Colors.primaryBlue)
                        .frame(width: 34, height: 34)
                        .background(AoiTheme.Colors.sakuraSoft.opacity(0.42), in: RoundedRectangle(cornerRadius: 8, style: .continuous))

                    Text(item.title)
                        .font(AoiTheme.Typography.title(14, weight: .bold))
                        .foregroundStyle(AoiTheme.Colors.deepText)

                    Text(item.detail)
                        .font(AoiTheme.Typography.body(12, weight: .medium))
                        .foregroundStyle(AoiTheme.Colors.secondaryText)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(14)
                .background(Color.white.opacity(0.70), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(Color.white.opacity(0.88), lineWidth: 1)
                }
                .softShadow()
            }
        }
    }
}

private struct RealtimeTranscriptCard: View {
    let lines: [RealtimeTranscriptLine]
    let status: RealtimePracticeStatus

    var body: some View {
        GlassCard(padding: 18) {
            VStack(alignment: .leading, spacing: 13) {
                HStack {
                    Label("实时转写", systemImage: "captions.bubble.fill")
                        .font(AoiTheme.Typography.title(16, weight: .bold))
                        .foregroundStyle(AoiTheme.Colors.deepText)

                    Spacer()

                    Text(status.title)
                        .font(AoiTheme.Typography.title(11, weight: .bold))
                        .foregroundStyle(AoiTheme.Colors.primaryBlue)
                        .padding(.horizontal, 9)
                        .padding(.vertical, 5)
                        .background(AoiTheme.Colors.sakuraSoft.opacity(0.38), in: Capsule())
                }

                if lines.isEmpty {
                    VStack(spacing: 10) {
                        Image(systemName: "mic.and.signal.meter.fill")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(AoiTheme.Colors.primaryBlue)
                        Text("点击开始语音后，这里会显示你和老师的实时转写。")
                            .font(AoiTheme.Typography.body(13, weight: .medium))
                            .foregroundStyle(AoiTheme.Colors.secondaryText)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                } else {
                    ForEach(lines) { line in
                        RealtimeTranscriptRow(line: line)
                    }
                }
            }
        }
    }
}

private struct RealtimeTranscriptRow: View {
    let line: RealtimeTranscriptLine

    private var isUser: Bool {
        line.role == .user
    }

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: isUser ? "person.fill" : "sparkles")
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(isUser ? AoiTheme.Colors.primaryBlue : .white)
                .frame(width: 28, height: 28)
                .background(isUser ? Color.white.opacity(0.70) : AoiTheme.Colors.primaryBlue, in: RoundedRectangle(cornerRadius: 8, style: .continuous))

            VStack(alignment: .leading, spacing: 4) {
                Text(line.text)
                    .font(AoiTheme.Typography.japanese(14, weight: .semibold))
                    .foregroundStyle(AoiTheme.Colors.deepText)
                    .fixedSize(horizontal: false, vertical: true)

                Text(line.helperText)
                    .font(AoiTheme.Typography.body(12, weight: .medium))
                    .foregroundStyle(AoiTheme.Colors.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 0)
        }
        .padding(12)
        .background(isUser ? AoiTheme.Colors.sakuraSoft.opacity(0.24) : Color.white.opacity(0.62), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

private struct RealtimeBackendCard: View {
    let voice: RealtimeVoiceProfile

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("连接方案", systemImage: "server.rack")
                .font(AoiTheme.Typography.title(16, weight: .bold))
                .foregroundStyle(.white)

            Text("App 调用 /v1/ai/realtime/session 获取临时 client secret，标准 OpenAI API Key 只保存在后端。")
                .font(AoiTheme.Typography.body(12, weight: .medium))
                .foregroundStyle(Color.white.opacity(0.80))
                .fixedSize(horizontal: false, vertical: true)

            HStack(spacing: 8) {
                Label(voice.backendVoice, systemImage: "speaker.wave.2.fill")
                Label("oai-events", systemImage: "arrow.left.arrow.right")
            }
            .font(AoiTheme.Typography.title(11, weight: .bold))
            .foregroundStyle(Color.white.opacity(0.88))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            LinearGradient(
                colors: [
                    AoiTheme.Colors.indigo.opacity(0.92),
                    AoiTheme.Colors.primaryBlue.opacity(0.88)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(cornerRadius: 8, style: .continuous)
        )
        .softShadow()
    }
}

private struct RealtimeMetricPill: View {
    let title: String
    let value: String

    var body: some View {
        VStack(spacing: 2) {
            Text(value)
                .font(AoiTheme.Typography.title(13, weight: .bold))
                .foregroundStyle(AoiTheme.Colors.deepText)
                .lineLimit(1)
                .minimumScaleFactor(0.72)
            Text(title)
                .font(AoiTheme.Typography.body(11, weight: .medium))
                .foregroundStyle(AoiTheme.Colors.secondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Color.white.opacity(0.66), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

private struct RealtimeOrb: View {
    let status: RealtimePracticeStatus
    @State private var pulse = false

    var body: some View {
        ZStack {
            Circle()
                .fill(AoiTheme.Colors.sakuraSoft.opacity(0.34))
                .scaleEffect(pulse ? 1.04 : 0.88)
                .opacity(status == .idle ? 0.55 : 1)

            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            AoiTheme.Colors.porcelain,
                            AoiTheme.Colors.sakuraSoft,
                            AoiTheme.Colors.softBlue.opacity(0.62)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 78, height: 78)
                .overlay {
                    Circle()
                        .stroke(Color.white.opacity(0.92), lineWidth: 1)
                }

            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 26, weight: .bold))
                    .foregroundStyle(AoiTheme.Colors.primaryBlue)
                    .symbolEffect(.bounce, value: status.title)

                WaveBars(isActive: status != .idle)
                    .frame(width: 42, height: 18)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.85).repeatForever(autoreverses: true)) {
                pulse = true
            }
        }
    }

    private var icon: String {
        switch status {
        case .idle:
            return "mic.slash.fill"
        case .connecting:
            return "antenna.radiowaves.left.and.right"
        case .listening:
            return "ear.fill"
        case .speaking:
            return "speaker.wave.2.fill"
        case .interrupted:
            return "hand.raised.fill"
        }
    }
}

private struct WaveBars: View {
    let isActive: Bool
    @State private var animate = false

    var body: some View {
        HStack(alignment: .center, spacing: 3) {
            ForEach(0..<5, id: \.self) { index in
                Capsule()
                    .fill(AoiTheme.Colors.primaryBlue.opacity(isActive ? 0.78 : 0.32))
                    .frame(width: 4, height: barHeight(for: index))
                    .animation(
                        .easeInOut(duration: 0.45)
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.08),
                        value: animate
                    )
            }
        }
        .onAppear {
            animate = true
        }
    }

    private func barHeight(for index: Int) -> CGFloat {
        guard isActive else { return 6 }
        let base: CGFloat = [8, 14, 18, 12, 16][index]
        return animate ? base : max(6, base * 0.46)
    }
}

private struct N3SprintPanel: View {
    let viewModel: AIChatViewModel

    var body: some View {
        VStack(spacing: 14) {
            N3SprintHero(score: viewModel.latestN3Score, sessionCount: viewModel.n3SessionCount)

            N3ActionStrip(viewModel: viewModel)

            N3PromptCard(prompt: viewModel.n3Prompt)

            N3WeaknessReport(items: viewModel.weaknessItems)

            N3RubricCard(metrics: viewModel.scoringMetrics)

            N3PlusCard()
        }
    }
}

private struct N3SprintHero: View {
    let score: Int
    let sessionCount: Int

    var body: some View {
        GlassCard(padding: 18) {
            HStack(spacing: 16) {
                N3ScoreRing(score: score)
                    .frame(width: 94, height: 94)

                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 7) {
                        Image(systemName: "sparkle.magnifyingglass")
                        Text("N3 冲刺计划")
                    }
                    .font(AoiTheme.Typography.title(13, weight: .bold))
                    .foregroundStyle(AoiTheme.Colors.primaryBlue)

                    Text("今天目标：完成 1 次 JLPT 风格口语模拟，并生成弱点报告。")
                        .font(AoiTheme.Typography.title(18, weight: .bold))
                        .foregroundStyle(AoiTheme.Colors.deepText)
                        .fixedSize(horizontal: false, vertical: true)

                    HStack(spacing: 8) {
                        N3MiniStat(title: "模拟", value: "\(sessionCount) 次")
                        N3MiniStat(title: "目标", value: "85 分")
                    }
                }

                Spacer(minLength: 0)
            }
        }
    }
}

private struct N3ActionStrip: View {
    let viewModel: AIChatViewModel

    var body: some View {
        HStack(spacing: 10) {
            N3QuickAction(title: "开始", icon: "play.fill") {
                viewModel.startN3Simulation()
            }

            N3QuickAction(title: "示范", icon: "text.quote") {
                viewModel.fillN3SampleAnswer()
            }

            N3QuickAction(title: "报告", icon: "chart.bar.doc.horizontal.fill") {
                viewModel.generateWeaknessReport()
            }
        }
    }
}

private struct N3QuickAction: View {
    let title: String
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 13, weight: .bold))
                Text(title)
                    .font(AoiTheme.Typography.title(13, weight: .bold))
                    .lineLimit(1)
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 11)
            .background {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                AoiTheme.Colors.sakura,
                                AoiTheme.Colors.primaryBlue
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
        }
        .buttonStyle(.plain)
    }
}

private struct N3PromptCard: View {
    let prompt: N3SimulationPrompt

    var body: some View {
        GlassCard(padding: 18) {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(prompt.title)
                            .font(AoiTheme.Typography.title(13, weight: .bold))
                            .foregroundStyle(AoiTheme.Colors.primaryBlue)
                        Text("JLPT 风格口语模拟")
                            .font(AoiTheme.Typography.title(18, weight: .bold))
                            .foregroundStyle(AoiTheme.Colors.deepText)
                    }

                    Spacer()

                    Image(systemName: "waveform.and.mic")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(AoiTheme.Colors.primaryBlue)
                        .frame(width: 42, height: 42)
                        .background(AoiTheme.Colors.sakuraSoft.opacity(0.44), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                }

                Text(prompt.topic)
                    .font(AoiTheme.Typography.japanese(17, weight: .semibold))
                    .foregroundStyle(AoiTheme.Colors.deepText)
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)

                Text(prompt.explanation)
                    .font(AoiTheme.Typography.body(13, weight: .medium))
                    .foregroundStyle(AoiTheme.Colors.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)

                VStack(alignment: .leading, spacing: 8) {
                    Label(prompt.targetPattern, systemImage: "pin.fill")
                        .font(AoiTheme.Typography.title(13, weight: .bold))
                        .foregroundStyle(AoiTheme.Colors.primaryBlue)

                    ForEach(prompt.checkpoints, id: \.self) { checkpoint in
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundStyle(AoiTheme.Colors.matcha)
                                .padding(.top, 1)
                            Text(checkpoint)
                                .font(AoiTheme.Typography.body(13, weight: .medium))
                                .foregroundStyle(AoiTheme.Colors.secondaryText)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
            }
        }
    }
}

private struct N3WeaknessReport: View {
    let items: [N3WeaknessItem]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Label("弱点报告", systemImage: "list.clipboard.fill")
                    .font(AoiTheme.Typography.title(16, weight: .bold))
                    .foregroundStyle(AoiTheme.Colors.deepText)

                Spacer()

                Text("自动生成")
                    .font(AoiTheme.Typography.title(11, weight: .bold))
                    .foregroundStyle(AoiTheme.Colors.primaryBlue)
                    .padding(.horizontal, 9)
                    .padding(.vertical, 5)
                    .background(AoiTheme.Colors.sakuraSoft.opacity(0.38), in: Capsule())
            }

            ForEach(items.indices, id: \.self) { index in
                N3WeaknessRow(item: items[index], tint: tint(for: index))
            }
        }
        .padding(18)
        .background(Color.white.opacity(0.72), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(Color.white.opacity(0.90), lineWidth: 1)
        }
        .softShadow()
    }

    private func tint(for index: Int) -> Color {
        switch index {
        case 0:
            return AoiTheme.Colors.primaryBlue
        case 1:
            return AoiTheme.Colors.lemon
        default:
            return AoiTheme.Colors.matcha
        }
    }
}

private struct N3WeaknessRow: View {
    let item: N3WeaknessItem
    let tint: Color
    @State private var animatedProgress = 0.0

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(item.title)
                    .font(AoiTheme.Typography.title(14, weight: .bold))
                    .foregroundStyle(AoiTheme.Colors.deepText)

                Spacer()

                Text("\(Int(item.progress * 100))%")
                    .font(AoiTheme.Typography.title(12, weight: .bold))
                    .foregroundStyle(tint)
            }

            ProgressBar(progress: animatedProgress, tint: tint)

            Text(item.detail)
                .font(AoiTheme.Typography.body(12, weight: .medium))
                .foregroundStyle(AoiTheme.Colors.secondaryText)
                .fixedSize(horizontal: false, vertical: true)

            Text(item.recommendation)
                .font(AoiTheme.Typography.body(12, weight: .semibold))
                .foregroundStyle(AoiTheme.Colors.primaryBlue)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.vertical, 6)
        .onAppear {
            withAnimation(.spring(response: 0.7, dampingFraction: 0.84).delay(0.08)) {
                animatedProgress = item.progress
            }
        }
    }
}

private struct N3RubricCard: View {
    let metrics: [N3ScoringMetric]

    var body: some View {
        GlassCard(padding: 18) {
            VStack(alignment: .leading, spacing: 13) {
                Label("全真模拟评分", systemImage: "checkmark.seal.fill")
                    .font(AoiTheme.Typography.title(16, weight: .bold))
                    .foregroundStyle(AoiTheme.Colors.deepText)

                ForEach(metrics) { metric in
                    VStack(alignment: .leading, spacing: 7) {
                        HStack {
                            Text(metric.title)
                                .font(AoiTheme.Typography.title(14, weight: .bold))
                                .foregroundStyle(AoiTheme.Colors.deepText)

                            Spacer()

                            Text("\(metric.score)")
                                .font(AoiTheme.Typography.title(14, weight: .bold))
                                .foregroundStyle(AoiTheme.Colors.primaryBlue)
                        }

                        ProgressBar(progress: Double(metric.score) / 100.0, tint: AoiTheme.Colors.primaryBlue)

                        Text(metric.note)
                            .font(AoiTheme.Typography.body(12, weight: .medium))
                            .foregroundStyle(AoiTheme.Colors.secondaryText)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
        }
    }
}

private struct N3PlusCard: View {
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "crown.fill")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(AoiTheme.Colors.lemon)
                .frame(width: 42, height: 42)
                .background(Color.white.opacity(0.72), in: RoundedRectangle(cornerRadius: 8, style: .continuous))

            VStack(alignment: .leading, spacing: 4) {
                Text("Aoi Plus")
                    .font(AoiTheme.Typography.title(15, weight: .bold))
                    .foregroundStyle(.white)
                Text("订阅后解锁每日 3 次 N3 模拟、发音评分记录和完整弱点追踪。")
                    .font(AoiTheme.Typography.body(12, weight: .medium))
                    .foregroundStyle(Color.white.opacity(0.78))
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 0)
        }
        .padding(16)
        .background(
            LinearGradient(
                colors: [
                    AoiTheme.Colors.indigo.opacity(0.92),
                    AoiTheme.Colors.primaryBlue.opacity(0.88)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(cornerRadius: 8, style: .continuous)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(Color.white.opacity(0.28), lineWidth: 1)
        }
        .softShadow()
    }
}

private struct N3MiniStat: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(AoiTheme.Typography.body(11, weight: .medium))
                .foregroundStyle(AoiTheme.Colors.secondaryText)
            Text(value)
                .font(AoiTheme.Typography.title(13, weight: .bold))
                .foregroundStyle(AoiTheme.Colors.deepText)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 7)
        .background(Color.white.opacity(0.64), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

private struct N3ScoreRing: View {
    let score: Int
    @State private var renderedProgress = 0.0

    var body: some View {
        ZStack {
            Circle()
                .stroke(AoiTheme.Colors.indigo.opacity(0.08), lineWidth: 10)

            Circle()
                .trim(from: 0, to: renderedProgress)
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
                    style: StrokeStyle(lineWidth: 10, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .shadow(color: AoiTheme.Colors.sakura.opacity(0.25), radius: 8, x: 0, y: 4)

            VStack(spacing: 1) {
                Text("\(score)")
                    .font(AoiTheme.Typography.display(24))
                    .foregroundStyle(AoiTheme.Colors.deepText)
                Text("Score")
                    .font(AoiTheme.Typography.title(10, weight: .bold))
                    .foregroundStyle(AoiTheme.Colors.secondaryText)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.92, dampingFraction: 0.82).delay(0.12)) {
                renderedProgress = Double(score) / 100.0
            }
        }
        .onChange(of: score) {
            withAnimation(.spring(response: 0.68, dampingFraction: 0.84)) {
                renderedProgress = Double(score) / 100.0
            }
        }
    }
}

private struct ProgressBar: View {
    let progress: Double
    let tint: Color

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(AoiTheme.Colors.indigo.opacity(0.07))

                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [
                                tint.opacity(0.78),
                                AoiTheme.Colors.sakura.opacity(0.82)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: proxy.size.width * boundedProgress)
            }
        }
        .frame(height: 7)
    }

    private var boundedProgress: Double {
        min(max(progress, 0), 1)
    }
}

private struct MessageBubble: View {
    let message: AIMessage

    var isUser: Bool {
        message.role == .user
    }

    var body: some View {
        HStack(alignment: .bottom, spacing: 10) {
            if isUser {
                Spacer(minLength: 46)
            } else {
                avatar
            }

            VStack(alignment: isUser ? .trailing : .leading, spacing: 6) {
                Text(message.text)
                    .font(AoiTheme.Typography.body(15, weight: .medium))
                    .foregroundStyle(isUser ? .white : AoiTheme.Colors.deepText)
                    .lineSpacing(3)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 12)
                    .background {
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(isUser ? AoiTheme.Colors.primaryBlue : Color.white.opacity(0.82))
                            .overlay {
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .stroke(isUser ? Color.clear : Color.white.opacity(0.84), lineWidth: 1)
                            }
                    }

                if let helperText = message.helperText {
                    Text(helperText)
                        .font(AoiTheme.Typography.body(12, weight: .medium))
                        .foregroundStyle(AoiTheme.Colors.secondaryText)
                        .padding(.horizontal, 4)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            if isUser {
                avatar
            } else {
                Spacer(minLength: 46)
            }
        }
    }

    private var avatar: some View {
        Image(systemName: isUser ? "person.fill" : "sparkles")
            .font(.system(size: 13, weight: .bold))
            .foregroundStyle(isUser ? AoiTheme.Colors.primaryBlue : .white)
            .frame(width: 32, height: 32)
            .background {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(isUser ? Color.white.opacity(0.78) : AoiTheme.Colors.primaryBlue)
            }
    }
}

private struct ThinkingBubble: View {
    @State private var scale = false

    var body: some View {
        HStack {
            HStack(spacing: 5) {
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .fill(AoiTheme.Colors.primaryBlue.opacity(0.76))
                        .frame(width: 7, height: 7)
                        .scaleEffect(scale ? 1.2 : 0.72)
                        .animation(
                            .easeInOut(duration: 0.55)
                                .repeatForever()
                                .delay(Double(index) * 0.12),
                            value: scale
                        )
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 13)
            .background(Color.white.opacity(0.78), in: RoundedRectangle(cornerRadius: 8, style: .continuous))

            Spacer()
        }
        .onAppear {
            scale = true
        }
    }
}
