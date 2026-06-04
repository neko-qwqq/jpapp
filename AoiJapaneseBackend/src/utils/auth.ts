import type { RequestContext, Env } from "../types";

export function createRequestContext(request: Request, env: Env): RequestContext {
  const requestId = crypto.randomUUID();
  const userFromHeader = request.headers.get("X-Aoi-User-ID")?.trim();
  const bearer = request.headers.get("Authorization")?.replace(/^Bearer\s+/i, "").trim();
  const userId = userFromHeader || bearer || "anonymous";

  return {
    requestId,
    userId,
    env
  };
}
