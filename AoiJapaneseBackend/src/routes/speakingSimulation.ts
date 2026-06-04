import type { RequestContext, JLPTLevel } from "../types";
import { readJson, jsonResponse } from "../utils/http";
import { assertLevel, assertString } from "../utils/validation";
import { createStructuredResponse } from "../openai/client";
import { baseSystemPrompt, levelPolicy } from "../prompts/base";
import { modePrompts } from "../prompts/modes";
import { speakingAnswerSchema, speakingStartSchema } from "../schemas/aiSchemas";
import { logAIUsage } from "../utils/logging";

interface StartRequest {
  level: JLPTLevel;
  topic: string;
  durationMinutes: number;
  nativeLanguage?: string;
}

interface AnswerRequest {
  simulationId: string;
  answerText: string;
  turnIndex: number;
  level: JLPTLevel;
  topic?: string;
}

export async function handleSpeakingStart(request: Request, ctx: RequestContext): Promise<Response> {
  const body = await readJson<StartRequest>(request);
  const level = assertLevel(body.level);

  const result = await createStructuredResponse(ctx.env, {
    model: ctx.env.OPENAI_HIGH_QUALITY_MODEL,
    schemaName: "aoi_speaking_start",
    schema: speakingStartSchema,
    instructions: [baseSystemPrompt, modePrompts.jlptSpeaking, levelPolicy(level)].join("\n\n"),
    input: {
      level,
      topic: assertString(body.topic, "topic"),
      durationMinutes: Math.max(3, Math.min(Number(body.durationMinutes || 5), 15)),
      nativeLanguage: body.nativeLanguage ?? "zh-Hans"
    }
  });

  await logAIUsage(ctx, "/v1/ai/jlpt-speaking-simulation/start", ctx.env.OPENAI_HIGH_QUALITY_MODEL, ctx.userId, { level });
  return jsonResponse(result);
}

export async function handleSpeakingAnswer(request: Request, ctx: RequestContext): Promise<Response> {
  const body = await readJson<AnswerRequest>(request);
  const level = assertLevel(body.level);

  const result = await createStructuredResponse(ctx.env, {
    model: ctx.env.OPENAI_HIGH_QUALITY_MODEL,
    schemaName: "aoi_speaking_answer",
    schema: speakingAnswerSchema,
    instructions: [baseSystemPrompt, modePrompts.jlptSpeaking, levelPolicy(level)].join("\n\n"),
    input: {
      simulationId: assertString(body.simulationId, "simulationId"),
      answerText: assertString(body.answerText, "answerText"),
      turnIndex: Number(body.turnIndex || 1),
      level,
      topic: body.topic
    }
  });

  await logAIUsage(ctx, "/v1/ai/jlpt-speaking-simulation/answer", ctx.env.OPENAI_HIGH_QUALITY_MODEL, ctx.userId, { level });
  return jsonResponse(result);
}
