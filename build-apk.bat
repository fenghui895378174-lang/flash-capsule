@echo off
chcp 65001 >nul
title 闪记胶囊 APK 构建工具

echo ============================================
echo   闪记胶囊 FlashCapsule - APK 构建工具
echo ============================================
echo.

:: 步骤1: 检查 Node.js
echo [1/6] 检查 Node.js...
where node >nul 2>&1
if %errorlevel% neq 0 (
    echo [错误] 未找到 Node.js，请先安装: https://nodejs.org
    pause
    exit /b 1
)
echo    Node.js 已就绪: 
node --version

:: 步骤2: 检查 Java
echo [2/6] 检查 Java (JDK 17+)...
java -version 2>&1 | findstr /i "version" >nul
if %errorlevel% neq 0 (
    echo [提示] 未找到 Java，正在尝试安装 OpenJDK 17...
    winget install Microsoft.OpenJDK.17 --accept-package-agreements 2>nul
    if %errorlevel% neq 0 (
        echo [错误] 无法自动安装 Java，请手动安装 JDK 17: https://adoptium.net/
        echo   安装后请重新运行此脚本
        pause
        exit /b 1
    )
    echo [提示] Java 安装完成，请重新打开命令行并再次运行此脚本
    pause
    exit /b 0
)
echo    Java 已就绪

:: 步骤3: 安装 npm 依赖
echo [3/6] 安装 npm 依赖...
call npm install
if %errorlevel% neq 0 (
    echo [错误] npm install 失败
    pause
    exit /b 1
)

:: 步骤4: 初始化 Capacitor（如果尚未初始化）
echo [4/6] 初始化 Capacitor...
if not exist "capacitor.config.json" (
    call npx cap init 闪记胶囊 com.flashcapsule.app --web-dir=.
)

:: 步骤5: 添加 Android 平台（如果尚未添加）
echo [5/6] 配置 Android 平台...
if not exist "android" (
    echo   正在添加 Android 平台...
    call npx cap add android
    if %errorlevel% neq 0 (
        echo [错误] 无法添加 Android 平台
        echo   请确保已安装 Android Studio 或 Android SDK
        echo   下载地址: https://developer.android.com/studio
        echo   安装后请设置环境变量 ANDROID_HOME
        pause
        exit /b 1
    )
)

:: 步骤6: 同步并构建 APK
echo [6/6] 同步资源并构建 APK...
call npx cap sync android

echo.
echo 正在编译 APK...
cd android
call gradlew assembleDebug
if %errorlevel% equ 0 (
    echo.
    echo ============================================
    echo   构建成功！
    echo   APK 位置: android\app\build\outputs\apk\debug\app-debug.apk
    echo ============================================
) else (
    echo.
    echo [错误] 构建失败，请检查上方错误信息
    echo   常见问题:
    echo   1. ANDROID_HOME 环境变量未设置
    echo   2. Android SDK Platform 34 未安装
    echo   3. 请在 Android Studio 中打开 android/ 目录查看详细错误
)
cd ..

pause
