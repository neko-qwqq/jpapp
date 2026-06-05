# Aoi Japanese Web

这是 Aoi Japanese 的 PWA 版本。

## 运行

直接用浏览器打开：

```text
AoiJapaneseWeb/index.html
```

如果要测试 PWA 安装和离线缓存，需要用本地 HTTP 服务或 GitHub Pages。

## GitHub Pages

手动运行：

```text
Actions -> Deploy PWA -> Run workflow
```

部署成功后，iPhone Safari 打开 Pages URL，再选择：

```text
分享 -> 添加到主屏幕
```

## 后端

默认使用本地 Mock AI。进入 PWA 的“我的”页面可以填入后端地址：

```text
https://your-worker.example.workers.dev
```

填入后，AI 对话会优先尝试调用：

```text
POST /v1/ai/chat
```
