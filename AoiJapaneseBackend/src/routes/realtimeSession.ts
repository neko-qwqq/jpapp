import type { RequestContext, JLPTLevel } from "../types";
import { createRealtimeClientSecret } from "../openai/client";
import { baseSystemPrompt, levelPolicy } from "../prompts/base";
import { readJson, jsonResponse } from "../utils/http";
import { logAIUsage } from "../utils/logging";
import { assertLevel } from "../utils/validation";

interface RealtimeSessionRequest {
  level?: JLPTLevel;
  voice?: string;
  mode?: "teacher" | "friend" | "n3Sprint";
}

const allowedVoices = new Set(["alloy", "ash", "ballad", "coral", "echo", "marin", "sage", "shimmer", "verse"]);

export async function handleRealtimeSession(request: Request, ctx: RequestContext): Promise<Response> {
  const body = await readJson<RealtimeSessionRequest>(request);
  const level = body.level ? assertLevel(body.level) : "n5";
  const voice = normalizeVoice(body.voice);
  const mode = body.mode ?? "teacher";
  const safetyIdentifier = await hashUserId(ctx.userId);

  const clientSecret = await createRealtimeClientSecret(ctx.env, {
    voice,
    safetyIdentifier,
    instructions: buildRealtimeInstructions(level, mode)
  });

  await logAIUsage(ctx, "/v1/ai/realtime/session", ctx.env.OPENAI_REALTIME_MODEL, ctx.userId, {
    level,
    mode,
    voice,
    expiresAt: clientSecret.expires_at
  });

  return jsonResponse({
    realtime: {
      clientSecret: clientSecret.value,
      expiresAt: clientSecret.expires_at ?? null,
      model: clientSecret.session?.model ?? ctx.env.OPENAI_REALTIME_MODEL,
      sessionId: clientSecret.session?.id ?? null,
      connectionUrl: "https://api.openai.com/v1/realtime/calls",
      eventChannel: "oai-events"
    },
    voice,
    mode,
    level,
    noticeZh: "这是 AI 生成语音。客户端应使用临时 client secret 建立 Realtime 连接。"
  });
}

function normalizeVoice(value: unknown): string {
  if (typeof value !== "string") return "marin";
  const trimmed = value.trim();
  return allowedVoices.has(trimmed) ? trimmed : "marin";
}

function buildRealtimeInstructions(level: JLPTLevel, mode: string): string {
  const modeInstruction = mode === "friend"
    ? "当前模式：日本朋友 Haru。轻松自然地陪用户聊天，每轮只附带一个很小的学习点。"
    : mode === "n3Sprint"
      ? "当前模式：N3 低延迟口语陪练。连续追问，但每次只问一个问题；允许用户打断，打断后先回应最新问题。"
      : "当前模式：Realtime AI 日语老师。像真实老师一样陪用户口语练习。";

  return [
    baseSystemPrompt,
    levelPolicy(level),
    modeInstruction,
    "Realtime 语音规则：",
    "- 回复要短，适合语音播放。",
    "- 先给一句自然日语，再用一句中文说明。",
    "- 用户打断时立即停止当前展开，回应用户最新内容。",
    "- 每轮最多纠正一个最重要问题。",
    "- 不要声称自己是真人老师。"
  ].join("\n\n");
}

async function hashUserId(userId: string): Promise<string> {
  const bytes = new TextEncoder().encode(userId);
  const digest = await crypto.subtle.digest("SHA-256", bytes);
  return Array.from(new Uint8Array(digest))
    .map((byte) => byte.toString(16).padStart(2, "0"))
    .join("");
}
