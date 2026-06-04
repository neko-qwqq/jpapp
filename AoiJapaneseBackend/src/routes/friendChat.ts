import type { RequestContext, JLPTLevel } from "../types";
import { readJson, jsonResponse } from "../utils/http";
import { assertLevel, assertString } from "../utils/validation";
import { createStructuredResponse } from "../openai/client";
import { baseSystemPrompt, levelPolicy } from "../prompts/base";
import { modePrompts } from "../prompts/modes";
import { chatResponseSchema } from "../schemas/aiSchemas";
import { loadSessionSummary, saveSessionSummary } from "../memory/sessionMemory";
import { logAIUsage } from "../utils/logging";

interface FriendChatRequest {
  conversationId: string;
  friendPersona?: "haru";
  userMessage: string;
  level: JLPTLevel;
  supportChinese?: boolean;
}

export async function handleFriendChat(request: Request, ctx: RequestContext): Promise<Response> {
  const body = await readJson<FriendChatRequest>(request);
  const conversationId = assertString(body.conversationId, "conversationId");
  const level = assertLevel(body.level);
  const sessionSummary = await loadSessionSummary(ctx, conversationId);

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
    schemaName: "aoi_friend_chat_response",
    schema: chatResponseSchema,
    instructions: [baseSystemPrompt, modePrompts.japaneseFriend, levelPolicy(level)].join("\n\n"),
    input: {
      conversationId,
      friendPersona: body.friendPersona ?? "haru",
      userMessage: assertString(body.userMessage, "userMessage"),
      level,
      supportChinese: body.supportChinese ?? true,
      sessionSummary
    }
  });

  await saveSessionSummary(ctx, conversationId, result.memoryUpdate);
  await logAIUsage(ctx, "/v1/ai/friend-chat", ctx.env.OPENAI_CHAT_MODEL, ctx.userId, { level });
  return jsonResponse(result);
}
