# JLPT N5-N3 日语学习系统设计

本文档定义 Aoi 日语从零基础到 JLPT N3 的完整学习系统。设计目标是：每天 10-20 分钟可完成、内容可数据化、复习可算法化、后期可接 SwiftData/CloudKit/AI。

## 1. 学习系统总览

学习系统由 10 类内容组成：

1. 五十音
2. 单词
3. 语法
4. 听力
5. 阅读
6. 会话
7. 跟读
8. 假名测试
9. 汉字学习
10. 真题模拟

学习路径：

```text
Zero Foundation
└─ 假名、发音、基础问候

JLPT N5
└─ 基础词汇、基础句型、短听力、短阅读、生活会话

JLPT N4
└─ 动词变形、て形体系、日常文章、较长会话、基础考试题

JLPT N3
└─ 复杂连接、自然表达、敬语入门、综合阅读、考试冲刺
```

## 2. 难度递进

### Zero Foundation

目标：能读平假名、片假名，听辨基础音节，能说简单问候。

掌握标准：

- 平假名识别正确率 >= 90%
- 片假名识别正确率 >= 85%
- 清音、浊音、拗音听辨正确率 >= 80%
- 能完成 10 句基础问候跟读

### N5

目标：能理解最基础日语句子，完成简单自我介绍、点餐、问路。

掌握标准：

- 词汇：800 左右
- 汉字：100 左右
- 语法：80-100 个基础点
- 听力：30-60 秒短对话
- 阅读：100-250 字短文
- 会话：自我介绍、购物、点餐、时间日期、家庭学校

### N4

目标：能理解日常生活中较慢、较清晰的日语。

掌握标准：

- 累计词汇：1500-2000
- 累计汉字：300 左右
- 语法：120-160 个
- 听力：1-2 分钟日常对话
- 阅读：250-500 字文章
- 会话：计划、请求、许可、邀请、建议、理由说明

### N3

目标：能理解较自然的日常日语，具备 JLPT N3 应试能力。

掌握标准：

- 累计词汇：3500-4000
- 累计汉字：650 左右
- 语法：180-220 个
- 听力：2-4 分钟自然对话
- 阅读：500-900 字文章
- 会话：表达观点、转述、比较、解释原因、轻度敬语

## 3. 完整课程树

### Zero Foundation

```text
ZF-01 平假名清音
├─ L01 あ行：あ い う え お
├─ L02 か行：か き く け こ
├─ L03 さ行：さ し す せ そ
├─ L04 た行：た ち つ て と
├─ L05 な行：な に ぬ ね の
├─ L06 は行：は ひ ふ へ ほ
├─ L07 ま行：ま み む め も
├─ L08 や行：や ゆ よ
├─ L09 ら行：ら り る れ ろ
├─ L10 わ行：わ を ん
└─ L11 平假名综合测试

ZF-02 片假名清音
├─ L12 ア行：ア イ ウ エ オ
├─ L13 カ行：カ キ ク ケ コ
├─ L14 サ行：サ シ ス セ ソ
├─ L15 タ行：タ チ ツ テ ト
├─ L16 ナ行：ナ ニ ヌ ネ ノ
├─ L17 ハ行：ハ ヒ フ ヘ ホ
├─ L18 マ行：マ ミ ム メ モ
├─ L19 ヤ行：ヤ ユ ヨ
├─ L20 ラ行：ラ リ ル レ ロ
├─ L21 ワ行：ワ ヲ ン
└─ L22 片假名综合测试

ZF-03 发音规则
├─ L23 浊音：が ざ だ ば
├─ L24 半浊音：ぱ行
├─ L25 拗音：きゃ しゅ ちょ
├─ L26 促音：きって
├─ L27 长音：おばあさん
├─ L28 拨音：ん
└─ L29 假名听辨测试

ZF-04 入门会话
├─ L30 こんにちは
├─ L31 はじめまして
├─ L32 ありがとうございます
├─ L33 すみません
├─ L34 お願いします
└─ L35 入门会话跟读
```

### JLPT N5

```text
N5-01 名词句与自我介绍
├─ L001 A は B です
├─ L002 A は B ではありません
├─ L003 A ですか
├─ L004 私、あなた、先生、学生
├─ L005 自我介绍会话
├─ L006 自我介绍跟读
└─ L007 N5-01 小测

N5-02 指示词与物品
├─ L008 これ/それ/あれ/どれ
├─ L009 この/その/あの/どの
├─ L010 本、机、時計、鞄
├─ L011 これは何ですか
├─ L012 物品短阅读
├─ L013 物品听力
└─ L014 N5-02 小测

N5-03 数字、时间、日期
├─ L015 数字 1-10000
├─ L016 时间表达
├─ L017 星期与日期
├─ L018 いくらですか
├─ L019 价格听力
├─ L020 购物会话
└─ L021 N5-03 小测

N5-04 助词基础
├─ L022 は/が
├─ L023 を
├─ L024 に
├─ L025 で
├─ L026 へ
├─ L027 と/も
├─ L028 助词阅读
└─ L029 助词综合测试

N5-05 动词ます形
├─ L030 动词分类入门
├─ L031 ます/ません
├─ L032 ました/ませんでした
├─ L033 行きます/来ます/帰ります
├─ L034 食べます/飲みます
├─ L035 每日生活听力
├─ L036 每日生活跟读
└─ L037 N5-05 小测

N5-06 形容词
├─ L038 い形容词
├─ L039 な形容词
├─ L040 形容词过去式
├─ L041 好き/嫌い/上手/下手
├─ L042 描述人物和物品
├─ L043 描述短阅读
└─ L044 N5-06 小测

N5-07 存在句
├─ L045 あります/います
├─ L046 位置词
├─ L047 地点词汇
├─ L048 部屋の中に何がありますか
├─ L049 房间听力
├─ L050 位置描述跟读
└─ L051 N5-07 小测

N5-08 请求与许可入门
├─ L052 てください
├─ L053 てもいいです
├─ L054 てはいけません
├─ L055 ください
├─ L056 便利店会话
├─ L057 点餐会话
└─ L058 N5-08 小测

N5-09 汉字基础
├─ L059 人/日/月/火/水/木/金/土
├─ L060 上/下/中/外/右/左
├─ L061 大/小/新/古/高/安
├─ L062 学/校/先/生
├─ L063 汉字读音测试
└─ L064 N5 汉字小测

N5-10 N5 综合模拟
├─ L065 文字词汇模拟
├─ L066 语法模拟
├─ L067 阅读模拟
├─ L068 听力模拟
└─ L069 N5 阶段测评
```

### JLPT N4

```text
N4-01 动词て形核心
├─ L070 て形变化规则
├─ L071 てください
├─ L072 ています
├─ L073 てもいいです
├─ L074 てはいけません
├─ L075 てから
├─ L076 て形听力
└─ L077 N4-01 小测

N4-02 动词ない形与た形
├─ L078 ない形变化
├─ L079 ないでください
├─ L080 なければなりません
├─ L081 なくてもいいです
├─ L082 た形变化
├─ L083 たことがあります
├─ L084 たりたりします
└─ L085 N4-02 小测

N4-03 可能、意志、命令入门
├─ L086 できます
├─ L087 可能形
├─ L088 と思います
├─ L089 つもりです
├─ L090 ようと思います
├─ L091 计划会话
└─ L092 N4-03 小测

N4-04 授受与请求
├─ L093 あげます/もらいます/くれます
├─ L094 てあげます
├─ L095 てもらいます
├─ L096 てくれます
├─ L097 お願い会话
├─ L098 请求听力
└─ L099 N4-04 小测

N4-05 条件与原因
├─ L100 から/ので
├─ L101 と
├─ L102 ば
├─ L103 たら
├─ L104 なら
├─ L105 原因理由阅读
└─ L106 N4-05 小测

N4-06 比较与变化
├─ L107 より/ほど
├─ L108 のほうが
├─ L109 一番
├─ L110 くなります/になります
├─ L111 比较会话
├─ L112 比较阅读
└─ L113 N4-06 小测

N4-07 N4 汉字与阅读
├─ L114 生活汉字
├─ L115 学校工作汉字
├─ L116 交通汉字
├─ L117 公告阅读
├─ L118 邮件阅读
└─ L119 N4 阅读测评

N4-08 N4 综合模拟
├─ L120 文字词汇模拟
├─ L121 语法模拟
├─ L122 阅读模拟
├─ L123 听力模拟
└─ L124 N4 阶段测评
```

### JLPT N3

```text
N3-01 复杂连接
├─ L125 ように
├─ L126 ために
├─ L127 のに
├─ L128 ても
├─ L129 ばかり
├─ L130 ところ
├─ L131 复杂连接阅读
└─ L132 N3-01 小测

N3-02 推量与样态
├─ L133 そうです
├─ L134 ようです
├─ L135 みたいです
├─ L136 らしいです
├─ L137 はずです
├─ L138 かもしれません
├─ L139 推量听力
└─ L140 N3-02 小测

N3-03 被动、使役、使役被动
├─ L141 被动形
├─ L142 使役形
├─ L143 使役被动形
├─ L144 迷惑被动
├─ L145 被动阅读
├─ L146 被动跟读
└─ L147 N3-03 小测

N3-04 敬语入门
├─ L148 尊敬语
├─ L149 谦让语
├─ L150 丁宁语复习
├─ L151 店员会话
├─ L152 职场短对话
├─ L153 敬语听力
└─ L154 N3-04 小测

N3-05 表达观点
├─ L155 と思います
├─ L156 によると
├─ L157 について
├─ L158 に対して
├─ L159 わけです
├─ L160 观点短文阅读
└─ L161 N3-05 小测

N3-06 长阅读与信息检索
├─ L162 邮件阅读
├─ L163 广告阅读
├─ L164 说明文阅读
├─ L165 评论文阅读
├─ L166 信息检索题
└─ L167 N3 阅读测评

N3-07 听力强化
├─ L168 课题理解
├─ L169 要点理解
├─ L170 概要理解
├─ L171 发话表达
├─ L172 即时应答
└─ L173 N3 听力测评

N3-08 N3 考试冲刺
├─ L174 文字词汇冲刺
├─ L175 语法冲刺
├─ L176 阅读冲刺
├─ L177 听力冲刺
├─ L178 弱点复习
├─ L179 全真模拟一
├─ L180 全真模拟二
└─ L181 考前最终诊断
```

## 4. 每日学习计划

### 默认日程：每天 15 分钟

```text
第 1 段：复习 4 分钟
├─ 到期单词
├─ 到期语法
└─ 昨日错题

第 2 段：新课 7 分钟
├─ 1 个新语法或 8-12 个新词
├─ 1 组例句
└─ 3 道即时练习

第 3 段：输入训练 3 分钟
├─ 听力 / 阅读 二选一
└─ 根据当天课程自动匹配

第 4 段：输出训练 1 分钟
├─ 会话一句
└─ 跟读一句
```

### 周计划

```text
周一：新单词 + 语法
周二：新语法 + 听力
周三：复习日 + 阅读
周四：新单词 + 会话
周五：语法强化 + 跟读
周六：综合小测
周日：轻复习 + 学习报告
```

### 每日任务生成规则

```text
今日任务 = 必做复习 + 主线课程 + 弱点补强 + 轻输出

必做复习：
  取 nextReviewAt <= now 的前 N 个复习项

主线课程：
  取当前 level 当前 unit 中第一个未完成 lesson

弱点补强：
  从 mistakeRecords 中选择错题次数最高的 3 个知识点

轻输出：
  如果当天有语法，则生成 1 个会话练习
  如果当天有听力，则生成 1 个跟读练习
```

## 5. 艾宾浩斯复习系统

### 复习间隔

```text
Stage 0：10 分钟
Stage 1：1 天
Stage 2：3 天
Stage 3：7 天
Stage 4：14 天
Stage 5：30 天
Stage 6：60 天
Stage 7：120 天
```

### 复习对象

```text
ReviewItem
├─ vocabulary
├─ grammar
├─ kanji
├─ listening
├─ reading
├─ shadowing
└─ mistake
```

### 复习评分

用户每次答题后产生 quality：

```text
0：完全不会
1：想不起来
2：模糊认识
3：答对但犹豫
4：熟悉
5：秒答
```

### 复习推进规则

```text
if quality <= 1:
    stage = 0
    lapseCount += 1
    nextReviewAt = now + 10 minutes

if quality == 2:
    stage = max(stage - 1, 0)
    nextReviewAt = now + interval(stage)

if quality == 3:
    stage = stage
    nextReviewAt = now + interval(stage)

if quality >= 4:
    stage = min(stage + 1, 7)
    nextReviewAt = now + interval(stage)
```

## 6. 单词记忆算法

单词掌握度由五个维度组成：

```text
recognitionScore：看日文识别中文
recallScore：看中文回忆日文
listeningScore：听音识别
spellingScore：假名拼写
contextScore：例句理解
```

总掌握度：

```text
mastery =
  recognitionScore * 0.25 +
  recallScore * 0.25 +
  listeningScore * 0.20 +
  spellingScore * 0.15 +
  contextScore * 0.15
```

题型权重：

```text
初学阶段：
  看日选中：40%
  听音选词：25%
  看中选日：20%
  例句填空：15%

熟悉阶段：
  看中选日：30%
  听音选词：25%
  假名拼写：20%
  例句填空：25%

掌握阶段：
  例句填空：35%
  听写：25%
  快速识别：20%
  AI 造句：20%
```

单词状态：

```text
new：未学
learning：学习中
reviewing：复习中
mastered：已掌握
burned：长期记忆
```

状态转换：

```text
new -> learning:
  完成首次学习

learning -> reviewing:
  mastery >= 0.45 且 reviewCount >= 2

reviewing -> mastered:
  mastery >= 0.80 且连续 3 次 quality >= 4

mastered -> burned:
  stage >= 7 且 mastery >= 0.90

任意状态 -> learning:
  连续错误 2 次或 lapseCount 增加
```

## 7. 错题系统

### 错题类型

```text
MistakeType
├─ vocabularyMeaning
├─ vocabularyKana
├─ vocabularyListening
├─ grammarChoice
├─ grammarOrder
├─ readingComprehension
├─ listeningComprehension
├─ kanjiReading
├─ kanjiMeaning
└─ mockExam
```

### 错题记录规则

每一次错误都记录：

```text
itemId
itemType
lessonId
unitId
level
mistakeType
questionText
userAnswer
correctAnswer
explanation
wrongCount
lastWrongAt
nextReviewAt
relatedKnowledgeIds
```

### 错题优先级算法

```text
priority =
  wrongCount * 2.0 +
  recentWeight +
  examWeight +
  weakKnowledgeWeight -
  solvedWeight

recentWeight:
  24 小时内错误 +3
  7 天内错误 +2
  30 天内错误 +1

examWeight:
  真题模拟错误 +3
  阶段测评错误 +2
  普通练习错误 +1

weakKnowledgeWeight:
  相关知识点掌握度 < 0.5 时 +2

solvedWeight:
  连续答对 1 次 -1
  连续答对 2 次 -3
  连续答对 3 次后移出高频错题
```

## 8. 连续学习奖励

### 打卡定义

每日满足任意条件即可打卡：

```text
完成 1 个 lesson
或完成 10 个复习项
或学习 >= 5 分钟
或完成 1 次 AI 会话/跟读
```

### 奖励梯度

```text
连续 1 天：+10 XP
连续 3 天：解锁一句日语信笺
连续 7 天：青空徽章
连续 14 天：主题背景
连续 30 天：N5/N4/N3 阶段纪念卡
连续 60 天：专注学习者徽章
连续 100 天：长期旅人徽章
```

### 温柔补签

```text
每 7 天获得 1 张补签卡
最多持有 3 张
断签后 48 小时内可使用
使用后 streak 继续，但当天 XP 不补发
```

## 9. 游戏化机制

### XP

```text
完成新课：20 XP
完成单词复习：每题 1 XP
完成语法练习：每题 2 XP
完成听力：15 XP
完成阅读：15 XP
完成跟读：10 XP
完成 AI 会话：10 XP
阶段测评通过：50 XP
真题模拟完成：80 XP
```

### Level

```text
userLevel = floor(sqrt(totalXP / 30)) + 1
```

### 称号

```text
Lv 1：初见旅人
Lv 5：假名学徒
Lv 10：N5 见习生
Lv 18：日常会话者
Lv 25：N4 旅伴
Lv 35：阅读探索者
Lv 45：N3 挑战者
Lv 60：青空学习家
```

### 能量系统

不建议使用惩罚型体力。使用轻量「今日专注花」：

```text
每天最多点亮 5 片花瓣
每完成一个学习块点亮 1 片
点亮 3 片即可完成高质量学习日
```

## 10. N3 考试冲刺模式

### 开启条件

```text
N3 主线课程完成 >= 70%
或用户手动选择考试日期
```

### 冲刺周期

```text
30 天冲刺：
  第 1-7 天：弱点诊断 + 高频词汇
  第 8-14 天：语法和阅读强化
  第 15-21 天：听力专项
  第 22-27 天：全真模拟
  第 28-30 天：错题回收 + 轻量复习

14 天冲刺：
  每天 1 个专项 + 1 组错题 + 1 段听力

7 天冲刺：
  停止大量新课
  只做高频错题、真题模拟、听力耳感
```

### N3 冲刺每日结构

```text
复习：10 分钟
专项：15 分钟
模拟题：20 分钟
错题回收：10 分钟
听力跟读：5 分钟
```

### 冲刺评分

```text
examReadiness =
  vocabularyAccuracy * 0.20 +
  grammarAccuracy * 0.20 +
  readingAccuracy * 0.25 +
  listeningAccuracy * 0.25 +
  consistencyScore * 0.10
```

就绪等级：

```text
0.00 - 0.49：基础不足
0.50 - 0.64：需要补强
0.65 - 0.79：有通过希望
0.80 - 0.89：状态良好
0.90 - 1.00：非常稳定
```

## 11. 数据结构

### Swift 数据模型建议

```swift
enum JLPTLevel: String, Codable, CaseIterable, Identifiable {
    case zero
    case n5
    case n4
    case n3
}

enum ContentType: String, Codable, CaseIterable {
    case kana
    case vocabulary
    case grammar
    case listening
    case reading
    case conversation
    case shadowing
    case kanaTest
    case kanji
    case mockExam
}

struct CourseUnit: Codable, Identifiable {
    let id: String
    let level: JLPTLevel
    let title: String
    let subtitle: String
    let order: Int
    let requiredMastery: Double
    let lessonIds: [String]
}

struct LessonContent: Codable, Identifiable {
    let id: String
    let unitId: String
    let level: JLPTLevel
    let type: ContentType
    let title: String
    let subtitle: String
    let estimatedMinutes: Int
    let unlockRule: UnlockRule
    let objectives: [String]
    let vocabularyIds: [String]
    let grammarIds: [String]
    let kanjiIds: [String]
    let listeningIds: [String]
    let readingIds: [String]
    let conversationIds: [String]
    let shadowingIds: [String]
    let quizIds: [String]
    let reward: LessonReward
}

struct UnlockRule: Codable {
    let requiredLessonIds: [String]
    let requiredPlacementScore: Double?
    let requiredLevel: JLPTLevel?
}

struct LessonReward: Codable {
    let xp: Int
    let badgeId: String?
    let unlockMessage: String?
}

struct VocabularyItem: Codable, Identifiable {
    let id: String
    let level: JLPTLevel
    let word: String
    let kana: String
    let romaji: String
    let meaningZh: String
    let partOfSpeech: String
    let pitchAccent: String?
    let exampleJa: String
    let exampleKana: String
    let exampleZh: String
    let audioFileName: String?
    let tags: [String]
}

struct GrammarPoint: Codable, Identifiable {
    let id: String
    let level: JLPTLevel
    let title: String
    let pattern: String
    let meaningZh: String
    let connectionRule: String
    let examples: [ExampleSentence]
    let similarGrammarIds: [String]
    let commonMistakes: [String]
}

struct KanjiItem: Codable, Identifiable {
    let id: String
    let level: JLPTLevel
    let character: String
    let onyomi: [String]
    let kunyomi: [String]
    let meaningZh: String
    let words: [String]
    let strokeCount: Int
}

struct ListeningItem: Codable, Identifiable {
    let id: String
    let level: JLPTLevel
    let title: String
    let audioFileName: String
    let durationSeconds: Int
    let transcriptJa: String
    let transcriptKana: String
    let translationZh: String
    let questions: [QuizQuestion]
}

struct ReadingItem: Codable, Identifiable {
    let id: String
    let level: JLPTLevel
    let title: String
    let bodyJa: String
    let bodyKana: String?
    let translationZh: String?
    let questions: [QuizQuestion]
}

struct QuizQuestion: Codable, Identifiable {
    let id: String
    let type: QuestionType
    let prompt: String
    let choices: [String]
    let correctAnswer: String
    let explanation: String
    let relatedKnowledgeIds: [String]
}

enum QuestionType: String, Codable {
    case singleChoice
    case multipleChoice
    case fillBlank
    case orderSentence
    case kanaInput
    case listeningChoice
    case readingChoice
    case shadowing
}

struct LearningProgress: Codable, Identifiable {
    let id: String
    var userId: String
    var itemId: String
    var itemType: ContentType
    var level: JLPTLevel
    var status: ProgressStatus
    var mastery: Double
    var stage: Int
    var reviewCount: Int
    var correctCount: Int
    var wrongCount: Int
    var lapseCount: Int
    var lastStudiedAt: Date?
    var nextReviewAt: Date?
}

enum ProgressStatus: String, Codable {
    case locked
    case new
    case learning
    case reviewing
    case mastered
    case burned
}

struct MistakeRecord: Codable, Identifiable {
    let id: String
    let userId: String
    let itemId: String
    let lessonId: String
    let level: JLPTLevel
    let mistakeType: String
    let questionText: String
    let userAnswer: String
    let correctAnswer: String
    let explanation: String
    var wrongCount: Int
    var resolvedCount: Int
    var lastWrongAt: Date
    var nextReviewAt: Date
    let relatedKnowledgeIds: [String]
}
```

## 12. JSON 示例

### CourseUnit JSON

```json
{
  "id": "n5_01",
  "level": "n5",
  "title": "名词句与自我介绍",
  "subtitle": "用 A は B です 完成第一段自我介绍。",
  "order": 1,
  "requiredMastery": 0.75,
  "lessonIds": [
    "n5_001",
    "n5_002",
    "n5_003",
    "n5_004",
    "n5_005",
    "n5_006",
    "n5_007"
  ]
}
```

### Lesson JSON

```json
{
  "id": "n5_001",
  "unitId": "n5_01",
  "level": "n5",
  "type": "grammar",
  "title": "A は B です",
  "subtitle": "日语里最基础的判断句。",
  "estimatedMinutes": 7,
  "unlockRule": {
    "requiredLessonIds": [],
    "requiredPlacementScore": null,
    "requiredLevel": null
  },
  "objectives": [
    "理解 は 的主题提示作用",
    "掌握 名词 は 名词 です 的基本结构",
    "能说出一句自我介绍"
  ],
  "vocabularyIds": [
    "n5_word_001",
    "n5_word_002",
    "n5_word_003"
  ],
  "grammarIds": [
    "n5_grammar_001"
  ],
  "kanjiIds": [
    "n5_kanji_001",
    "n5_kanji_002"
  ],
  "listeningIds": [
    "n5_listening_001"
  ],
  "readingIds": [
    "n5_reading_001"
  ],
  "conversationIds": [
    "n5_conversation_001"
  ],
  "shadowingIds": [
    "n5_shadowing_001"
  ],
  "quizIds": [
    "n5_quiz_001",
    "n5_quiz_002",
    "n5_quiz_003"
  ],
  "reward": {
    "xp": 20,
    "badgeId": null,
    "unlockMessage": "你已经会说第一句完整日语了。"
  }
}
```

### Vocabulary JSON

```json
{
  "id": "n5_word_001",
  "level": "n5",
  "word": "私",
  "kana": "わたし",
  "romaji": "watashi",
  "meaningZh": "我",
  "partOfSpeech": "代词",
  "pitchAccent": "0",
  "exampleJa": "私は学生です。",
  "exampleKana": "わたしは がくせいです。",
  "exampleZh": "我是学生。",
  "audioFileName": "n5_word_001.m4a",
  "tags": [
    "self_intro",
    "basic"
  ]
}
```

### Grammar JSON

```json
{
  "id": "n5_grammar_001",
  "level": "n5",
  "title": "A は B です",
  "pattern": "名词 は 名词 です",
  "meaningZh": "表示“A 是 B”。",
  "connectionRule": "は 前接名词或代词；です 放在句末。",
  "examples": [
    {
      "ja": "私は学生です。",
      "kana": "わたしは がくせいです。",
      "zh": "我是学生。"
    },
    {
      "ja": "田中さんは先生です。",
      "kana": "たなかさんは せんせいです。",
      "zh": "田中先生是老师。"
    }
  ],
  "similarGrammarIds": [
    "n5_grammar_002"
  ],
  "commonMistakes": [
    "は 在这里读 wa，不读 ha。",
    "です 不是动词，但能让句子变礼貌。"
  ]
}
```

### Quiz JSON

```json
{
  "id": "n5_quiz_001",
  "type": "singleChoice",
  "prompt": "「私は学生です。」是什么意思？",
  "choices": [
    "我是学生。",
    "我是老师。",
    "你是学生。",
    "这里是学校。"
  ],
  "correctAnswer": "我是学生。",
  "explanation": "私 是“我”，学生 是“学生”，です 表示礼貌判断。",
  "relatedKnowledgeIds": [
    "n5_word_001",
    "n5_word_002",
    "n5_grammar_001"
  ]
}
```

## 13. 每课内容格式

每一课固定由 7 个区块组成，便于 UI 统一渲染：

```text
Lesson
├─ 1. WarmUp
│  ├─ 复习 2-3 个旧知识
│  └─ 引出本课目标
├─ 2. Learn
│  ├─ 新单词 / 新语法 / 新汉字
│  └─ 卡片式解释
├─ 3. Example
│  ├─ 3 个日文例句
│  ├─ 假名标注
│  └─ 中文翻译
├─ 4. Practice
│  ├─ 选择题
│  ├─ 填空题
│  └─ 排序题
├─ 5. Input
│  ├─ 听力或阅读
│  └─ 1-3 道理解题
├─ 6. Output
│  ├─ 会话
│  └─ 跟读
└─ 7. ReviewPlan
   ├─ 写入复习队列
   └─ 生成 nextReviewAt
```

内容格式：

```json
{
  "lessonId": "n5_001",
  "blocks": [
    {
      "type": "warmUp",
      "title": "先回想一下",
      "items": [
        {
          "kind": "quickReview",
          "itemId": "zf_kana_a"
        }
      ]
    },
    {
      "type": "learn",
      "title": "今天的句型",
      "items": [
        {
          "kind": "grammarCard",
          "itemId": "n5_grammar_001"
        }
      ]
    },
    {
      "type": "practice",
      "title": "试试看",
      "items": [
        {
          "kind": "quiz",
          "itemId": "n5_quiz_001"
        }
      ]
    },
    {
      "type": "output",
      "title": "说一句",
      "items": [
        {
          "kind": "conversation",
          "itemId": "n5_conversation_001"
        },
        {
          "kind": "shadowing",
          "itemId": "n5_shadowing_001"
        }
      ]
    }
  ]
}
```

## 14. 学习进度算法

### Lesson 完成度

```text
lessonProgress =
  learnCompletion * 0.25 +
  practiceAccuracy * 0.30 +
  inputCompletion * 0.20 +
  outputCompletion * 0.15 +
  reviewScheduled * 0.10
```

Lesson 完成条件：

```text
lessonProgress >= 0.75
且 practiceAccuracy >= 0.60
```

### Unit 完成度

```text
unitProgress =
  completedLessons / totalLessons * 0.50 +
  averageLessonMastery * 0.30 +
  unitTestScore * 0.20
```

Unit 解锁下一单元：

```text
unitProgress >= 0.75
或 completedLessons / totalLessons >= 0.85
```

### Level 完成度

```text
levelProgress =
  vocabularyMastery * 0.25 +
  grammarMastery * 0.25 +
  kanjiMastery * 0.15 +
  listeningMastery * 0.15 +
  readingMastery * 0.15 +
  mockExamScore * 0.05
```

进入下一等级建议：

```text
levelProgress >= 0.78
且 vocabularyMastery >= 0.70
且 grammarMastery >= 0.70
且 listeningMastery >= 0.60
且 readingMastery >= 0.60
```

### 今日任务完成度

```text
dailyProgress =
  reviewDone / reviewTarget * 0.35 +
  lessonDone / lessonTarget * 0.35 +
  inputDone / inputTarget * 0.15 +
  outputDone / outputTarget * 0.15
```

当 `dailyProgress >= 0.7` 时，视为完成今日有效学习。

### 弱点诊断

```text
knowledgeWeakness =
  wrongRate * 0.40 +
  overdueRate * 0.20 +
  lowMasteryRate * 0.25 +
  mockExamPenalty * 0.15
```

系统每天选择 weakness 最高的 3 个知识点进入补强任务。

## 15. 真题模拟设计

注意：App 不应直接复制未授权真题原文。系统应使用原创题、授权题或用户自有题库，题型与难度模拟 JLPT。

### 模拟题结构

```text
MockExam
├─ 文字词汇
│  ├─ 汉字读音
│  ├─ 表记
│  ├─ 文脉规定
│  └─ 近义表达
├─ 语法阅读
│  ├─ 文法形式判断
│  ├─ 句子排列
│  ├─ 文章语法
│  └─ 阅读理解
└─ 听力
   ├─ 课题理解
   ├─ 要点理解
   ├─ 概要理解
   ├─ 发话表达
   └─ 即时应答
```

### 模拟结果报告

```text
总分趋势
模块正确率
耗时
错题分布
弱点语法
弱点词汇
听力题型弱点
7 天复习建议
```
