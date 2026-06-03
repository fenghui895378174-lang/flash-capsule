# 闪记胶囊 FlashCapsule

记录灵感、管理收支、倒计时提醒的全能胶囊 App

## 功能
- **记录**: 灵感速记，支持优先级/标签分类/定时提醒
- **收支**: 固定收入/开支/目标管理 + 动态流水追踪
- **倒计时**: 正计时 & 倒计时双模式事件追踪

## 在浏览器中预览

```bash
# 启动本地服务器
npm run dev
# 然后访问 http://localhost:3000
```

## 编译 Android APK

### 前置条件
1. **Node.js** 18+ → https://nodejs.org
2. **Java JDK 17** → https://adoptium.net
3. **Android Studio** → https://developer.android.com/studio
   - 安装时勾选 Android SDK Platform 34
   - 设置环境变量 `ANDROID_HOME` 指向 SDK 目录

### 一键构建（Windows）
```bash
# 双击运行
build-apk.bat
```

### 手动构建
```bash
# 1. 安装依赖
npm install

# 2. 添加 Android 平台
npx cap add android

# 3. 同步 Web 资源
npx cap sync android

# 4. 编译 APK
cd android
gradlew assembleDebug

# APK 位于: android/app/build/outputs/apk/debug/app-debug.apk
```

### Mac/Linux 用户
```bash
npm install
npx cap add android
npx cap sync android
cd android && ./gradlew assembleDebug
```

## 提醒机制说明

安装到手机后，提醒通过以下方式触发：
- **浏览器版**: 使用 Web Notification API，需授权通知权限
- **APK 版**: 使用 Android 原生通知（Local Notifications），即使 App 在后台也能弹出系统通知栏提醒
- 新建记录时设置提醒时间，App 每 30 秒检查一次待提醒记录

## 数据存储

所有数据存储在手机本地 localStorage / App 内部存储中，无需网络。
