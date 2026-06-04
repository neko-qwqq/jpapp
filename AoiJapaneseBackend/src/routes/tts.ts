import type { RequestContext } from "../types";
import { readJson } from "../utils/http";
import { assertString } from "../utils/validation";
import { synthesizeSpeech } from "../openai/client";
import { logAIUsage } from "../utils/logging";

interface TTSRequest {
  text: string;
  voice?: string;
}

export async function handleTTS(request: Request, ctx: RequestContext): Promise<Response> {
  const body = await readJson<TTSRequest>(request);
  const text = assertString(body.text, "text");
  const response = await synthesizeSpeech(ctx.env, text, body.voice ?? "alloy");
  await logAIUsage(ctx, "/v1/ai/tts", ctx.env.OPENAI_TTS_MODEL, ctx.userId, { chars: text.length });
  return response;
}
