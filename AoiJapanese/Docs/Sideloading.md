# iPhone 侧载方案

侧载适合你想继续用原生 SwiftUI App，但暂时不想购买 Apple Developer Program 的情况。

## 现实限制

- 需要 Windows 电脑和 iPhone。
- 需要 Apple ID。
- 免费 Apple ID 签名通常需要定期刷新。
- 不是 App Store / TestFlight 正式分发方式。
- 侧载工具、Apple ID 登录和本机环境可能导致安装失败，需要排查。

如果只想最快在手机上用，优先选 PWA。

## 生成 IPA

仓库已经包含手动 workflow：

```text
.github/workflows/ios-sideload-ipa.yml
```

运行方式：

```text
GitHub -> Actions -> iOS Sideload IPA -> Run workflow
```

填写 Bundle ID，例如：

```text
com.nekoqwqq.aoijapanese
```

运行成功后下载 artifact：

```text
AoiJapanese-unsigned-sideload-IPA
```

里面会有：

```text
AoiJapanese-unsigned.ipa
```

## 用 Sideloadly 安装

适合 Windows 用户。

大致流程：

1. 安装 Sideloadly。
2. 安装 Apple 官方 iTunes / iCloud，确保电脑能识别 iPhone。
3. 用数据线连接 iPhone。
4. 打开 Sideloadly。
5. 选择 `AoiJapanese-unsigned.ipa`。
6. 输入 Apple ID。
7. 点击 Start。
8. 第一次安装后，在 iPhone 设置里信任开发者证书。

## 用 AltStore 安装

大致流程：

1. Windows 安装 AltServer。
2. 安装 Apple 官方 iTunes / iCloud。
3. 用数据线连接 iPhone。
4. AltServer 安装 AltStore 到 iPhone。
5. iPhone 打开 AltStore。
6. 导入 `AoiJapanese-unsigned.ipa`。
7. 用 Apple ID 签名安装。

## 和 PWA 的区别

PWA：

```text
最简单，Safari 打开网址即可。
不需要 IPA。
不需要 Apple ID 签名。
```

侧载：

```text
可以运行原生 SwiftUI App。
需要电脑、数据线、Apple ID 和定期刷新。
```
