import type { Env } from "./types";
import { createRequestContext } from "./utils/auth";
import { errorResponse, jsonResponse } from "./utils/http";
import { enforceDailyQuota } from "./quota/limits";
import { handleChat } from "./routes/chat";
import { handleCorrectGrammar } from "./routes/correctGrammar";
import { handlePronunciationCheck } from "./routes/pronunciation";
import { handleGenerateExamples } from "./routes/examples";
import { handleSpeakingAnswer, handleSpeakingStart } from "./routes/speakingSimulation";
import { handleFriendChat } from "./routes/friendChat";
import { handleDailyPractice } from "./routes/dailyPractice";
import { handleTTS } from "./routes/tts";
import { handleRealtimeSession } from "./routes/realtimeSession";

type RouteHandler = (request: Request, ctx: ReturnType<typeof createRequestContext>) => Promise<Response>;

const routes: Record<string, RouteHandler> = {
  "POST /v1/ai/chat": handleChat,
  "POST /v1/ai/correct-grammar": handleCorrectGrammar,
  "POST /v1/ai/pronunciation-check": handlePronunciationCheck,
  "POST /v1/ai/generate-examples": handleGenerateExamples,
  "POST /v1/ai/jlpt-speaking-simulation/start": handleSpeakingStart,
  "POST /v1/ai/jlpt-speaking-simulation/answer": handleSpeakingAnswer,
  "POST /v1/ai/friend-chat": handleFriendChat,
  "POST /v1/ai/daily-practice": handleDailyPractice,
  "POST /v1/ai/tts": handleTTS,
  "POST /v1/ai/realtime/session": handleRealtimeSession
};

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    if (request.method === "OPTIONS") {
      return jsonResponse({ ok: true });
    }

    const url = new URL(request.url);
    if (request.method === "GET" && url.pathname === "/health") {
      return jsonResponse({ ok: true, service: "aoi-japanese-backend" });
    }

    const routeKey = `${request.method} ${url.pathname}`;
    const handler = routes[routeKey];
    if (!handler) {
      return errorResponse(404, `Route not found: ${routeKey}`);
    }

    if (!env.OPENAI_API_KEY) {
      return errorResponse(500, "OPENAI_API_KEY is not configured");
    }

    const ctx = createRequestContext(request, env);

    try {
      await enforceDailyQuota(ctx, url.pathname);
      return await handler(request, ctx);
    } catch (error) {
      const message = error instanceof Error ? error.message : "Unknown error";
      const status = message.includes("quota") ? 429 : 400;
      return errorResponse(status, message);
    }
  }
};
