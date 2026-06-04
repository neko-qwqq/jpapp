import type { JLPTLevel } from "../types";

const levels = new Set<JLPTLevel>(["zero", "n5", "n4", "n3"]);

export function assertString(value: unknown, field: string): string {
  if (typeof value !== "string" || value.trim().length === 0) {
    throw new Error(`${field} is required`);
  }
  return value.trim();
}

export function assertLevel(value: unknown, field = "level"): JLPTLevel {
  if (typeof value !== "string" || !levels.has(value as JLPTLevel)) {
    throw new Error(`${field} must be one of zero, n5, n4, n3`);
  }
  return value as JLPTLevel;
}

export function asStringArray(value: unknown): string[] {
  if (!Array.isArray(value)) return [];
  return value.filter((item): item is string => typeof item === "string");
}
