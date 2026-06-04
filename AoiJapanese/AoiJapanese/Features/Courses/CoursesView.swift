import SwiftUI

struct CoursesView: View {
    @State private var viewModel = CoursesViewModel()

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 18) {
                    header
                    totalProgressCard
                    levelFilter
                    courseList
                }
                .aoiPagePadding()
                .padding(.top, 14)
                .padding(.bottom, 96)
            }
            .background(AoiBackground())
            .navigationTitle("课程")
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(for: CourseUnit.self) { course in
                CourseDetailView(course: course)
            }
        }
    }

    private var header: some View {
        SectionHeader("学习路径", subtitle: "零基础到 N3，一步一步走")
    }

    private var totalProgressCard: some View {
        GlassCard {
            HStack(spacing: 18) {
                ProgressRing(progress: viewModel.totalProgress, lineWidth: 10, size: 94)

                VStack(alignment: .leading, spacing: 8) {
                    Text("总路径进度")
                        .font(AoiTheme.Typography.title(20, weight: .bold))
                        .foregroundStyle(AoiTheme.Colors.deepText)
                    Text("当前重点：N5 基础句型")
                        .font(AoiTheme.Typography.body(14, weight: .medium))
                        .foregroundStyle(AoiTheme.Colors.secondaryText)
                    Text("建议今天完成 1 节课")
                        .font(AoiTheme.Typography.title(13, weight: .semibold))
                        .foregroundStyle(AoiTheme.Colors.indigo)
                }

                Spacer()
            }
        }
    }

    private var levelFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                levelButton(title: "全部", level: nil)
                ForEach(JLPTLevel.allCases) { level in
                    levelButton(title: level.shortName, level: level)
                }
            }
        }
    }

    private func levelButton(title: String, level: JLPTLevel?) -> some View {
        Button {
            withAnimation(.smooth(duration: 0.25)) {
                viewModel.selectedLevel = level
            }
        } label: {
            Text(title)
                .font(AoiTheme.Typography.title(14, weight: .bold))
                .foregroundStyle(viewModel.selectedLevel == level ? .white : AoiTheme.Colors.indigo)
                .padding(.horizontal, 16)
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

    private var courseList: some View {
        VStack(spacing: 14) {
            if viewModel.visibleCourses.isEmpty {
                AoiEmptyState(
                    icon: "map",
                    title: "路线正在准备",
                    message: "这个等级的课程还没有放进来。先回到全部路线继续学习。"
                )
                .padding(.top, 10)
            } else {
                ForEach(viewModel.visibleCourses) { course in
                    NavigationLink(value: course) {
                        CourseCard(course: course)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

private struct CourseCard: View {
    let course: CourseUnit

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    LevelBadge(level: course.level)
                    Spacer()
                    Text("\(Int(course.progress * 100))%")
                        .font(AoiTheme.Typography.title(14, weight: .bold))
                        .foregroundStyle(AoiTheme.Colors.indigo)
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text(course.title)
                        .font(AoiTheme.Typography.title(21, weight: .bold))
                        .foregroundStyle(AoiTheme.Colors.deepText)
                    Text(course.subtitle)
                        .font(AoiTheme.Typography.body(14, weight: .medium))
                        .foregroundStyle(AoiTheme.Colors.secondaryText)
                        .lineLimit(2)
                }

                ProgressView(value: course.progress)
                    .tint(AoiTheme.Colors.primaryBlue)

                HStack {
                    Label("\(course.lessons.count) 节课", systemImage: "rectangle.stack.fill")
                    Spacer()
                    Label("继续", systemImage: "chevron.right")
                }
                .font(AoiTheme.Typography.title(13, weight: .semibold))
                .foregroundStyle(AoiTheme.Colors.secondaryText)
            }
        }
    }
}

private struct CourseDetailView: View {
    let course: CourseUnit

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 18) {
                GlassCard {
                    VStack(alignment: .leading, spacing: 14) {
                        LevelBadge(level: course.level)
                        Text(course.title)
                            .font(AoiTheme.Typography.display(30))
                            .foregroundStyle(AoiTheme.Colors.deepText)
                        Text(course.subtitle)
                            .font(AoiTheme.Typography.body(15, weight: .medium))
                            .foregroundStyle(AoiTheme.Colors.secondaryText)
                        ProgressView(value: course.progress)
                            .tint(AoiTheme.Colors.primaryBlue)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                VStack(spacing: 12) {
                    ForEach(course.lessons) { lesson in
                        LessonRow(lesson: lesson)
                    }
                }
            }
            .aoiPagePadding()
            .padding(.top, 16)
            .padding(.bottom, 40)
        }
        .background(AoiBackground())
        .navigationTitle("课程详情")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct LessonRow: View {
    let lesson: Lesson

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: lesson.isCompleted ? "checkmark.circle.fill" : lesson.type.icon)
                .font(.system(size: 19, weight: .bold))
                .foregroundStyle(lesson.isLocked ? AoiTheme.Colors.secondaryText.opacity(0.48) : .white)
                .frame(width: 42, height: 42)
                .background {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(lesson.isLocked ? AoiTheme.Colors.tertiaryText.opacity(0.14) : AoiTheme.Colors.primaryBlue)
                }

            VStack(alignment: .leading, spacing: 4) {
                Text(lesson.title)
                    .font(AoiTheme.Typography.title(16, weight: .bold))
                    .foregroundStyle(lesson.isLocked ? AoiTheme.Colors.secondaryText : AoiTheme.Colors.deepText)
                Text("\(lesson.type.title) · \(lesson.estimatedMinutes) 分钟")
                    .font(AoiTheme.Typography.body(12, weight: .medium))
                    .foregroundStyle(AoiTheme.Colors.secondaryText)
            }

            Spacer()

            Image(systemName: lesson.isLocked ? "lock.fill" : "chevron.right")
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(AoiTheme.Colors.secondaryText.opacity(0.72))
        }
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: AoiTheme.Layout.cardRadius, style: .continuous)
                .fill(Color.white.opacity(0.72))
                .overlay {
                    RoundedRectangle(cornerRadius: AoiTheme.Layout.cardRadius, style: .continuous)
                        .stroke(Color.white.opacity(0.84), lineWidth: 1)
                }
        }
    }
}
