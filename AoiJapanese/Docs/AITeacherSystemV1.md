# Aoi AI 日语老师系统 V1

本文档定义 Aoi Japanese 的 AI 日语老师系统 V1。它不是概念稿，而是后端、Prompt、Schema、记忆、等级、成本和部署的实现规格。对应可运行后端项目位于 `AoiJapaneseBackend/`。

## 1. 目标

让用户像和真人日本老师聊天一样学习日语，同时满足教育 App 的可控性：

- 支持文本聊天。
- 支持语音输入和发音反馈。
- 支持日语、假名、中文解释。
- 支持鼓励式反馈。
- 根据用户 JLPT 等级控制难度。
- 产生可写入复习系统的学习信号。
- iOS 客户端不直接调用 OpenAI，不保存 OpenAI API Key。

## 2. 系统架构

```text
iOS SwiftUI App
  ├─ AIChatView / future PronunciationView
  ├─ AIService
  └─ Local Study Stores
        │
        ▼
Cloudflare Workers: AoiJapaneseBackend
  ├─ routes/
  │   ├─ chat
  │   ├─ correctGrammar
  │   ├─ pronunciation
  │   ├─ examples
  │   ├─ speakingSimulation
  │   ├─ friendChat
  │   ├─ dailyPractice
  │   └─ tts
  ├─ prompts/
  ├─ schemas/
  ├─ memory/
  ├─ quota/
  └─ openai/
        │
        ▼
OpenAI API
  ├─ Responses API
  ├─ Audio Transcriptions API
  └─ Audio Speech API

Cloudflare KV
  └─ Session summary, quota counters

Cloudflare D1
  └─ Usage logs, cost audit, AI learning events
```

## 3. OpenAI API 选型

V1 使用以下 API：

```text
文本对话 / 纠错 / 例句 / 每日练习：
  Responses API

结构化返回：
  Responses API + JSON Schema Structured Outputs

语音输入：
  Audio Transcriptions API

语音输出：
  Audio Speech API

低延迟实时语音：
  V2 使用 Realtime API
```

服务端环境变量：

```text
OPENAI_API_KEY=...
OPENAI_CHAT_MODEL=gpt-4.1-mini
OPENAI_HIGH_QUALITY_MODEL=gpt-4.1
OPENAI_CLASSIFIER_MODEL=gpt-4.1-nano
OPENAI_TRANSCRIBE_MODEL=gpt-4o-mini-transcribe
OPENAI_TTS_MODEL=gpt-4o-mini-tts
```

说明：

- 模型名只放在服务端环境变量，不写死在 iOS 客户端。
- V1 用 `gpt-4.1-mini` 承担大多数文本任务，用 `gpt-4.1` 承担 N3 口语模拟和复杂分析。
- 如后续官方推荐模型变化，只更新后端环境变量和少量 Prompt 策略。

## 4. API 设计

所有 API 前缀：

```text
https://api.example.com/v1/ai
```

认证：

```http
Authorization: Bearer <app_user_token>
X-Aoi-User-ID: <user_id>
```

生产环境必须替换 `src/utils/auth.ts` 中的 MVP 鉴权逻辑。

### 4.1 文本 AI 老师

```http
POST /v1/ai/chat
Content-Type: application/json
```

Request:

```json
{
  "conversationId": "conv_20260604_001",
  "mode": "teacher",
  "scene": "convenience_store",
  "userMessage": "水をください",
  "userProfile": {
    "userId": "user_001",
    "nickname": "Aoi 学习者",
    "nativeLanguage": "zh-Hans",
    "currentLevel": "n5",
    "targetLevel": "n3",
    "dailyGoalMinutes": 15
  },
  "learningContext": {
    "knownVocabularyIds": ["n5_word_water"],
    "knownGrammarIds": ["n5_request_kudasai"],
    "weakKnowledgeIds": ["n5_particle_wo"],
    "recentMistakes": [
      {
        "itemId": "n5_particle_wo",
        "mistake": "把 を 写成 が",
        "wrongCount": 2
      }
    ]
  },
  "responseOptions": {
    "includeChineseExplanation": true,
    "includeFurigana": true,
    "maxNewWords": 2,
    "maxGrammarAboveLevel": 0
  }
}
```

Response:

```json
{
  "conversationId": "conv_20260604_001",
  "messageId": "msg_001",
  "mode": "teacher",
  "reply": {
    "ja": "いいですね。「水をください」は自然です。",
    "kana": "いいですね。「みずをください」はしぜんです。",
    "zh": "很好，这句话自然，适合便利店或点餐场景。"
  },
  "correction": {
    "hasError": false,
    "correctedJa": "水をください。",
    "explanationZh": "を 表示请求的对象。",
    "encouragementZh": "这句已经可以直接使用。下一步可以学更礼貌的「お水をください」。"
  },
  "learningSignal": {
    "detectedLevel": "n5",
    "usedVocabularyIds": ["n5_word_water"],
    "usedGrammarIds": ["n5_request_kudasai"],
    "recommendedReviewIds": ["n5_particle_wo"],
    "xp": 10
  },
  "suggestedReplies": [
    "お水をください。",
    "コーヒーをください。",
    "ありがとうございます。"
  ],
  "memoryUpdate": {
    "summaryDelta": "用户能正确使用 N5 请求句「水をください」。",
    "newWeaknesses": [],
    "newStrengths": ["n5_request_kudasai"]
  }
}
```

### 4.2 语法纠错

```http
POST /v1/ai/correct-grammar
```

Request:

```json
{
  "text": "私は水がください",
  "level": "n5",
  "nativeLanguage": "zh-Hans",
  "explainInChinese": true,
  "knownGrammarIds": ["n5_request_kudasai"]
}
```

Response:

```json
{
  "original": "私は水がください",
  "corrected": "水をください。",
  "severity": "medium",
  "errors": [
    {
      "type": "particle",
      "wrongText": "が",
      "correctText": "を",
      "explanationZh": "「ください」前面的请求对象通常用 を。"
    }
  ],
  "shortFeedbackZh": "意思能明白，但助词要改成 を。",
  "encouragementZh": "你已经知道要表达“请给我水”，下一步把助词稳定下来。"
}
```

### 4.3 发音纠正

```http
POST /v1/ai/pronunciation-check
Content-Type: multipart/form-data
```

Form:

```text
audio: audio/m4a
targetTextJa: 水をください。
targetKana: みずをください。
level: n5
```

处理流程：

```text
audio -> Audio Transcriptions API -> transcript
transcript + targetTextJa + targetKana -> Responses API -> structured pronunciation feedback
```

Response:

```json
{
  "transcript": "みずください",
  "targetTextJa": "水をください。",
  "score": 78,
  "feedback": {
    "zh": "整体清楚，但 を 漏掉了。初学阶段建议轻轻读出来。",
    "ja": "よくできました。次は「を」を少し入れてみましょう。"
  },
  "issues": [
    {
      "type": "missing_particle",
      "target": "を",
      "detected": "",
      "tipZh": "を 在口语里很轻，但练习时建议保留。"
    }
  ],
  "retryPrompt": "みずをください"
}
```

### 4.4 生成例句

```http
POST /v1/ai/generate-examples
```

Request:

```json
{
  "targetType": "grammar",
  "targetId": "n5_request_kudasai",
  "targetText": "名词 をください",
  "level": "n5",
  "count": 5,
  "scene": "cafe",
  "knownVocabularyIds": ["n5_word_water", "n5_word_coffee"],
  "knownGrammarIds": ["n5_request_kudasai"]
}
```

Response:

```json
{
  "examples": [
    {
      "ja": "コーヒーをください。",
      "kana": "コーヒーをください。",
      "zh": "请给我咖啡。",
      "usedVocabularyIds": ["n5_word_coffee"],
      "usedGrammarIds": ["n5_request_kudasai"]
    }
  ]
}
```

### 4.5 App 内原创 JLPT 风格口语模拟

注意：JLPT 官方考试没有口语面试。本功能只能命名为“App 内原创 JLPT 风格口语训练”。

```http
POST /v1/ai/jlpt-speaking-simulation/start
```

Request:

```json
{
  "level": "n3",
  "topic": "weekend_plan",
  "durationMinutes": 5,
  "nativeLanguage": "zh-Hans"
}
```

Response:

```json
{
  "simulationId": "sim_abc",
  "openingMessage": {
    "ja": "週末は何をする予定ですか。",
    "kana": "しゅうまつは なにをする よていですか。",
    "zh": "周末你打算做什么？"
  },
  "rubric": ["任务完成度", "语法准确度", "词汇使用", "自然度", "连贯性"]
}
```

回答：

```http
POST /v1/ai/jlpt-speaking-simulation/answer
```

Request:

```json
{
  "simulationId": "sim_abc",
  "answerText": "週末は友達と映画を見に行くつもりです。",
  "turnIndex": 1,
  "level": "n3",
  "topic": "weekend_plan"
}
```

### 4.6 日本朋友 Haru

```http
POST /v1/ai/friend-chat
```

Request:

```json
{
  "conversationId": "friend_001",
  "friendPersona": "haru",
  "userMessage": "今日は疲れた",
  "level": "n4",
  "supportChinese": true
}
```

返回结构与 `/chat` 相同，但 Prompt 会降低纠错密度，以自然对话为主。

### 4.7 每日练习

```http
POST /v1/ai/daily-practice
```

Request:

```json
{
  "userId": "user_001",
  "date": "2026-06-04",
  "currentLevel": "n5",
  "dailyGoalMinutes": 15,
  "dueReviewIds": ["n5_word_water", "n5_particle_wo"],
  "weakKnowledgeIds": ["n5_particle_wo"],
  "recentLessonIds": ["n5_052"]
}
```

Response:

```json
{
  "plan": {
    "title": "便利店请求表达",
    "estimatedMinutes": 15,
    "tasks": [
      {
        "type": "review",
        "title": "复习 を 和 ください",
        "minutes": 4,
        "description": "完成 6 道助词和请求句小题。"
      },
      {
        "type": "lesson",
        "title": "水をください",
        "minutes": 5,
        "description": "学习一个便利店请求表达。"
      },
      {
        "type": "listening",
        "title": "听一段便利店短对话",
        "minutes": 3,
        "description": "听 2 遍并选择店员说了什么。"
      },
      {
        "type": "shadowing",
        "title": "跟读一句",
        "minutes": 3,
        "description": "跟读「お水をください」。"
      }
    ]
  }
}
```

### 4.8 TTS

```http
POST /v1/ai/tts
```

Request:

```json
{
  "text": "お水をください。",
  "voice": "alloy"
}
```

Response:

```text
audio/mpeg
```

UI 必须标注：声音由 AI 生成。

## 5. Prompt 设计

Prompt 分层：

```text
Base System Prompt
  ├─ 老师身份
  ├─ 教学原则
  ├─ 安全边界
  └─ 输出规则

Mode Prompt
  ├─ teacher
  ├─ grammarCorrection
  ├─ pronunciation
  ├─ exampleGeneration
  ├─ jlptSpeaking
  ├─ japaneseFriend
  └─ dailyPractice

Level Policy
  ├─ zero
  ├─ n5
  ├─ n4
  └─ n3

User Context
  ├─ userProfile
  ├─ learningContext
  ├─ sessionSummary
  └─ responseOptions
```

Base Prompt 已在后端实现：

```text
src/prompts/base.ts
```

核心原则：

- 每轮最多纠错 1-2 个点。
- 优先纠正影响理解的错误。
- 保留用户原意。
- 给更自然表达时，不把原句判定为完全失败。
- 输出严格 JSON，不输出 Markdown。

## 6. 会话记忆方案

记忆分 4 层。

### 6.1 Short-Term Memory

范围：

```text
最近 6-10 轮对话
```

用途：

```text
保持上下文连续
避免重复问同一问题
```

存储：

```text
iOS 本地 message store
```

### 6.2 Session Summary

范围：

```text
当前会话摘要
```

存储：

```text
Cloudflare KV
key = memory:session:<userId>:<conversationId>
ttl = 30 days
```

结构：

```json
{
  "conversationId": "conv_001",
  "summary": "用户正在练习便利店请求表达。",
  "strengths": ["n5_request_kudasai"],
  "weaknesses": ["n5_particle_wo"],
  "lastUpdatedAt": "2026-06-04T08:00:00Z"
}
```

### 6.3 Learning Memory

范围：

```text
长期学习画像
```

结构：

```json
{
  "userId": "user_001",
  "currentLevel": "n5",
  "targetLevel": "n3",
  "preferredScenes": ["convenience_store", "cafe"],
  "stableStrengths": ["n5_request_kudasai"],
  "stableWeaknesses": ["n5_particle_wo"],
  "tonePreference": "gentle",
  "explanationLanguage": "zh-Hans"
}
```

V1 可先由 App 本地保存，V2 接 SwiftData / CloudKit。

### 6.4 Review Memory

范围：

```text
可进入复习系统的知识点
```

结构：

```json
{
  "itemId": "n5_particle_wo",
  "source": "ai_chat",
  "reason": "用户在请求表达中漏用 を",
  "priority": 0.82,
  "nextReviewAt": "2026-06-05T08:00:00Z"
}
```

写入规则：

```text
每轮对话：
  解析 learningSignal

每 5 轮：
  生成 session summary

同类错误 >= 2：
  写入 stableWeaknesses
  写入 Review Memory

连续正确 >= 3：
  写入 stableStrengths
  降低相关弱点优先级
```

## 7. 用户等级系统

等级同时控制：

- 词汇范围
- 语法范围
- 句长
- 中文解释比例
- 纠错强度
- 建议回复难度

### Zero

```text
允许：假名、问候、极短句
句长：1-5 个日语词
中文解释比例：70%
纠错：只纠正假名、发音、基础问候
```

### N5

```text
允许：です/ます、基础助词、基础动词、い/な形容词、存在句、ください
句长：5-12 个日语词
中文解释比例：50%
纠错：每轮最多 1 个语法点
```

### N4

```text
允许：て形、ない形、た形、可能形、授受、条件、原因、比较
句长：8-18 个日语词
中文解释比例：35%
纠错：可同时纠正语法和自然度
```

### N3

```text
允许：被动、使役、敬语入门、推量、复杂连接、观点表达
句长：12-28 个日语词
中文解释比例：25%
纠错：关注自然度、连贯性、表达丰富度
```

自动调难：

```text
recentAccuracy = 最近 20 个 AI 互动任务正确率
hintUsageRate = 提示点击次数 / 回合数
frustrationSignal = 放弃次数 + 重复错误 + 过短回复

if recentAccuracy >= 0.85 and hintUsageRate < 0.25:
    difficulty += 1

if recentAccuracy < 0.60 or frustrationSignal > threshold:
    difficulty -= 1

if user manually selects "轻松一点":
    difficulty -= 1 for next 3 sessions
```

## 8. AI 人设设计

### 8.1 Aoi Sensei

```text
身份：温柔的日语老师，懂中文，熟悉 JLPT N5-N3 路径
性格：安静、耐心、清晰
使用场景：默认 AI 老师、语法纠错、每日练习
教学风格：先肯定，再指出一个小改进
```

口头风格：

```text
いいですね。
大丈夫です。
一歩ずつでいいですよ。
```

### 8.2 Haru

```text
身份：住在东京的日本朋友
性格：轻松、亲切、自然
使用场景：日常闲聊、兴趣话题、生活表达
教学方式：聊天为主，纠错为辅
```

### 8.3 Mori Sensei

```text
身份：App 内原创口语模拟老师
性格：严谨但不冷酷
使用场景：N4/N3 输出训练、考前冲刺
教学方式：连续追问、评分、给改进答案
```

### 8.4 Mika Coach

```text
身份：发音教练
专注：假名、长音、促音、拗音、语调
使用场景：跟读、听辨、发音纠错
教学方式：只抓最重要的一个发音点
```

## 9. Token 节省方案

### 9.1 Prompt 缓存友好

固定内容放前面：

```text
Base System Prompt
Mode Prompt
JSON Schema
Level Policy
```

变量放后面：

```text
userMessage
sessionSummary
learningContext
responseOptions
```

### 9.2 不传完整词库

错误做法：

```text
每次传 800 个 N5 单词
```

正确做法：

```text
当前课程相关词汇 10-20 个
最近学过词汇 20 个
薄弱词汇 10 个
```

### 9.3 摘要替代历史全文

```text
最近 6-10 轮：保留原文
更早内容：压缩成 session summary
长期画像：只保留 strengths / weaknesses / preferences
```

### 9.4 模型分流

```text
gpt-4.1-nano：
  难度分类、标签提取、是否需要纠错

gpt-4.1-mini：
  大多数文本对话、例句、每日练习

gpt-4.1：
  N3 口语模拟、复杂语法解释、阶段报告
```

### 9.5 缓存高频结果

缓存对象：

```text
N5 常见语法例句
单词例句
每日练习模板
口语模拟开场
TTS 音频
```

缓存 key：

```text
hash(level + mode + targetId + scene + nativeLanguage)
```

## 10. 低成本部署方案

V1 部署：

```text
Cloudflare Workers
  ├─ API 代理
  ├─ Prompt Builder
  ├─ OpenAI 调用
  ├─ 限流
  └─ Structured Outputs 校验

Cloudflare KV
  ├─ session summary
  ├─ prompt cache
  └─ quota counters

Cloudflare D1
  ├─ usage logs
  ├─ user quota
  ├─ mistake summary
  └─ AI daily counters

Cloudflare R2
  └─ TTS 音频缓存，可选
```

免费用户额度：

```text
每日：
  文本 AI 对话 10 轮
  语法纠错 5 次
  例句生成 5 次
  语音输入 3 次
  TTS 播放 10 次

每月：
  口语模拟 2 次
```

Plus 用户额度：

```text
每日：
  文本 AI 对话 100 轮
  语法纠错 50 次
  例句生成 50 次
  语音输入 30 次
  TTS 播放 100 次

每月：
  口语模拟 20 次
  N3 冲刺报告 4 次
```

降级策略：

```text
额度不足：
  返回本地 Mock 老师回复模板

OpenAI 请求失败：
  返回“老师暂时离线”，保存用户输入，稍后重试

高质量模型超预算：
  自动降级到 mini 模型

语音服务超预算：
  保留文本聊天，关闭 TTS
```

## 11. 当前代码映射

```text
AoiJapaneseBackend/
  package.json
  wrangler.toml
  src/index.ts
  src/openai/client.ts
  src/prompts/base.ts
  src/prompts/modes.ts
  src/schemas/aiSchemas.ts
  src/memory/sessionMemory.ts
  src/quota/limits.ts
  src/routes/chat.ts
  src/routes/correctGrammar.ts
  src/routes/pronunciation.ts
  src/routes/examples.ts
  src/routes/speakingSimulation.ts
  src/routes/friendChat.ts
  src/routes/dailyPractice.ts
  src/routes/tts.ts
```

## 12. 开发顺序

Phase 1：文本 AI 老师

```text
/v1/ai/chat
/v1/ai/correct-grammar
Structured Outputs
SwiftUI AI 对话页接真实 API
基础额度限制
```

Phase 2：每日练习与记忆

```text
/v1/ai/daily-practice
session summary
weak points 写入复习队列
AI 学习报告
```

Phase 3：语音

```text
iOS 录音
transcription
pronunciation-check
TTS
TTS 缓存
```

Phase 4：N3 冲刺

```text
JLPT 风格口语模拟
N3 弱点报告
全真模拟讲解
订阅权益
```

Phase 5：Realtime

```text
Realtime API
低延迟语音陪练
实时打断
语音老师体验优化
```

## 13. 官方文档参考

- OpenAI Responses API: https://platform.openai.com/docs/guides/responses
- OpenAI Structured Outputs: https://platform.openai.com/docs/guides/structured-outputs
- OpenAI Speech to Text: https://platform.openai.com/docs/guides/speech-to-text
- OpenAI Text to Speech: https://platform.openai.com/docs/guides/text-to-speech
- OpenAI Realtime API: https://platform.openai.com/docs/guides/realtime
- OpenAI Cost Optimization / Prompt Caching: https://platform.openai.com/docs/guides/prompt-caching
