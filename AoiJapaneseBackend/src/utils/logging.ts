import type { RequestContext } from "../types";

export async function logAIUsage(
  ctx: RequestContext,
  route: string,
  model: string,
  userId: string,
  metadata: Record<string, unknown>
): Promise<void> {
  if (!ctx.env.AI_LOGS_DB) return;

  await ctx.env.AI_LOGS_DB.prepare(
    `CREATE TABLE IF NOT EXISTS ai_usage_logs (
      id TEXT PRIMARY KEY,
      user_id TEXT NOT NULL,
      route TEXT NOT NULL,
      model TEXT NOT NULL,
      metadata TEXT NOT NULL,
      created_at TEXT NOT NULL
    )`
  ).run();

  await ctx.env.AI_LOGS_DB.prepare(
    `INSERT INTO ai_usage_logs (id, user_id, route, model, metadata, created_at)
     VALUES (?, ?, ?, ?, ?, ?)`
  )
    .bind(ctx.requestId, userId, route, model, JSON.stringify(metadata), new Date().toISOString())
    .run();
}
