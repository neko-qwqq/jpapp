# Aoi Japanese

一款 SwiftUI iPhone 日语学习 App 原型，面向零基础到 JLPT N3 的碎片化学习。

## 技术栈

- iOS 18+
- SwiftUI
- Observation
- MVVM
- Mock Data
- Xcode project

## 运行方式

1. 使用 Xcode 打开 `AoiJapanese.xcodeproj`
2. 选择 iPhone 模拟器
3. 运行 `AoiJapanese` Target

## TestFlight

云端签名和 TestFlight 上传流程见：

```text
Docs/TestFlightDeployment.md
```

## 手机使用方案

不想购买 Apple Developer Program 时，优先使用 PWA：

```text
Docs/PWADeployment.md
```

原生 App 侧载备用方案：

```text
Docs/Sideloading.md
```

## 当前功能

- 首页：今日自习顺序、总进度、五十音和 N5-N3 快速入口
- 单词：等级筛选、搜索、收藏、单词卡片翻转
- 课程：零基础、N5、N4、N3 学习路径和课程详情
- PWA：五十音、N5、N4、N3 语法/词汇/汉字、自用搜索、小测验、本地掌握进度
- 我的：学习统计、成就徽章、设置入口
