import SwiftUI

struct ProfileView: View {
    @State private var viewModel = ProfileViewModel()

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 18) {
                    profileCard
                    statsGrid
                    achievementsSection
                    settingsSection
                }
                .aoiPagePadding()
                .padding(.top, 14)
                .padding(.bottom, 96)
            }
            .background(AoiBackground())
            .navigationTitle("我的")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    private var profileCard: some View {
        GlassCard {
            VStack(spacing: 16) {
                AoiIllustrationMark(symbol: "character.book.closed.fill")
                    .frame(width: 86, height: 86)

                VStack(spacing: 6) {
                    Text(viewModel.profile.nickname)
                        .font(AoiTheme.Typography.display(24))
                        .foregroundStyle(AoiTheme.Colors.deepText)
                    LevelBadge(level: viewModel.profile.level)
                }

                Text("今天也在向能读懂日语的自己靠近。")
                    .font(AoiTheme.Typography.body(14, weight: .medium))
                    .foregroundStyle(AoiTheme.Colors.secondaryText)
            }
            .frame(maxWidth: .infinity)
        }
    }

    private var statsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            MetricPill(icon: "flame.fill", title: "连续打卡", value: "\(viewModel.profile.streakDays) 天", tint: AoiTheme.Colors.sakura)
            MetricPill(icon: "clock.fill", title: "总学习", value: viewModel.totalHoursText, tint: AoiTheme.Colors.primaryBlue)
            MetricPill(icon: "checkmark.seal.fill", title: "已完成课程", value: viewModel.courseCompletionText, tint: AoiTheme.Colors.matcha)
            MetricPill(icon: "star.fill", title: "当前阶段", value: viewModel.profile.level.shortName, tint: AoiTheme.Colors.lemon)
        }
    }

    private var achievementsSection: some View {
        VStack(spacing: 12) {
            SectionHeader("成就徽章", subtitle: "记录你已经做到的事")

            VStack(spacing: 12) {
                ForEach(viewModel.achievements) { achievement in
                    AchievementRow(achievement: achievement)
                }
            }
        }
    }

    private var settingsSection: some View {
        VStack(spacing: 12) {
            SectionHeader("设置")

            GlassCard(padding: 0) {
                VStack(spacing: 0) {
                    SettingsRow(icon: "bell.fill", title: "学习提醒", subtitle: "每天 20:30")
                    Divider().padding(.leading, 56)
                    SettingsRow(icon: "icloud.fill", title: "iCloud 同步", subtitle: "后续版本开启")
                    Divider().padding(.leading, 56)
                    SettingsRow(icon: "crown.fill", title: "Aoi Plus", subtitle: "订阅功能预留")
                }
            }
        }
    }
}

private struct AchievementRow: View {
    let achievement: Achievement

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: achievement.icon)
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(achievement.isUnlocked ? .white : AoiTheme.Colors.secondaryText)
                .frame(width: 46, height: 46)
                .background {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(achievement.isUnlocked ? achievement.tint : Color.white.opacity(0.72))
                }
                .shadow(color: achievement.isUnlocked ? achievement.tint.opacity(0.16) : .clear, radius: 10, x: 0, y: 6)

            VStack(alignment: .leading, spacing: 4) {
                Text(achievement.title)
                    .font(AoiTheme.Typography.title(16, weight: .bold))
                    .foregroundStyle(AoiTheme.Colors.deepText)
                Text(achievement.subtitle)
                    .font(AoiTheme.Typography.body(13, weight: .medium))
                    .foregroundStyle(AoiTheme.Colors.secondaryText)
            }

            Spacer()

            Image(systemName: achievement.isUnlocked ? "checkmark.circle.fill" : "lock.fill")
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(achievement.isUnlocked ? AoiTheme.Colors.matcha : AoiTheme.Colors.secondaryText.opacity(0.55))
        }
        .padding(16)
        .background(Color.white.opacity(0.72), in: RoundedRectangle(cornerRadius: AoiTheme.Layout.cardRadius, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: AoiTheme.Layout.cardRadius, style: .continuous)
                .stroke(Color.white.opacity(0.84), lineWidth: 1)
        }
    }
}

private struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 42, height: 42)
                .background(AoiTheme.Colors.primaryBlue.gradient, in: RoundedRectangle(cornerRadius: 8, style: .continuous))

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(AoiTheme.Typography.title(16, weight: .bold))
                    .foregroundStyle(AoiTheme.Colors.deepText)
                Text(subtitle)
                    .font(AoiTheme.Typography.body(12, weight: .medium))
                    .foregroundStyle(AoiTheme.Colors.secondaryText)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(AoiTheme.Colors.secondaryText.opacity(0.7))
        }
        .padding(16)
    }
}
