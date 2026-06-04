import Foundation
import SwiftUI

enum MockData {
    static let profile = UserProfile(
        id: UUID(),
        nickname: "Aoi 学习者",
        level: .n5,
        streakDays: 12,
        totalStudyMinutes: 386,
        weeklyStudyMinutes: [18, 24, 10, 32, 26, 14, 28],
        completedLessons: 18,
        totalLessons: 96
    )

    static let dailySummary = DailyStudySummary(
        progress: 0.68,
        targetMinutes: 15,
        studiedMinutes: 10,
        todayWordsCount: 12,
        todayGrammarCount: 2,
        aiPracticeCount: 1
    )

    static let vocabulary: [VocabularyItem] = [
        VocabularyItem(
            id: "n5_001",
            jlptLevel: .n5,
            word: "私",
            kana: "わたし",
            romaji: "watashi",
            meaningZh: "我",
            partOfSpeech: "代词",
            exampleJa: "私は学生です。",
            exampleZh: "我是学生。",
            mastery: 0.92,
            isFavorite: true
        ),
        VocabularyItem(
            id: "n5_002",
            jlptLevel: .n5,
            word: "学校",
            kana: "がっこう",
            romaji: "gakkou",
            meaningZh: "学校",
            partOfSpeech: "名词",
            exampleJa: "学校へ行きます。",
            exampleZh: "去学校。",
            mastery: 0.74,
            isFavorite: false
        ),
        VocabularyItem(
            id: "n5_003",
            jlptLevel: .n5,
            word: "水",
            kana: "みず",
            romaji: "mizu",
            meaningZh: "水",
            partOfSpeech: "名词",
            exampleJa: "水をください。",
            exampleZh: "请给我水。",
            mastery: 0.61,
            isFavorite: false
        ),
        VocabularyItem(
            id: "n5_004",
            jlptLevel: .n5,
            word: "猫",
            kana: "ねこ",
            romaji: "neko",
            meaningZh: "猫",
            partOfSpeech: "名词",
            exampleJa: "猫が好きです。",
            exampleZh: "我喜欢猫。",
            mastery: 0.86,
            isFavorite: true
        ),
        VocabularyItem(
            id: "n5_005",
            jlptLevel: .n5,
            word: "食べる",
            kana: "たべる",
            romaji: "taberu",
            meaningZh: "吃",
            partOfSpeech: "动词",
            exampleJa: "朝ごはんを食べます。",
            exampleZh: "吃早饭。",
            mastery: 0.48,
            isFavorite: false
        ),
        VocabularyItem(
            id: "n5_006",
            jlptLevel: .n5,
            word: "新しい",
            kana: "あたらしい",
            romaji: "atarashii",
            meaningZh: "新的",
            partOfSpeech: "い形容词",
            exampleJa: "新しい本を買いました。",
            exampleZh: "买了新书。",
            mastery: 0.36,
            isFavorite: false
        )
    ]

    static let grammar: [GrammarPoint] = [
        GrammarPoint(
            id: "g_n5_001",
            jlptLevel: .n5,
            title: "A は B です",
            pattern: "名词 は 名词 です",
            meaningZh: "表示“ A 是 B ”，用于基础判断句。",
            exampleJa: "私は学生です。",
            exampleZh: "我是学生。",
            tip: "は 在这里提示主题，读作 wa。"
        ),
        GrammarPoint(
            id: "g_n5_002",
            jlptLevel: .n5,
            title: "をください",
            pattern: "名词 をください",
            meaningZh: "表示“请给我……”，适合点餐、购物。",
            exampleJa: "コーヒーをください。",
            exampleZh: "请给我咖啡。",
            tip: "语气礼貌，初学者可以优先掌握。"
        ),
        GrammarPoint(
            id: "g_n5_003",
            jlptLevel: .n5,
            title: "へ行きます",
            pattern: "地点 へ 行きます",
            meaningZh: "表示去某个地方。",
            exampleJa: "図書館へ行きます。",
            exampleZh: "去图书馆。",
            tip: "へ 在这里读作 e，强调移动方向。"
        )
    ]

    static let courses: [CourseUnit] = [
        CourseUnit(
            id: "zero_kana",
            level: .zero,
            title: "五十音入门",
            subtitle: "从 あいうえお 开始，建立日语声音地图。",
            order: 1,
            progress: 1.0,
            lessons: [
                Lesson(id: "kana_01", title: "あ行与元音", type: .kana, estimatedMinutes: 6, isCompleted: true, isLocked: false),
                Lesson(id: "kana_02", title: "か行与清音", type: .kana, estimatedMinutes: 8, isCompleted: true, isLocked: false),
                Lesson(id: "kana_03", title: "浊音与半浊音", type: .kana, estimatedMinutes: 8, isCompleted: true, isLocked: false)
            ]
        ),
        CourseUnit(
            id: "n5_basic",
            level: .n5,
            title: "N5 基础句型",
            subtitle: "掌握です、ます、助词和日常表达。",
            order: 2,
            progress: 0.58,
            lessons: [
                Lesson(id: "n5_01", title: "私は学生です", type: .grammar, estimatedMinutes: 7, isCompleted: true, isLocked: false),
                Lesson(id: "n5_02", title: "水をください", type: .vocabulary, estimatedMinutes: 6, isCompleted: true, isLocked: false),
                Lesson(id: "n5_03", title: "学校へ行きます", type: .grammar, estimatedMinutes: 8, isCompleted: false, isLocked: false),
                Lesson(id: "n5_04", title: "便利店小对话", type: .aiPractice, estimatedMinutes: 5, isCompleted: false, isLocked: false)
            ]
        ),
        CourseUnit(
            id: "n4_te",
            level: .n4,
            title: "N4 て形世界",
            subtitle: "请求、连接、许可，从て形展开。",
            order: 3,
            progress: 0.18,
            lessons: [
                Lesson(id: "n4_01", title: "てください", type: .grammar, estimatedMinutes: 8, isCompleted: false, isLocked: false),
                Lesson(id: "n4_02", title: "てもいいです", type: .grammar, estimatedMinutes: 8, isCompleted: false, isLocked: false),
                Lesson(id: "n4_03", title: "听力：周末计划", type: .listening, estimatedMinutes: 9, isCompleted: false, isLocked: true)
            ]
        ),
        CourseUnit(
            id: "n3_connect",
            level: .n3,
            title: "N3 自然表达",
            subtitle: "学习更接近日常会话的连接与推量。",
            order: 4,
            progress: 0.0,
            lessons: [
                Lesson(id: "n3_01", title: "ように / ために", type: .grammar, estimatedMinutes: 10, isCompleted: false, isLocked: true),
                Lesson(id: "n3_02", title: "听力：车站广播", type: .listening, estimatedMinutes: 10, isCompleted: false, isLocked: true)
            ]
        )
    ]

    static let achievements: [Achievement] = [
        Achievement(id: "streak_7", title: "七日青空", subtitle: "连续学习 7 天", icon: "sun.max.fill", tint: AoiTheme.Colors.lemon, isUnlocked: true),
        Achievement(id: "words_50", title: "词语拾光", subtitle: "掌握 50 个单词", icon: "text.book.closed.fill", tint: AoiTheme.Colors.primaryBlue, isUnlocked: true),
        Achievement(id: "ai_10", title: "第一次开口", subtitle: "完成 10 次 AI 对话", icon: "sparkles", tint: AoiTheme.Colors.sakura, isUnlocked: false)
    ]

    static let aiMessages: [AIMessage] = [
        AIMessage(role: .assistant, text: "こんにちは。今日は便利店场景，我们用 N5 句型练一句。", helperText: "你可以说：水をください。"),
        AIMessage(role: .user, text: "水をください"),
        AIMessage(role: .assistant, text: "很好。更自然一点可以说：お水をください。", helperText: "お水 是更礼貌的说法。")
    ]
}
