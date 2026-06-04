import Foundation
import Observation

@Observable
final class AIChatViewModel {
    var messages: [AIMessage]
    var inputText: String
    var selectedScene: AIPracticeScene
    var isThinking: Bool

    init(
        messages: [AIMessage] = MockData.aiMessages,
        inputText: String = "",
        selectedScene: AIPracticeScene = .convenienceStore,
        isThinking: Bool = false
    ) {
        self.messages = messages
        self.inputText = inputText
        self.selectedScene = selectedScene
        self.isThinking = isThinking
    }

    func sendCurrentMessage() {
        let trimmed = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        messages.append(AIMessage(role: .user, text: trimmed))
        inputText = ""
        isThinking = true

        Task {
            try? await Task.sleep(for: .milliseconds(650))
            await MainActor.run {
                messages.append(
                    AIMessage(
                        role: .assistant,
                        text: response(for: trimmed),
                        helperText: "当前是 Mock AI。后续可在这里接入你的 AI 网关。"
                    )
                )
                isThinking = false
            }
        }
    }

    private func response(for text: String) -> String {
        if text.contains("ください") {
            return "说得很好。你已经正确使用了「をください」。下一句可以试试：コーヒーをください。"
        }
        if text.contains("です") {
            return "这句很自然。N5 阶段先稳定使用「です」句型，就已经很棒。"
        }
        return "我明白了。我们把它改成更适合 N5 的表达：水をください。"
    }
}

enum AIPracticeScene: String, CaseIterable, Identifiable {
    case selfIntro
    case convenienceStore
    case cafe

    var id: String { rawValue }

    var title: String {
        switch self {
        case .selfIntro:
            return "自我介绍"
        case .convenienceStore:
            return "便利店"
        case .cafe:
            return "咖啡店"
        }
    }

    var icon: String {
        switch self {
        case .selfIntro:
            return "person.wave.2.fill"
        case .convenienceStore:
            return "basket.fill"
        case .cafe:
            return "cup.and.saucer.fill"
        }
    }
}
