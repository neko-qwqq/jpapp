import Foundation
import Observation

@Observable
final class AIChatViewModel {
    var messages: [AIMessage]
    var inputText: String
    var selectedScene: AIPracticeScene {
        didSet {
            guard selectedScene != oldValue else { return }
            messages = AIChatViewModel.initialMessages(for: selectedScene)
        }
    }
    var isThinking: Bool
    var n3SessionCount: Int
    var latestN3Score: Int
    var realtimeStatus: RealtimePracticeStatus
    var realtimeTranscript: [RealtimeTranscriptLine]
    var realtimeLatencyMs: Int
    var realtimeInterruptions: Int
    var realtimeVoice: RealtimeVoiceProfile

    let n3Prompt = N3SimulationPrompt(
        title: "面试题 01",
        topic: "最近、生活の中で少し変えた習慣について話してください。",
        explanation: "请用 45 秒左右说明你最近改变的一个生活习惯，并说出原因和结果。",
        targetPattern: "〜ようにしています / 〜きっかけで / その結果",
        checkpoints: [
            "先说结论，再补原因",
            "至少使用 1 个 N3 连接表达",
            "结尾补一句自己的感受"
        ],
        sampleAnswer: "最近、朝早く起きるようにしています。仕事の前に日本語を勉強したいと思ったのがきっかけです。最初は大変でしたが、その結果、一日を落ち着いて始められるようになりました。"
    )

    let weaknessItems: [N3WeaknessItem] = [
        N3WeaknessItem(
            title: "连接表达",
            detail: "会说单句，但理由和结果之间还不够自然。",
            progress: 0.58,
            recommendation: "今天重点练：〜きっかけで、〜ようになりました。"
        ),
        N3WeaknessItem(
            title: "助词稳定度",
            detail: "「に / で / を」在长句中容易混用。",
            progress: 0.46,
            recommendation: "回答后用 10 秒检查动词前的助词。"
        ),
        N3WeaknessItem(
            title: "发音节奏",
            detail: "句尾语气不错，但长句停顿位置需要更清楚。",
            progress: 0.62,
            recommendation: "每 12 到 16 个音拍自然停顿一次。"
        )
    ]

    let scoringMetrics: [N3ScoringMetric] = [
        N3ScoringMetric(title: "流畅度", score: 78, note: "能连续表达，但中段停顿略长。"),
        N3ScoringMetric(title: "语法", score: 72, note: "N3 句型方向正确，助词要再稳定。"),
        N3ScoringMetric(title: "自然度", score: 81, note: "内容像真实生活经历，结尾可以更有余韵。")
    ]

    let realtimeChecklist: [RealtimeCapability] = [
        RealtimeCapability(icon: "bolt.fill", title: "低延迟", detail: "目标 300ms 内开始回应"),
        RealtimeCapability(icon: "hand.raised.fill", title: "可打断", detail: "用户插话时立即停止展开"),
        RealtimeCapability(icon: "waveform", title: "语音陪练", detail: "日语回复 + 中文短解释"),
        RealtimeCapability(icon: "lock.shield.fill", title: "安全连接", detail: "后端签发临时 client secret")
    ]

    let realtimeScript: [RealtimeTranscriptLine] = [
        RealtimeTranscriptLine(
            role: .teacher,
            text: "こんにちは。今日は声で話しましょう。",
            helperText: "中文：我们用语音练习，先短句开始。"
        ),
        RealtimeTranscriptLine(
            role: .user,
            text: "最近、日本語を話す練習をしています。",
            helperText: "用户语音转写"
        ),
        RealtimeTranscriptLine(
            role: .teacher,
            text: "いいですね。では、どうして練習を始めたんですか。",
            helperText: "实时追问：原因表达"
        )
    ]

    init(
        messages: [AIMessage]? = nil,
        inputText: String = "",
        selectedScene: AIPracticeScene = .n3Sprint,
        isThinking: Bool = false,
        n3SessionCount: Int = 3,
        latestN3Score: Int = 76,
        realtimeStatus: RealtimePracticeStatus = .idle,
        realtimeTranscript: [RealtimeTranscriptLine] = [],
        realtimeLatencyMs: Int = 0,
        realtimeInterruptions: Int = 0,
        realtimeVoice: RealtimeVoiceProfile = .mika
    ) {
        self.selectedScene = selectedScene
        self.messages = messages ?? AIChatViewModel.initialMessages(for: selectedScene)
        self.inputText = inputText
        self.isThinking = isThinking
        self.n3SessionCount = n3SessionCount
        self.latestN3Score = latestN3Score
        self.realtimeStatus = realtimeStatus
        self.realtimeTranscript = realtimeTranscript
        self.realtimeLatencyMs = realtimeLatencyMs
        self.realtimeInterruptions = realtimeInterruptions
        self.realtimeVoice = realtimeVoice
    }

    func sendCurrentMessage() {
        let trimmed = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        messages.append(AIMessage(role: .user, text: trimmed))
        inputText = ""
        isThinking = true

        let scene = selectedScene
        Task {
            try? await Task.sleep(for: .milliseconds(650))
            await MainActor.run {
                if scene == .n3Sprint {
                    latestN3Score = min(96, latestN3Score + 2)
                    n3SessionCount += 1
                }

                messages.append(
                    AIMessage(
                        role: .assistant,
                        text: response(for: trimmed, scene: scene),
                        helperText: helperText(for: scene)
                    )
                )
                isThinking = false
            }
        }
    }

    func startN3Simulation() {
        selectedScene = .n3Sprint
        appendAssistantMessage(
            "では、N3 模擬面接を始めます。\n\n質問：\(n3Prompt.topic)\n\nまず 3 文で答えてください。中国語で考えても大丈夫ですが、回答は日本語で言ってみましょう。",
            helperText: "开始时不用追求完美。先把「结论、原因、结果」说出来。"
        )
    }

    func fillN3SampleAnswer() {
        selectedScene = .n3Sprint
        inputText = n3Prompt.sampleAnswer
    }

    func generateWeaknessReport() {
        selectedScene = .n3Sprint
        appendAssistantMessage(
            "N3 弱点报告：\n\n1. 连接表达：你能表达意思，但需要把原因和结果接得更自然。\n2. 助词：长句里优先检查「に」「で」「を」。\n3. 发音：句尾清楚，长句中间建议增加短停顿。\n\n今日练习：用「〜ようにしています」说 3 个生活习惯。",
            helperText: "这是本地 Mock 报告。接入 OpenAI 后可根据真实对话记录生成。"
        )
    }

    func startRealtimePractice() {
        selectedScene = .realtime
        realtimeStatus = .connecting
        realtimeTranscript = []
        realtimeLatencyMs = 0

        Task {
            try? await Task.sleep(for: .milliseconds(480))
            await MainActor.run {
                realtimeStatus = .listening
                realtimeLatencyMs = 238
                realtimeTranscript = [realtimeScript[0]]
            }

            try? await Task.sleep(for: .milliseconds(720))
            await MainActor.run {
                realtimeStatus = .speaking
                realtimeTranscript.append(realtimeScript[1])
                realtimeTranscript.append(realtimeScript[2])
            }

            try? await Task.sleep(for: .milliseconds(680))
            await MainActor.run {
                realtimeStatus = .listening
            }
        }
    }

    func interruptRealtimeTeacher() {
        guard realtimeStatus == .speaking || realtimeStatus == .listening else { return }
        realtimeInterruptions += 1
        realtimeStatus = .interrupted
        realtimeLatencyMs = 164
        realtimeTranscript.append(
            RealtimeTranscriptLine(
                role: .user,
                text: "先生、もう一度ゆっくりお願いします。",
                helperText: "用户实时打断"
            )
        )
        realtimeTranscript.append(
            RealtimeTranscriptLine(
                role: .teacher,
                text: "もちろんです。ゆっくり言いますね。",
                helperText: "已中断上一段回复，重新慢速说明。"
            )
        )

        Task {
            try? await Task.sleep(for: .milliseconds(560))
            await MainActor.run {
                realtimeStatus = .listening
            }
        }
    }

    func stopRealtimePractice() {
        realtimeStatus = .idle
        realtimeLatencyMs = 0
    }

    private func appendAssistantMessage(_ text: String, helperText: String? = nil) {
        messages.append(AIMessage(role: .assistant, text: text, helperText: helperText))
    }

    private func response(for text: String, scene: AIPracticeScene) -> String {
        if scene == .n3Sprint {
            return n3Response(for: text)
        }

        if text.contains("ください") || text.contains("ください。") {
            return "言い方は自然です。少し丁寧にすると「お水をください」になります。\n\n中文：你的表达是对的，加上「お」会更礼貌。"
        }

        if text.contains("です") {
            return "いいですね。「です」の形は安定しています。次は理由を一つ足してみましょう。\n\n中文：句型稳定了，下一步练习补充原因。"
        }

        return "意味は伝わります。N5 なら「水をください」のように短く正確に言う練習から始めましょう。\n\n中文：先把短句说准，再慢慢增加自然度。"
    }

    private func n3Response(for text: String) -> String {
        var suggestions: [String] = []

        if !text.contains("よう") {
            suggestions.append("加入「〜ようにしています」可以表达正在努力养成的习惯。")
        }

        if !text.contains("きっかけ") {
            suggestions.append("加入「〜がきっかけです」可以把原因说得更像 N3。")
        }

        if !text.contains("結果") && !text.contains("その結果") {
            suggestions.append("最后用「その結果」补结果，会让回答结构更完整。")
        }

        let advice: String
        if suggestions.isEmpty {
            advice = "结构完整，已经像 N3 面试回答。下一步练发音停顿：每一句中间只停一次。"
        } else {
            advice = suggestions.joined(separator: "\n")
        }

        return "採点：\(latestN3Score) / 100\n\nよくできました。内容は伝わります。\n\n改善建议：\n\(advice)\n\n修正版：\n最近、朝早く起きるようにしています。日本語を勉強したいと思ったのがきっかけです。その結果、毎日少し自信が持てるようになりました。"
    }

    private func helperText(for scene: AIPracticeScene) -> String {
        switch scene {
        case .realtime:
            return "Realtime 会用于低延迟语音陪练，支持打断和短反馈。"
        case .n3Sprint:
            return "AI 会用鼓励式反馈指出语法、结构和发音节奏问题。"
        case .selfIntro:
            return "自我介绍优先练清楚：名字、身份、喜欢的事。"
        case .convenienceStore:
            return "便利店场景先练请求表达和礼貌语。"
        case .cafe:
            return "咖啡店场景适合练点单、确认和追加需求。"
        }
    }

    private static func initialMessages(for scene: AIPracticeScene) -> [AIMessage] {
        switch scene {
        case .realtime:
            return [
                AIMessage(
                    role: .assistant,
                    text: "Realtime 语音老师准备好了。\n\n这里会先向你的后端请求临时 client secret，再建立低延迟语音会话。当前界面已保留连接状态、实时打断和语音反馈区域。",
                    helperText: "标准 OpenAI API Key 不会进入 iOS 客户端。"
                )
            ]
        case .n3Sprint:
            return [
                AIMessage(
                    role: .assistant,
                    text: "こんにちは。今日は N3 冲刺模式です。\n\n我会像真人日语老师一样，帮你完成 JLPT 风格口语模拟、语法纠正、发音节奏提示和弱点报告。",
                    helperText: "先点「开始模拟」，或者直接输入一段日语回答。"
                )
            ]
        case .selfIntro:
            return [
                AIMessage(
                    role: .assistant,
                    text: "こんにちは。今日は自己紹介を練習しましょう。\n\n先说一句：私は学生です。",
                    helperText: "中文：我们先练最基础的自我介绍。"
                )
            ]
        case .convenienceStore:
            return [
                AIMessage(
                    role: .assistant,
                    text: "こんにちは。今日はコンビニの場面です。\n\n你可以说：水をください。",
                    helperText: "中文：便利店场景先练礼貌请求。"
                )
            ]
        case .cafe:
            return [
                AIMessage(
                    role: .assistant,
                    text: "こんにちは。今日はカフェで注文してみましょう。\n\n你可以说：コーヒーをください。",
                    helperText: "中文：咖啡店场景先练点单。"
                )
            ]
        }
    }
}

enum AIPracticeScene: String, CaseIterable, Identifiable, Equatable {
    case realtime
    case n3Sprint
    case selfIntro
    case convenienceStore
    case cafe

    var id: String { rawValue }

    var title: String {
        switch self {
        case .realtime:
            return "Realtime"
        case .n3Sprint:
            return "N3 冲刺"
        case .selfIntro:
            return "自我介绍"
        case .convenienceStore:
            return "便利店"
        case .cafe:
            return "咖啡店"
        }
    }

    var subtitle: String {
        switch self {
        case .realtime:
            return "低延迟语音陪练、实时打断和 AI 语音老师"
        case .n3Sprint:
            return "JLPT 风格口语模拟、弱点报告和发音节奏反馈"
        case .selfIntro:
            return "用简单句介绍自己，先建立开口信心"
        case .convenienceStore:
            return "练习请求、确认和礼貌表达"
        case .cafe:
            return "练习点单、追加和自然回应"
        }
    }

    var icon: String {
        switch self {
        case .realtime:
            return "waveform.and.mic"
        case .n3Sprint:
            return "target"
        case .selfIntro:
            return "person.wave.2.fill"
        case .convenienceStore:
            return "basket.fill"
        case .cafe:
            return "cup.and.saucer.fill"
        }
    }
}

enum RealtimePracticeStatus: Equatable {
    case idle
    case connecting
    case listening
    case speaking
    case interrupted

    var title: String {
        switch self {
        case .idle:
            return "未连接"
        case .connecting:
            return "连接中"
        case .listening:
            return "正在听你说"
        case .speaking:
            return "老师回应中"
        case .interrupted:
            return "已实时打断"
        }
    }

    var actionTitle: String {
        switch self {
        case .idle:
            return "开始语音"
        case .connecting:
            return "连接中"
        case .listening:
            return "结束"
        case .speaking:
            return "打断"
        case .interrupted:
            return "继续"
        }
    }
}

enum RealtimeTranscriptRole: Hashable {
    case user
    case teacher
}

struct RealtimeTranscriptLine: Identifiable, Hashable {
    let id = UUID()
    let role: RealtimeTranscriptRole
    let text: String
    let helperText: String
}

struct RealtimeCapability: Identifiable, Hashable {
    let id = UUID()
    let icon: String
    let title: String
    let detail: String
}

enum RealtimeVoiceProfile: String, CaseIterable, Identifiable {
    case mika
    case aoi
    case haru

    var id: String { rawValue }

    var title: String {
        switch self {
        case .mika:
            return "Mika"
        case .aoi:
            return "Aoi"
        case .haru:
            return "Haru"
        }
    }

    var subtitle: String {
        switch self {
        case .mika:
            return "发音教练"
        case .aoi:
            return "温柔老师"
        case .haru:
            return "日本朋友"
        }
    }

    var backendVoice: String {
        switch self {
        case .mika:
            return "marin"
        case .aoi:
            return "sage"
        case .haru:
            return "coral"
        }
    }
}

struct N3SimulationPrompt: Hashable {
    let title: String
    let topic: String
    let explanation: String
    let targetPattern: String
    let checkpoints: [String]
    let sampleAnswer: String
}

struct N3WeaknessItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let detail: String
    let progress: Double
    let recommendation: String
}

struct N3ScoringMetric: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let score: Int
    let note: String
}
