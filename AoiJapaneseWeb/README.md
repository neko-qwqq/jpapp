# 日语自习 PWA

这是纯自用版日语学习 PWA，重点放在：

- 五十音：平假名、片假名、浊音、半浊音、拗音
- N5：基础句型、词汇主题、汉字
- N4：生活表达、词汇主题、汉字
- N3：表达升级、词汇主题、汉字
- 五十音综合测验：读音选择、假名识别、平假名书写、片假名书写、罗马音拼写、听音选择，每轮 20 题
- N5/N4/N3 语法测验：每轮 20 题
- 本地进度：掌握标记、测验记录、搜索记录都保存在当前浏览器

## 运行

直接打开：

```text
AoiJapaneseWeb/index.html
```

或用本地静态服务：

```text
python -m http.server 4173 --directory AoiJapaneseWeb
```

然后访问：

```text
http://127.0.0.1:4173/
```

## 部署

GitHub Actions 里运行：

```text
Deploy PWA -> Run workflow
```

部署成功后，iPhone Safari 打开 Pages URL：

```text
https://neko-qwqq.github.io/jpapp/
```

然后选择：

```text
分享 -> 添加到主屏幕
```

## 说明

当前版本不依赖后端，也不需要 OpenAI API。它是一个离线优先的自学笔记和练习工具。
