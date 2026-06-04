export const chatResponseSchema = {
  type: "object",
  additionalProperties: false,
  required: ["reply", "correction", "learningSignal", "suggestedReplies", "memoryUpdate"],
  properties: {
    reply: {
      type: "object",
      additionalProperties: false,
      required: ["ja", "kana", "zh"],
      properties: {
        ja: { type: "string" },
        kana: { type: "string" },
        zh: { type: "string" }
      }
    },
    correction: {
      type: "object",
      additionalProperties: false,
      required: ["hasError", "correctedJa", "explanationZh", "encouragementZh"],
      properties: {
        hasError: { type: "boolean" },
        correctedJa: { type: "string" },
        explanationZh: { type: "string" },
        encouragementZh: { type: "string" }
      }
    },
    learningSignal: {
      type: "object",
      additionalProperties: false,
      required: ["detectedLevel", "usedVocabularyIds", "usedGrammarIds", "recommendedReviewIds", "xp"],
      properties: {
        detectedLevel: { type: "string", enum: ["zero", "n5", "n4", "n3"] },
        usedVocabularyIds: { type: "array", items: { type: "string" } },
        usedGrammarIds: { type: "array", items: { type: "string" } },
        recommendedReviewIds: { type: "array", items: { type: "string" } },
        xp: { type: "integer" }
      }
    },
    suggestedReplies: {
      type: "array",
      minItems: 1,
      maxItems: 3,
      items: { type: "string" }
    },
    memoryUpdate: {
      type: "object",
      additionalProperties: false,
      required: ["summaryDelta", "newWeaknesses", "newStrengths"],
      properties: {
        summaryDelta: { type: "string" },
        newWeaknesses: { type: "array", items: { type: "string" } },
        newStrengths: { type: "array", items: { type: "string" } }
      }
    }
  }
} as const;

export const correctionResponseSchema = {
  type: "object",
  additionalProperties: false,
  required: ["original", "corrected", "severity", "errors", "shortFeedbackZh", "encouragementZh"],
  properties: {
    original: { type: "string" },
    corrected: { type: "string" },
    severity: { type: "string", enum: ["none", "low", "medium", "high"] },
    errors: {
      type: "array",
      items: {
        type: "object",
        additionalProperties: false,
        required: ["type", "wrongText", "correctText", "explanationZh"],
        properties: {
          type: { type: "string" },
          wrongText: { type: "string" },
          correctText: { type: "string" },
          explanationZh: { type: "string" }
        }
      }
    },
    shortFeedbackZh: { type: "string" },
    encouragementZh: { type: "string" }
  }
} as const;

export const pronunciationResponseSchema = {
  type: "object",
  additionalProperties: false,
  required: ["transcript", "targetTextJa", "score", "feedback", "issues", "retryPrompt"],
  properties: {
    transcript: { type: "string" },
    targetTextJa: { type: "string" },
    score: { type: "integer" },
    feedback: {
      type: "object",
      additionalProperties: false,
      required: ["zh", "ja"],
      properties: {
        zh: { type: "string" },
        ja: { type: "string" }
      }
    },
    issues: {
      type: "array",
      items: {
        type: "object",
        additionalProperties: false,
        required: ["type", "target", "detected", "tipZh"],
        properties: {
          type: { type: "string" },
          target: { type: "string" },
          detected: { type: "string" },
          tipZh: { type: "string" }
        }
      }
    },
    retryPrompt: { type: "string" }
  }
} as const;

export const examplesResponseSchema = {
  type: "object",
  additionalProperties: false,
  required: ["examples"],
  properties: {
    examples: {
      type: "array",
      minItems: 1,
      maxItems: 10,
      items: {
        type: "object",
        additionalProperties: false,
        required: ["ja", "kana", "zh", "usedVocabularyIds", "usedGrammarIds"],
        properties: {
          ja: { type: "string" },
          kana: { type: "string" },
          zh: { type: "string" },
          usedVocabularyIds: { type: "array", items: { type: "string" } },
          usedGrammarIds: { type: "array", items: { type: "string" } }
        }
      }
    }
  }
} as const;

export const speakingStartSchema = {
  type: "object",
  additionalProperties: false,
  required: ["simulationId", "openingMessage", "rubric"],
  properties: {
    simulationId: { type: "string" },
    openingMessage: {
      type: "object",
      additionalProperties: false,
      required: ["ja", "kana", "zh"],
      properties: {
        ja: { type: "string" },
        kana: { type: "string" },
        zh: { type: "string" }
      }
    },
    rubric: { type: "array", items: { type: "string" } }
  }
} as const;

export const speakingAnswerSchema = {
  type: "object",
  additionalProperties: false,
  required: ["teacherReply", "turnFeedback"],
  properties: {
    teacherReply: {
      type: "object",
      additionalProperties: false,
      required: ["ja", "kana", "zh"],
      properties: {
        ja: { type: "string" },
        kana: { type: "string" },
        zh: { type: "string" }
      }
    },
    turnFeedback: {
      type: "object",
      additionalProperties: false,
      required: ["score", "goodPointZh", "fixZh", "betterAnswerJa"],
      properties: {
        score: { type: "integer" },
        goodPointZh: { type: "string" },
        fixZh: { type: "string" },
        betterAnswerJa: { type: "string" }
      }
    }
  }
} as const;

export const dailyPracticeSchema = {
  type: "object",
  additionalProperties: false,
  required: ["plan"],
  properties: {
    plan: {
      type: "object",
      additionalProperties: false,
      required: ["title", "estimatedMinutes", "tasks"],
      properties: {
        title: { type: "string" },
        estimatedMinutes: { type: "integer" },
        tasks: {
          type: "array",
          minItems: 4,
          maxItems: 6,
          items: {
            type: "object",
            additionalProperties: false,
            required: ["type", "title", "minutes", "description"],
            properties: {
              type: { type: "string", enum: ["review", "lesson", "listening", "reading", "conversation", "shadowing", "quiz"] },
              title: { type: "string" },
              minutes: { type: "integer" },
              description: { type: "string" }
            }
          }
        }
      }
    }
  }
} as const;
