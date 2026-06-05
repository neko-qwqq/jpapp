import type { RequestContext } from "../types";

const dailyLimits: Record<string, number> = {
  "/v1/ai/chat": 100,
  "/v1/ai/correct-grammar": 50,
  "/v1/ai/pronunciation-check": 30,
  "/v1/ai/generate-examples": 50,
  "/v1/ai/jlpt-speaking-simulation/start": 20,
  "/v1/ai/jlpt-speaking-simulation/answer": 100,
  "/v1/ai/friend-chat": 100,
  "/v1/ai/daily-practice": 20,
  "/v1/ai/tts": 100,
  "/v1/ai/realtime/session": 20
};

export async function enforceDailyQuota(ctx: RequestContext, route: string): Promise<void> {
  const limit = dailyLimits[route] ?? 50;
  const kv = ctx.env.AI_MEMORY_KV;
  if (!kv) return;

  const dateKey = new Date().toISOString().slice(0, 10);
  const key = `quota:${ctx.userId}:${route}:${dateKey}`;
  const current = Number((await kv.get(key)) ?? "0");
  if (current >= limit) {
    throw new Error(`Daily quota exceeded for ${route}`);
  }

  await kv.put(key, String(current + 1), { expirationTtl: 60 * 60 * 48 });
}
