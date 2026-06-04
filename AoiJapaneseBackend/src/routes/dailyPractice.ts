import type { RequestContext, JLPTLevel } from "../types";
import { readJson, jsonResponse } from "../utils/http";
import { assertLevel, assertString, asStringArray } from "../utils/validation";
import { createStructuredResponse } from "../openai/client";
import { baseSystemPrompt, levelPolicy } from "../prompts/base";
import { modePrompts } from "../prompts/modes";
import { dailyPracticeSchema } from "../schemas/aiSchemas";
import { logAIUsage } from "../utils/logging";

interface DailyPracticeRequest {
  userId: string;
  date: string;
  currentLevel: JLPTLevel;
  dailyGoalMinutes: number;
  dueReviewIds: string[];
  weakKnowledgeIds: string[];
  recentLessonIds: string[];
}

export async function handleDailyPractice(request: Request, ctx: RequestContext): Promise<Response> {
  const body = await readJson<DailyPracticeRequest>(request);
  const currentLevel = assertLevel(body.currentLevel, "currentLevel");

  const result = await createStructuredResponse(ctx.env, {
    model: ctx.env.OPENAI_CHAT_MODEL,
    schemaName: "aoi_daily_practice",
    schema: dailyPracticeSchema,
    instructions: [baseSystemPrompt, modePrompts.dailyPractice, levelPolicy(currentLevel)].join("\n\n"),
    input: {
      userId: assertString(body.userId, "userId"),
      date: body.date,
      currentLevel,
      dailyGoalMinutes: Math.max(5, Math.min(Number(body.dailyGoalMinutes || 15), 30)),
      dueReviewIds: asStringArray(body.dueReviewIds),
      weakKnowledgeIds: asStringArray(body.weakKnowledgeIds),
      recentLessonIds: asStringArray(body.recentLessonIds)
    }
  });

  await logAIUsage(ctx, "/v1/ai/daily-practice", ctx.env.OPENAI_CHAT_MODEL, ctx.userId, { currentLevel });
  return jsonResponse(result);
}
