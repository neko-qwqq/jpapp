export type JLPTLevel = "zero" | "n5" | "n4" | "n3";

export type AITeacherMode =
  | "teacher"
  | "grammarCorrection"
  | "pronunciation"
  | "exampleGeneration"
  | "jlptSpeaking"
  | "japaneseFriend"
  | "dailyPractice";

export interface Env {
  OPENAI_API_KEY: string;
  OPENAI_CHAT_MODEL: string;
  OPENAI_HIGH_QUALITY_MODEL: string;
  OPENAI_CLASSIFIER_MODEL: string;
  OPENAI_TRANSCRIBE_MODEL: string;
  OPENAI_TTS_MODEL: string;
  OPENAI_REALTIME_MODEL: string;
  AI_MEMORY_KV?: KVNamespace;
  AI_LOGS_DB?: D1Database;
}

export interface UserProfile {
  userId: string;
  nickname?: string;
  nativeLanguage: "zh-Hans" | "zh-Hant" | "en";
  currentLevel: JLPTLevel;
  targetLevel: JLPTLevel;
  dailyGoalMinutes: number;
}

export interface LearningContext {
  knownVocabularyIds: string[];
  knownGrammarIds: string[];
  weakKnowledgeIds: string[];
  recentMistakes: Array<{
    itemId: string;
    mistake: string;
    wrongCount: number;
  }>;
}

export interface RequestContext {
  requestId: string;
  userId: string;
  env: Env;
}

export interface SessionSummary {
  conversationId: string;
  summary: string;
  strengths: string[];
  weaknesses: string[];
  lastUpdatedAt: string;
}
