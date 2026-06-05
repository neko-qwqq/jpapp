# Aoi Japanese Backend

Cloudflare Workers backend for the Aoi Japanese AI teacher system.

## Endpoints

- `POST /v1/ai/chat`
- `POST /v1/ai/correct-grammar`
- `POST /v1/ai/pronunciation-check`
- `POST /v1/ai/generate-examples`
- `POST /v1/ai/jlpt-speaking-simulation/start`
- `POST /v1/ai/jlpt-speaking-simulation/answer`
- `POST /v1/ai/friend-chat`
- `POST /v1/ai/daily-practice`
- `POST /v1/ai/tts`
- `POST /v1/ai/realtime/session`

### Realtime session

`POST /v1/ai/realtime/session` creates an OpenAI Realtime ephemeral client secret.
The iOS app must call this backend endpoint first, then use the returned `clientSecret`
to connect to the Realtime API. Do not place a standard OpenAI API key in the iOS app.

## Local Run

```bash
npm install
npm run dev
```

Set the OpenAI key before running:

```bash
wrangler secret put OPENAI_API_KEY
```

For local development, create `.dev.vars`:

```text
OPENAI_API_KEY=sk-...
```

## Auth

MVP auth accepts either:

- `Authorization: Bearer <app-user-token>`
- `X-Aoi-User-ID: <user-id>`

Replace `src/utils/auth.ts` with real app auth verification before production.
