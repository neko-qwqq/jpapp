# TestFlight 部署说明

本文档说明如何把 Aoi Japanese 从 GitHub Actions 打包并上传到 TestFlight。

## 当前状态

仓库已经包含两个 iOS 工作流：

- `.github/workflows/ios-build.yml`：自动跑模拟器构建和截图，不需要 Apple 账号。
- `.github/workflows/ios-testflight.yml`：手动触发 Release 归档、签名、导出 IPA，并可上传 TestFlight。

TestFlight 工作流使用 Xcode 自动签名，不要求你在本机准备 `.p12` 证书或 `.mobileprovision` 文件。

## 前置条件

需要：

1. Apple Developer Program 账号。
2. App Store Connect 中创建 App。
3. 一个唯一 Bundle ID，例如：

```text
com.nekoqwqq.aoijapanese
```

不能继续使用当前模拟器构建里的 `com.example.AoiJapanese` 作为正式上架 Bundle ID。

## App Store Connect API Key

在 App Store Connect 创建 Team API Key，权限建议：

```text
Access: App Manager 或 Admin
Key type: Team Key
```

保存三个值：

```text
Key ID
Issuer ID
AuthKey_XXXXXXXXXX.p8
```

注意：`.p8` 私钥只能下载一次，下载后要妥善保存。

## GitHub Secrets

进入 GitHub 仓库：

```text
Settings -> Secrets and variables -> Actions -> New repository secret
```

添加：

```text
APPLE_TEAM_ID
APP_STORE_CONNECT_KEY_ID
APP_STORE_CONNECT_ISSUER_ID
APP_STORE_CONNECT_API_KEY_BASE64
```

`APP_STORE_CONNECT_API_KEY_BASE64` 是 `.p8` 文件的 base64 内容。

Windows PowerShell 生成方式：

```powershell
[Convert]::ToBase64String([IO.File]::ReadAllBytes("AuthKey_XXXXXXXXXX.p8")) | Set-Clipboard
```

然后把剪贴板内容粘贴到 `APP_STORE_CONNECT_API_KEY_BASE64`。

## 手动触发 TestFlight

进入 GitHub：

```text
Actions -> iOS TestFlight -> Run workflow
```

填写：

```text
bundle_id: com.nekoqwqq.aoijapanese
marketing_version: 1.0
upload_to_testflight: true
```

工作流会：

1. 使用 App Store Connect API Key 登录 Apple 签名服务。
2. 用 Xcode 自动签名并归档 Release App。
3. 导出 signed `.ipa`。
4. 上传 `.ipa` 到 TestFlight。
5. 保存 IPA artifact 和 xcodebuild 日志。

## 手机安装

上传成功后，进入 App Store Connect：

```text
My Apps -> Aoi Japanese -> TestFlight
```

等待 Apple 处理 build。处理完成后：

1. 添加你的 Apple ID 到内部测试员。
2. 手机上安装 TestFlight。
3. 在 TestFlight 里安装 Aoi Japanese。

## 后端要求

如果要在手机上真实使用 AI 功能，还需要部署 `AoiJapaneseBackend`：

```text
Cloudflare Workers
OPENAI_API_KEY
OPENAI_CHAT_MODEL
OPENAI_REALTIME_MODEL
```

当前 iOS App 仍以本地 Mock 体验为主。TestFlight 可以安装和查看 UI，但真实 OpenAI 对话、语音和 Realtime 需要后续把 iOS 的 API Base URL 接到已部署的 Worker。

## 常见失败

### No profiles for bundle ID

检查：

```text
bundle_id 是否和 App Store Connect 里的 Bundle ID 一致
APPLE_TEAM_ID 是否正确
API Key 是否是 Team Key
API Key 权限是否足够
```

### altool authentication failed

检查：

```text
APP_STORE_CONNECT_KEY_ID
APP_STORE_CONNECT_ISSUER_ID
APP_STORE_CONNECT_API_KEY_BASE64
```

### App Store Connect 没有显示 build

检查：

```text
upload_to_testflight 是否为 true
workflow 日志里 Upload to TestFlight 步骤是否成功
App Store Connect 的 App Bundle ID 是否匹配
```
