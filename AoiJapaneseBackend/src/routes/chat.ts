import type { RequestContext, UserProfile, LearningContext } from "../types";
import { readJson, jsonResponse } from "../utils/http";
import { assertString } from "../utils/validation";
import { createStructuredResponse } from "../openai/client";
import { baseSystemPrompt, levelPolicy } from "../prompts/base";
import { modePrompts } from "../prompts/modes";
import { chatResponseSchema } from "../schemas/aiSchemas";
import { loadSessionSummary, saveSessionSummary } from "../memory/sessionMemory";
import { logAIUsage } from "../utils/logging";

interface ChatRequest {
  conversationId: string;
  mode?: "teacher";
  scene: string;
  userMessage: string;
  userProfile: UserProfile;
  learningContext: LearningContext;
  responseOptions?: {
    includeChineseExplanation?: boolean;
    includeFurigana?: boolean;
    maxNewWords?: number;
    maxGrammarAboveLevel?: number;
  };
}

export async function handleChat(request: Request, ctx: RequestContext): Promise<Response> {
  const body = await readJson<ChatRequest>(request);
  const conversationId = assertString(body.conversationId, "conversationId");
  const userMessage = assertString(body.userMessage, "userMessage");
  const userProfile = body.userProfile;
  const sessionSummary = await loadSessionSummary(ctx, conversationId);

  const instructions = [
    baseSystemPrompt,
    modePrompts.teacher,
    levelPolicy(userProfile.currentLevel)
  ].join("\n\n");

  const result = await createStructuredResponse<{
    reply: { ja: string; kana: string; zh: string };
    correction: { hasError: boolean; correctedJa: string; explanationZh: string; encouragementZh: string };
    learningSignal: {
      detectedLevel: string;
      usedVocabularyIds: string[];
      usedGrammarIds: string[];
      recommendedReviewIds: string[];
      xp: number;
    };
    suggestedReplies: string[];
    memoryUpdate: { summaryDelta: string; newWeaknesses: string[]; newStrengths: string[] };
  }>(ctx.env, {
    model: ctx.env.OPENAI_CHAT_MODEL,
    schemaName: "aoi_chat_response",
    schema: chatResponseSchema,
    instructions,
    input: {
      conversationId,
      scene: body.scene,
      userMessage,
      userProfile,
      learningContext: body.learningContext,
      responseOptions: body.responseOptions,
      sessionSummary
    }
  });

  await saveSessionSummary(ctx, conversationId, result.memoryUpdate);
  await logAIUsage(ctx, "/v1/ai/chat", ctx.env.OPENAI_CHAT_MODEL, ctx.userId, {
    conversationId,
    scene: body.scene,
    level: userProfile.currentLevel
  });

  return jsonResponse({
    conversationId,
    messageId: crypto.randomUUID(),
    mode: "teacher",
    ...result
  });
}
