import type { Env } from "../types";

type JsonSchema = Record<string, unknown>;

export async function createStructuredResponse<T>(
  env: Env,
  options: {
    model: string;
    schemaName: string;
    schema: JsonSchema;
    instructions: string;
    input: unknown;
    temperature?: number;
  }
): Promise<T> {
  const response = await fetch("https://api.openai.com/v1/responses", {
    method: "POST",
    headers: {
      Authorization: `Bearer ${env.OPENAI_API_KEY}`,
      "Content-Type": "application/json"
    },
    body: JSON.stringify({
      model: options.model,
      instructions: options.instructions,
      input: JSON.stringify(options.input),
      temperature: options.temperature ?? 0.4,
      text: {
        format: {
          type: "json_schema",
          name: options.schemaName,
          strict: true,
          schema: options.schema
        }
      }
    })
  });

  if (!response.ok) {
    const errorText = await response.text();
    throw new Error(`OpenAI Responses API failed: ${response.status} ${errorText}`);
  }

  const data = await response.json() as { output_text?: string; output?: Array<Record<string, unknown>> };
  const text = extractOutputText(data);
  return JSON.parse(text) as T;
}

export async function transcribeAudio(
  env: Env,
  audio: Blob,
  language = "ja"
): Promise<string> {
  const form = new FormData();
  form.set("model", env.OPENAI_TRANSCRIBE_MODEL);
  form.set("file", audio);
  form.set("language", language);

  const response = await fetch("https://api.openai.com/v1/audio/transcriptions", {
    method: "POST",
    headers: {
      Authorization: `Bearer ${env.OPENAI_API_KEY}`
    },
    body: form
  });

  if (!response.ok) {
    const errorText = await response.text();
    throw new Error(`OpenAI transcription failed: ${response.status} ${errorText}`);
  }

  const data = await response.json() as { text?: string };
  return data.text ?? "";
}

export async function synthesizeSpeech(
  env: Env,
  text: string,
  voice = "alloy"
): Promise<Response> {
  const response = await fetch("https://api.openai.com/v1/audio/speech", {
    method: "POST",
    headers: {
      Authorization: `Bearer ${env.OPENAI_API_KEY}`,
      "Content-Type": "application/json"
    },
    body: JSON.stringify({
      model: env.OPENAI_TTS_MODEL,
      voice,
      input: text,
      format: "mp3"
    })
  });

  if (!response.ok) {
    const errorText = await response.text();
    throw new Error(`OpenAI speech failed: ${response.status} ${errorText}`);
  }

  return new Response(response.body, {
    headers: {
      "Content-Type": "audio/mpeg",
      "Access-Control-Allow-Origin": "*"
    }
  });
}

function extractOutputText(data: { output_text?: string; output?: Array<Record<string, unknown>> }): string {
  if (typeof data.output_text === "string") return data.output_text;

  for (const item of data.output ?? []) {
    const content = item.content;
    if (!Array.isArray(content)) continue;
    for (const part of content) {
      if (typeof part === "object" && part && "text" in part && typeof part.text === "string") {
        return part.text;
      }
    }
  }

  throw new Error("OpenAI response did not include output text");
}
