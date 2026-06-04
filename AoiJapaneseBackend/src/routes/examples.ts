import type { RequestContext, JLPTLevel } from "../types";
import { readJson, jsonResponse } from "../utils/http";
import { assertLevel, assertString, asStringArray } from "../utils/validation";
import { createStructuredResponse } from "../openai/client";
import { baseSystemPrompt, levelPolicy } from "../prompts/base";
import { modePrompts } from "../prompts/modes";
import { examplesResponseSchema } from "../schemas/aiSchemas";
import { logAIUsage } from "../utils/logging";

interface GenerateExamplesRequest {
  targetType: "vocabulary" | "grammar";
  targetId: string;
  targetText?: string;
  level: JLPTLevel;
  count: number;
  scene?: string;
  knownVocabularyIds?: string[];
  knownGrammarIds?: string[];
}

export async function handleGenerateExamples(request: Request, ctx: RequestContext): Promise<Response> {
  const body = await readJson<GenerateExamplesRequest>(request);
  const level = assertLevel(body.level);
  const count = Math.max(1, Math.min(Number(body.count || 5), 10));

  const result = await createStructuredResponse(ctx.env, {
    model: ctx.env.OPENAI_CHAT_MODEL,
    schemaName: "aoi_generated_examples",
    schema: examplesResponseSchema,
    instructions: [baseSystemPrompt, modePrompts.exampleGeneration, levelPolicy(level)].join("\n\n"),
    input: {
      targetType: body.targetType,
      targetId: assertString(body.targetId, "targetId"),
      targetText: body.targetText,
      level,
      count,
      scene: body.scene ?? "daily_life",
      knownVocabularyIds: asStringArray(body.knownVocabularyIds),
      knownGrammarIds: asStringArray(body.knownGrammarIds)
    }
  });

  await logAIUsage(ctx, "/v1/ai/generate-examples", ctx.env.OPENAI_CHAT_MODEL, ctx.userId, { level, count });
  return jsonResponse(result);
}
