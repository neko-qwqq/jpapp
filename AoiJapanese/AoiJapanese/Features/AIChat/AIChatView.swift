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
                }

                inputBar
                    .padding(.horizontal, AoiTheme.Layout.screenPadding)
                    .padding(.vertical, 12)
                    .background(.ultraThinMaterial)
            }
            .background(AoiBackground())
            .navigationTitle("AI 对话")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    private var scenePicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(AIPracticeScene.allCases) { scene in
                    Button {
                        withAnimation(.smooth(duration: 0.25)) {
                            viewModel.selectedScene = scene
                        }
                    } label: {
                        HStack(spacing: 7) {
                            Image(systemName: scene.icon)
                            Text(scene.title)
                        }
                        .font(AoiTheme.Typography.title(14, weight: .bold))
                        .foregroundStyle(viewModel.selectedScene == scene ? .white : AoiTheme.Colors.indigo)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background {
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(viewModel.selectedScene == scene ? AoiTheme.Colors.indigo : Color.white.opacity(0.72))
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
                    Text("AI 会限制在 N5 难度，给你温柔纠错。")
                        .font(AoiTheme.Typography.body(13, weight: .medium))
                        .foregroundStyle(AoiTheme.Colors.secondaryText)
                }

                Spacer()
            }
        }
    }

    private var inputBar: some View {
        HStack(spacing: 10) {
            TextField("输入一句日语，比如 水をください", text: $viewModel.inputText, axis: .vertical)
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
                    .background(AoiTheme.Colors.indigo, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
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
                    .padding(.horizontal, 15)
                    .padding(.vertical, 12)
                    .background {
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(isUser ? AoiTheme.Colors.indigo : Color.white.opacity(0.80))
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
                        .fill(AoiTheme.Colors.indigo.opacity(0.75))
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
