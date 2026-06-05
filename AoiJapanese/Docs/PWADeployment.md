# PWA 手机上使用方案

PWA 是目前最简单的手机使用方案。

## 优点

- 不需要 Mac。
- 不需要 Apple Developer Program。
- 不需要 TestFlight。
- iPhone 可以用 Safari 打开并添加到主屏幕。
- 当前版本不需要后端，适合纯自用学习。

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
4. 主屏幕会出现“日语自习”图标。

## 当前功能

PWA 已包含：

- 练习中心、补漏顺序和总进度。
- 五十音：平假名、片假名、浊音、半浊音、拗音。
- N5：语法、词汇主题、汉字。
- N4：语法、词汇主题、汉字。
- N3：语法、词汇主题、汉字。
- 搜索、展开卡片、播放例句、掌握标记。
- 五十音 20 题综合测验：读音、拼读、平假名书写、片假名书写、听音。
- N5/N4/N3 20 题综合测验：语法、词汇、汉字、输入、听力、跟读。
- 综合随机 30 题和语音专项 20 题。
- 离线缓存。

## 限制

当前 PWA 是自用学习和练习工具，不接 AI，也不需要 OpenAI API。

语音朗读使用浏览器 `speechSynthesis`。口述跟读使用浏览器语音识别能力；如果当前 Safari 不支持，会显示手动输入备用。

如果浏览器曾经缓存过旧版页面，打开 Pages URL 后刷新一次；iPhone Safari 仍显示旧版时，删除主屏幕图标后重新添加。
