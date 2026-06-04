import type { RequestContext } from "../types";
import { jsonResponse } from "../utils/http";
import { assertLevel, assertString } from "../utils/validation";
import { createStructuredResponse, transcribeAudio } from "../openai/client";
import { baseSystemPrompt, levelPolicy } from "../prompts/base";
import { modePrompts } from "../prompts/modes";
import { pronunciationResponseSchema } from "../schemas/aiSchemas";
import { logAIUsage } from "../utils/logging";

export async function handlePronunciationCheck(request: Request, ctx: RequestContext): Promise<Response> {
  const form = await request.formData();
  const audio = form.get("audio");
  if (!isAudioBlob(audio)) {
    throw new Error("audio file is required");
  }

  const targetTextJa = assertString(form.get("targetTextJa"), "targetTextJa");
  const targetKana = assertString(form.get("targetKana"), "targetKana");
  const level = assertLevel(form.get("level"));
  const transcript = await transcribeAudio(ctx.env, audio, "ja");

  const result = await createStructuredResponse(ctx.env, {
    model: ctx.env.OPENAI_CHAT_MODEL,
    schemaName: "aoi_pronunciation_feedback",
    schema: pronunciationResponseSchema,
    instructions: [baseSystemPrompt, modePrompts.pronunciation, levelPolicy(level)].join("\n\n"),
    input: {
      targetTextJa,
      targetKana,
      transcript,
      level
    }
  });

  await logAIUsage(ctx, "/v1/ai/pronunciation-check", ctx.env.OPENAI_CHAT_MODEL, ctx.userId, {
    level,
    transcriptLength: transcript.length
  });
  return jsonResponse(result);
}

function isAudioBlob(value: unknown): value is Blob {
  return typeof value === "object" && value !== null && "arrayBuffer" in value && "type" in value;
}
