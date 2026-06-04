export function jsonResponse(data: unknown, init: ResponseInit = {}): Response {
  return new Response(JSON.stringify(data), {
    ...init,
    headers: {
      "Content-Type": "application/json; charset=utf-8",
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Headers": "Authorization, Content-Type, X-Aoi-User-ID",
      "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
      ...(init.headers ?? {})
    }
  });
}

export function errorResponse(status: number, message: string, details?: unknown): Response {
  return jsonResponse({ error: { message, details } }, { status });
}

export async function readJson<T>(request: Request): Promise<T> {
  const contentType = request.headers.get("Content-Type") ?? "";
  if (!contentType.includes("application/json")) {
    throw new Error("Content-Type must be application/json");
  }
  return (await request.json()) as T;
}
