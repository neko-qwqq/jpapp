# PWA 手机上使用方案

PWA 是目前最简单的手机使用方案。

## 优点

- 不需要 Mac。
- 不需要 Apple Developer Program。
- 不需要 TestFlight。
- iPhone 可以用 Safari 打开并添加到主屏幕。
- 后续可以接同一个 Cloudflare Worker 后端。

## 部署到 GitHub Pages

仓库已经包含：

```text
.github/workflows/pwa-pages.yml
```

运行方式：

```text
GitHub -> Actions -> Deploy PWA -> Run workflow
```

成功后会得到 GitHub Pages URL，通常类似：

```text
https://neko-qwqq.github.io/jpapp/
```

## iPhone 添加到主屏幕

1. 用 iPhone Safari 打开 Pages URL。
2. 点击分享按钮。
3. 选择“添加到主屏幕”。
4. 主屏幕会出现 Aoi Japanese 图标。

## 当前功能

PWA 已包含：

- 首页学习进度。
- AI 日语老师聊天。
- 日本朋友 Haru 模式。
- N3 冲刺和弱点报告。
- 语音陪练 UI。
- 可选后端 API Base URL 设置。
- 离线缓存。

## 限制

当前 PWA 使用本地 Mock AI。要使用真实 AI，需要先部署 `AoiJapaneseBackend`，再在 PWA “我的”页面填入 Worker 地址。

语音输入依赖浏览器支持。iPhone Safari 对网页语音识别能力有限，真实 Realtime 语音仍建议后续接 WebRTC 或保留原生 iOS 版本。
