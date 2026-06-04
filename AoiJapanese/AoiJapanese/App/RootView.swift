import SwiftUI

struct RootView: View {
    @State private var selectedTab: AppTab
    @State private var isShowingLaunch = true

    init(initialTab: AppTab = AppTab.initialFromLaunchArguments()) {
        _selectedTab = State(initialValue: initialTab)
    }

    var body: some View {
        ZStack {
            AoiBackground()

            activeTabView
                .transition(.opacity.combined(with: .scale(scale: 0.985)))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AoiBackground())
        .safeAreaInset(edge: .bottom, spacing: 0) {
            AoiTabBar(selectedTab: $selectedTab)
                .padding(.horizontal, 14)
                .padding(.bottom, 8)
                .opacity(isShowingLaunch ? 0 : 1)
        }
        .overlay {
            if isShowingLaunch {
                AoiLaunchView()
                    .ignoresSafeArea()
                    .transition(.opacity.combined(with: .scale(scale: 1.015)))
                    .zIndex(3)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.45) {
                withAnimation(.easeInOut(duration: 0.48)) {
                    isShowingLaunch = false
                }
            }
        }
    }

    @ViewBuilder
    private var activeTabView: some View {
        switch selectedTab {
        case .home:
            HomeView()
        case .words:
            WordsView()
        case .courses:
            CoursesView()
        case .ai:
            AIChatView()
        case .profile:
            ProfileView()
        }
    }
}

enum AppTab: String, Hashable {
    case home
    case words
    case courses
    case ai
    case profile

    var title: String {
        switch self {
        case .home:
            return "首页"
        case .words:
            return "单词"
        case .courses:
            return "课程"
        case .ai:
            return "AI 对话"
        case .profile:
            return "我的"
        }
    }

    var icon: String {
        switch self {
        case .home:
            return "house.fill"
        case .words:
            return "character.book.closed.fill"
        case .courses:
            return "map.fill"
        case .ai:
            return "sparkles"
        case .profile:
            return "person.crop.circle.fill"
        }
    }

    var selectedIcon: String {
        switch self {
        case .home:
            return "house.fill"
        case .words:
            return "character.book.closed.fill"
        case .courses:
            return "map.fill"
        case .ai:
            return "sparkles"
        case .profile:
            return "person.crop.circle.fill"
        }
    }

    static func initialFromLaunchArguments() -> AppTab {
        let arguments = ProcessInfo.processInfo.arguments

        guard let markerIndex = arguments.firstIndex(of: "--aoi-initial-tab") else {
            return .home
        }

        let valueIndex = arguments.index(after: markerIndex)
        guard valueIndex < arguments.endIndex else {
            return .home
        }

        return AppTab(rawValue: arguments[valueIndex]) ?? .home
    }
}

private struct AoiTabBar: View {
    @Binding var selectedTab: AppTab
    @Namespace private var namespace

    var body: some View {
        HStack(spacing: 4) {
            ForEach(AppTab.allTabs, id: \.self) { tab in
                Button {
                    withAnimation(AoiTheme.Motion.quick) {
                        selectedTab = tab
                    }
                } label: {
                    tabItem(tab)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(tab.title)
            }
        }
        .padding(6)
        .background {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(AoiTheme.Colors.porcelain.opacity(0.92))
                .background {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(.regularMaterial)
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color.white.opacity(0.72), lineWidth: 1)
                }
        }
        .shadow(color: AoiTheme.Shadow.lifted, radius: 24, x: 0, y: 14)
    }

    private func tabItem(_ tab: AppTab) -> some View {
        let isSelected = selectedTab == tab

        return VStack(spacing: 4) {
            ZStack {
                if isSelected {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [AoiTheme.Colors.indigo, AoiTheme.Colors.primaryBlue],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .matchedGeometryEffect(id: "selectedTab", in: namespace)
                }

                Image(systemName: isSelected ? tab.selectedIcon : tab.icon)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(isSelected ? .white : AoiTheme.Colors.secondaryText)
                    .symbolEffect(.bounce, value: isSelected)
            }
            .frame(width: 48, height: 34)

            Text(tab.title)
                .font(AoiTheme.Typography.title(10, weight: .bold))
                .foregroundStyle(isSelected ? AoiTheme.Colors.indigo : AoiTheme.Colors.tertiaryText)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
    }
}

private struct AoiLaunchView: View {
    @State private var markScale = 0.86
    @State private var titleOpacity = 0.0
    @State private var petalDrift = false

    var body: some View {
        ZStack {
            AoiBackground()

            VStack(spacing: 20) {
                ZStack {
                    AoiIllustrationMark(symbol: "sparkles")
                        .frame(width: 118, height: 118)
                        .scaleEffect(markScale)

                    ForEach(0..<5, id: \.self) { index in
                        SakuraPetalLaunch()
                            .fill(AoiTheme.Colors.sakura.opacity(0.46))
                            .frame(width: 12, height: 18)
                            .offset(
                                x: petalDrift ? CGFloat(index - 2) * 28 : CGFloat(index - 2) * 12,
                                y: petalDrift ? CGFloat(index % 2 == 0 ? -58 : 56) : 0
                            )
                            .rotationEffect(.degrees(petalDrift ? Double(index) * 46 : Double(index) * 10))
                            .opacity(petalDrift ? 0.0 : 1.0)
                    }
                }

                VStack(spacing: 7) {
                    Text("Aoi Japanese")
                        .font(AoiTheme.Typography.display(30))
                        .foregroundStyle(AoiTheme.Colors.deepText)
                    Text("青空の下で、少しずつ。")
                        .font(AoiTheme.Typography.japanese(15, weight: .medium))
                        .foregroundStyle(AoiTheme.Colors.secondaryText)
                }
                .opacity(titleOpacity)
            }
            .padding(.bottom, 24)
        }
        .onAppear {
            withAnimation(.spring(response: 0.7, dampingFraction: 0.78)) {
                markScale = 1.0
                titleOpacity = 1.0
            }
            withAnimation(.easeOut(duration: 1.05).delay(0.18)) {
                petalDrift = true
            }
        }
    }
}

private struct SakuraPetalLaunch: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addCurve(to: CGPoint(x: rect.maxX, y: rect.midY), control1: CGPoint(x: rect.maxX, y: rect.minY), control2: CGPoint(x: rect.maxX, y: rect.midY))
        path.addCurve(to: CGPoint(x: rect.midX, y: rect.maxY), control1: CGPoint(x: rect.maxX, y: rect.maxY), control2: CGPoint(x: rect.midX, y: rect.maxY))
        path.addCurve(to: CGPoint(x: rect.minX, y: rect.midY), control1: CGPoint(x: rect.midX, y: rect.maxY), control2: CGPoint(x: rect.minX, y: rect.maxY))
        path.addCurve(to: CGPoint(x: rect.midX, y: rect.minY), control1: CGPoint(x: rect.minX, y: rect.midY), control2: CGPoint(x: rect.minX, y: rect.minY))
        return path
    }
}

private extension AppTab {
    static let allTabs: [AppTab] = [.home, .words, .courses, .ai, .profile]
}
