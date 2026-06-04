import type { RequestContext, SessionSummary } from "../types";

export async function loadSessionSummary(
  ctx: RequestContext,
  conversationId: string
): Promise<SessionSummary | null> {
  const raw = await ctx.env.AI_MEMORY_KV?.get(memoryKey(ctx.userId, conversationId));
  if (!raw) return null;
  return JSON.parse(raw) as SessionSummary;
}

export async function saveSessionSummary(
  ctx: RequestContext,
  conversationId: string,
  patch: {
    summaryDelta: string;
    newWeaknesses: string[];
    newStrengths: string[];
  }
): Promise<void> {
  const current = await loadSessionSummary(ctx, conversationId);
  const next: SessionSummary = {
    conversationId,
    summary: [current?.summary, patch.summaryDelta].filter(Boolean).join("\n").slice(-2400),
    strengths: unique([...(current?.strengths ?? []), ...patch.newStrengths]).slice(-20),
    weaknesses: unique([...(current?.weaknesses ?? []), ...patch.newWeaknesses]).slice(-20),
    lastUpdatedAt: new Date().toISOString()
  };

  await ctx.env.AI_MEMORY_KV?.put(memoryKey(ctx.userId, conversationId), JSON.stringify(next), {
    expirationTtl: 60 * 60 * 24 * 30
  });
}

function memoryKey(userId: string, conversationId: string): string {
  return `memory:session:${userId}:${conversationId}`;
}

function unique(values: string[]): string[] {
  return [...new Set(values.filter(Boolean))];
}
