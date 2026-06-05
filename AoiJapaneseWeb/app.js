const storageKey = "aoi-japanese-web-state-v1";

const defaultState = {
  activeScreen: "home",
  scene: "teacher",
  apiBaseUrl: "",
  aiCount: 3,
  streakDays: 12,
  n3Score: 76,
  voiceInterruptions: 0,
  chatMessages: [
    {
      role: "teacher",
      text: "こんにちは。今日は短い日语で話しましょう。\n\n你可以先说：水をください。",
      helper: "Aoi Sensei"
    }
  ],
  dailyPlanIndex: 0
};

const dailyPlans = [
  [
    { icon: "復", title: "复习 を 和 ください", detail: "完成 6 道请求句小题，稳定助词。" },
    { icon: "話", title: "便利店买水", detail: "用「水をください」完成一轮对话。" },
    { icon: "声", title: "跟读一句", detail: "お水をください。慢速读 3 遍。" }
  ],
  [
    { icon: "単", title: "复习生活动词", detail: "起きる、食べる、行く、見る。" },
    { icon: "文", title: "原因表达", detail: "用「〜から」说一个理由。" },
    { icon: "AI", title: "AI 输出", detail: "说一句今天的计划。" }
  ],
  [
    { icon: "聞", title: "听辨短句", detail: "区分 です / でした 的结尾。" },
    { icon: "読", title: "读一句 N4", detail: "週末は友達と映画を見ます。" },
    { icon: "話", title: "自由回答", detail: "用日语回答今天吃了什么。" }
  ]
];

const weaknessData = [
  { title: "连接表达", detail: "理由和结果之间还不够自然。", value: 58 },
  { title: "助词稳定度", detail: "长句里 に / で / を 容易混用。", value: 46 },
  { title: "发音节奏", detail: "长句中间停顿位置需要更清楚。", value: 62 }
];

const voiceScript = [
  { speaker: "Aoi", text: "こんにちは。今日は声で話しましょう。" },
  { speaker: "You", text: "最近、日本語を話す練習をしています。" },
  { speaker: "Aoi", text: "いいですね。どうして練習を始めたんですか。" }
];

let state = loadState();
let deferredInstallPrompt = null;
let recognition = null;
let voiceTimer = null;
let voiceActive = false;

const screenTitles = {
  home: "今日学习",
  chat: "AI 日语老师",
  n3: "N3 冲刺",
  voice: "语音陪练",
  profile: "学习设置"
};

document.addEventListener("DOMContentLoaded", () => {
  bindNavigation();
  bindChat();
  bindHome();
  bindN3();
  bindVoice();
  bindSettings();
  bindInstall();
  registerServiceWorker();
  renderAll();
});

function loadState() {
  try {
    const raw = localStorage.getItem(storageKey);
    if (!raw) return { ...defaultState };
    return { ...defaultState, ...JSON.parse(raw) };
  } catch {
    return { ...defaultState };
  }
}

function saveState() {
  localStorage.setItem(storageKey, JSON.stringify(state));
}

function renderAll() {
  renderScreen();
  renderHome();
  renderChat();
  renderN3();
  renderVoiceTranscript([]);
  renderSettings();
}

function bindNavigation() {
  document.querySelectorAll(".tab-item").forEach((button) => {
    button.addEventListener("click", () => {
      state.activeScreen = button.dataset.target;
      saveState();
      renderScreen();
    });
  });
}

function renderScreen() {
  document.querySelectorAll(".screen").forEach((screen) => {
    screen.classList.toggle("is-active", screen.dataset.screen === state.activeScreen);
  });

  document.querySelectorAll(".tab-item").forEach((button) => {
    button.classList.toggle("is-active", button.dataset.target === state.activeScreen);
  });

  document.getElementById("screen-title").textContent = screenTitles[state.activeScreen] || "Aoi Japanese";
  window.scrollTo({ top: 0, behavior: "smooth" });
}

function bindHome() {
  document.querySelector('[data-action="refresh-plan"]').addEventListener("click", () => {
    state.dailyPlanIndex = (state.dailyPlanIndex + 1) % dailyPlans.length;
    saveState();
    renderHome();
  });

  document.querySelectorAll("[data-speak]").forEach((button) => {
    button.addEventListener("click", () => speakText(button.dataset.speak));
  });
}

function renderHome() {
  document.getElementById("streak-days").textContent = `${state.streakDays} 天`;
  document.getElementById("ai-count").textContent = `${state.aiCount} 次`;

  const list = document.getElementById("daily-practice-list");
  list.innerHTML = "";
  dailyPlans[state.dailyPlanIndex].forEach((item) => {
    const row = document.createElement("article");
    row.className = "practice-item";
    row.innerHTML = `
      <div class="practice-icon">${escapeHtml(item.icon)}</div>
      <div>
        <strong>${escapeHtml(item.title)}</strong>
        <p>${escapeHtml(item.detail)}</p>
      </div>
    `;
    list.appendChild(row);
  });
}

function bindChat() {
  document.querySelectorAll(".scene-chip").forEach((button) => {
    button.addEventListener("click", () => {
      state.scene = button.dataset.scene;
      saveState();
      renderSceneChips();
    });
  });

  document.getElementById("chat-form").addEventListener("submit", async (event) => {
    event.preventDefault();
    const input = document.getElementById("chat-input");
    const text = input.value.trim();
    if (!text) return;

    input.value = "";
    pushMessage({ role: "user", text, helper: "You" });
    renderChat();

    const reply = await createTeacherReply(text);
    pushMessage(reply);
    state.aiCount += 1;
    saveState();
    renderChat();
    renderHome();
  });

  document.getElementById("voice-input-button").addEventListener("click", startSpeechInput);
}

function renderSceneChips() {
  document.querySelectorAll(".scene-chip").forEach((button) => {
    button.classList.toggle("is-selected", button.dataset.scene === state.scene);
  });
}

function renderChat() {
  renderSceneChips();
  const log = document.getElementById("chat-log");
  log.innerHTML = "";

  state.chatMessages.forEach((message) => {
    const row = document.createElement("article");
    row.className = `message ${message.role === "user" ? "user" : "teacher"}`;
    row.innerHTML = `
      <div class="bubble">
        ${escapeHtml(message.text)}
        <span class="helper">${escapeHtml(message.helper || "")}</span>
      </div>
    `;
    log.appendChild(row);
  });

  requestAnimationFrame(() => {
    log.scrollTop = log.scrollHeight;
  });
}

function pushMessage(message) {
  state.chatMessages.push(message);
  if (state.chatMessages.length > 18) {
    state.chatMessages = state.chatMessages.slice(-18);
  }
  saveState();
}

async function createTeacherReply(text) {
  if (state.apiBaseUrl) {
    try {
      const response = await fetch(`${state.apiBaseUrl.replace(/\/$/, "")}/v1/ai/chat`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-Aoi-User-ID": "pwa-user"
        },
        body: JSON.stringify({
          conversationId: "pwa-default",
          mode: state.scene === "friend" ? "japaneseFriend" : "teacher",
          scene: state.scene,
          userMessage: text,
          userProfile: {
            userId: "pwa-user",
            nickname: "Aoi 学习者",
            nativeLanguage: "zh-Hans",
            currentLevel: "n5",
            targetLevel: "n3",
            dailyGoalMinutes: 15
          },
          learningContext: {
            knownVocabularyIds: ["n5_word_water"],
            knownGrammarIds: ["n5_request_kudasai"],
            weakKnowledgeIds: ["n5_particle_wo"],
            recentMistakes: []
          },
          responseOptions: {
            includeChineseExplanation: true,
            includeFurigana: true,
            maxNewWords: 2,
            maxGrammarAboveLevel: 0
          }
        })
      });

      if (response.ok) {
        const data = await response.json();
        return {
          role: "teacher",
          text: `${data.reply.ja}\n${data.reply.kana}\n\n中文：${data.reply.zh}`,
          helper: data.correction?.encouragementZh || "Aoi Sensei"
        };
      }
    } catch {
      return mockReply(text, true);
    }
  }

  return mockReply(text, false);
}

function mockReply(text, backendFailed) {
  const prefix = backendFailed ? "后端暂时连接失败，先用本地老师回复。\n\n" : "";
  const normalized = text.trim();

  if (state.scene === "friend") {
    return {
      role: "teacher",
      text: `${prefix}おつかれさま。今日も少し話せていいね。\n\n中文：像朋友一样说的话，可以用「おつかれさま」表示辛苦了。`,
      helper: "Haru"
    };
  }

  if (normalized.includes("がください")) {
    return {
      role: "teacher",
      text: `${prefix}意味は伝わります。自然に言うなら「水をください」です。\n\n中文：「ください」前面的请求对象通常用 を，不用 が。`,
      helper: "很好，先把一个助词稳定下来。"
    };
  }

  if (normalized.includes("よう") || normalized.includes("きっかけ")) {
    return {
      role: "teacher",
      text: `${prefix}いいですね。N3 らしい表現です。\n\n中文：你已经在用 N3 连接表达了，下一步补一句结果会更完整。`,
      helper: "可以接：その結果、少し自信が持てるようになりました。"
    };
  }

  if (normalized.includes("ください")) {
    return {
      role: "teacher",
      text: `${prefix}いいですね。「${normalized}」は自然です。\n\n中文：这句可以直接用于点单或购物。更礼貌一点可以加「お」。`,
      helper: "下一句：ありがとうございます。"
    };
  }

  return {
    role: "teacher",
    text: `${prefix}意味はわかります。短く自然にすると「日本語を勉強しています」です。\n\n中文：先说短句，准确度会更高。`,
    helper: "一歩ずつで大丈夫です。"
  };
}

function bindN3() {
  document.querySelector('[data-action="sample-answer"]').addEventListener("click", () => {
    document.getElementById("n3-answer").value = "最近、朝早く起きるようにしています。日本語を勉強したいと思ったのがきっかけです。その結果、毎日少し自信が持てるようになりました。";
  });

  document.querySelector('[data-action="generate-report"]').addEventListener("click", renderWeaknessList);
  document.querySelector('[data-action="score-n3"]').addEventListener("click", scoreN3Answer);
}

function renderN3() {
  document.getElementById("n3-score").textContent = state.n3Score;
  renderWeaknessList();
}

function renderWeaknessList() {
  const list = document.getElementById("weakness-list");
  list.innerHTML = "";

  weaknessData.forEach((item) => {
    const card = document.createElement("article");
    card.className = "weakness-item";
    card.innerHTML = `
      <strong>${escapeHtml(item.title)} ${item.value}%</strong>
      <div class="progress-track"><i style="--value: ${item.value}%"></i></div>
      <p>${escapeHtml(item.detail)}</p>
    `;
    list.appendChild(card);
  });
}

function scoreN3Answer() {
  const answer = document.getElementById("n3-answer").value.trim();
  const feedback = document.getElementById("n3-feedback");
  let score = 72;
  const tips = [];

  if (answer.includes("よう")) score += 8;
  else tips.push("加入「〜ようにしています」表达正在养成的习惯。");

  if (answer.includes("きっかけ")) score += 7;
  else tips.push("加入「〜がきっかけです」说明原因。");

  if (answer.includes("結果")) score += 6;
  else tips.push("最后用「その結果」补结果。");

  state.n3Score = Math.min(96, score);
  saveState();
  renderN3();

  const advice = tips.length ? tips.join("\n") : "结构完整。下一步练发音停顿，每一句中间只停一次。";
  feedback.classList.add("is-visible");
  feedback.innerHTML = `
    <p class="jp-text">採点：${state.n3Score} / 100</p>
    <p class="zh-text">${escapeHtml(advice)}</p>
  `;
}

function bindVoice() {
  document.getElementById("voice-start-button").addEventListener("click", toggleVoicePractice);
  document.getElementById("voice-interrupt-button").addEventListener("click", interruptVoicePractice);
}

function toggleVoicePractice() {
  if (voiceActive) {
    stopVoicePractice();
  } else {
    startVoicePractice();
  }
}

function startVoicePractice() {
  clearTimeout(voiceTimer);
  voiceActive = true;
  const orb = document.getElementById("voice-orb");
  const status = document.getElementById("voice-status");
  const startButton = document.getElementById("voice-start-button");

  orb.classList.add("is-active");
  status.textContent = "正在听你说";
  startButton.textContent = "结束";
  document.getElementById("latency-value").textContent = "238ms";
  renderVoiceTranscript([voiceScript[0]]);

  voiceTimer = setTimeout(() => {
    status.textContent = "老师回应中";
    renderVoiceTranscript(voiceScript);
  }, 780);
}

function stopVoicePractice() {
  clearTimeout(voiceTimer);
  voiceActive = false;
  document.getElementById("voice-orb").classList.remove("is-active");
  document.getElementById("voice-status").textContent = "未连接";
  document.getElementById("voice-start-button").textContent = "开始";
  document.getElementById("latency-value").textContent = "--";
}

function interruptVoicePractice() {
  clearTimeout(voiceTimer);
  state.voiceInterruptions += 1;
  saveState();
  document.getElementById("interrupt-value").textContent = state.voiceInterruptions;
  document.getElementById("latency-value").textContent = "164ms";
  document.getElementById("voice-status").textContent = "已实时打断";
  renderVoiceTranscript([
    ...voiceScript,
    { speaker: "You", text: "先生、もう一度ゆっくりお願いします。" },
    { speaker: "Aoi", text: "もちろんです。ゆっくり言いますね。" }
  ]);
}

function renderVoiceTranscript(lines) {
  document.getElementById("interrupt-value").textContent = state.voiceInterruptions;
  const list = document.getElementById("voice-transcript");
  list.innerHTML = "";

  if (!lines.length) {
    const empty = document.createElement("article");
    empty.className = "transcript-line";
    empty.innerHTML = "<strong>Aoi</strong><p>声で話す準備ができています。</p>";
    list.appendChild(empty);
    return;
  }

  lines.forEach((line) => {
    const row = document.createElement("article");
    row.className = "transcript-line";
    row.innerHTML = `<strong>${escapeHtml(line.speaker)}</strong><p>${escapeHtml(line.text)}</p>`;
    list.appendChild(row);
  });
}

function bindSettings() {
  document.querySelector('[data-action="save-settings"]').addEventListener("click", () => {
    state.apiBaseUrl = document.getElementById("api-base-url").value.trim();
    saveState();
    pushMessage({
      role: "teacher",
      text: state.apiBaseUrl ? "后端地址已保存。下一轮会尝试连接真实 AI。" : "后端地址已清空。当前使用本地 Mock 老师。",
      helper: "Settings"
    });
    state.activeScreen = "chat";
    saveState();
    renderScreen();
    renderChat();
  });
}

function renderSettings() {
  document.getElementById("api-base-url").value = state.apiBaseUrl;
}

function startSpeechInput() {
  const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
  if (!SpeechRecognition) {
    pushMessage({
      role: "teacher",
      text: "这个浏览器暂时不支持语音转写。你可以先用文字输入。",
      helper: "Voice Input"
    });
    renderChat();
    return;
  }

  if (recognition) {
    recognition.stop();
    recognition = null;
    return;
  }

  recognition = new SpeechRecognition();
  recognition.lang = "ja-JP";
  recognition.interimResults = false;
  recognition.maxAlternatives = 1;
  recognition.onresult = (event) => {
    const text = event.results[0][0].transcript;
    document.getElementById("chat-input").value = text;
  };
  recognition.onend = () => {
    recognition = null;
  };
  recognition.start();
}

function speakText(text) {
  if (!window.speechSynthesis) return;
  const utterance = new SpeechSynthesisUtterance(text);
  utterance.lang = "ja-JP";
  utterance.rate = 0.88;
  window.speechSynthesis.cancel();
  window.speechSynthesis.speak(utterance);
}

function bindInstall() {
  window.addEventListener("beforeinstallprompt", (event) => {
    event.preventDefault();
    deferredInstallPrompt = event;
  });

  document.getElementById("install-button").addEventListener("click", async () => {
    if (deferredInstallPrompt) {
      deferredInstallPrompt.prompt();
      await deferredInstallPrompt.userChoice;
      deferredInstallPrompt = null;
      return;
    }

    alert("iPhone 请在 Safari 里点击分享按钮，然后选择「添加到主屏幕」。");
  });
}

function registerServiceWorker() {
  if ("serviceWorker" in navigator) {
    navigator.serviceWorker.register("./sw.js").catch(() => {});
  }
}

function escapeHtml(value) {
  return String(value)
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#039;");
}
