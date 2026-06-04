import type { RequestContext, JLPTLevel } from "../types";
import { readJson, jsonResponse } from "../utils/http";
import { assertLevel, assertString, asStringArray } from "../utils/validation";
import { createStructuredResponse } from "../openai/client";
import { baseSystemPrompt, levelPolicy } from "../prompts/base";
import { modePrompts } from "../prompts/modes";
import { correctionResponseSchema } from "../schemas/aiSchemas";
import { logAIUsage } from "../utils/logging";

interface CorrectGrammarRequest {
  text: string;
  level: JLPTLevel;
  nativeLanguage?: string;
  explainInChinese?: boolean;
  knownGrammarIds?: string[];
}

export async function handleCorrectGrammar(request: Request, ctx: RequestContext): Promise<Response> {
  const body = await readJson<CorrectGrammarRequest>(request);
  const text = assertString(body.text, "text");
  const level = assertLevel(body.level);

  const result = await createStructuredResponse(ctx.env, {
    model: ctx.env.OPENAI_CHAT_MODEL,
    schemaName: "aoi_grammar_correction",
    schema: correctionResponseSchema,
    instructions: [baseSystemPrompt, modePrompts.grammarCorrection, levelPolicy(level)].join("\n\n"),
    input: {
      text,
      level,
      nativeLanguage: body.nativeLanguage ?? "zh-Hans",
      explainInChinese: body.explainInChinese ?? true,
      knownGrammarIds: asStringArray(body.knownGrammarIds)
    }
  });

  await logAIUsage(ctx, "/v1/ai/correct-grammar", ctx.env.OPENAI_CHAT_MODEL, ctx.userId, { level });
  return jsonResponse(result);
}
