@echo off
echo 🚀 إعداد GitHub لتطبيق دكتورك
echo ================================

REM التحقق من Git
git --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Git غير مثبت
    echo 💡 قم بتثبيت Git من: https://git-scm.com
    pause
    exit /b 1
)

echo ✅ Git مثبت

REM إنشاء .gitignore إذا لم يكن موجود
if not exist .gitignore (
    echo 📝 إنشاء ملف .gitignore...
    (
        echo # Flutter
        echo /build/
        echo /.dart_tool/
        echo /.packages
        echo /.pub-cache/
        echo /.pub/
        echo /pubspec.lock
        echo 
        echo # iOS
        echo ios/Pods/
        echo ios/.symlinks/
        echo ios/Flutter/Flutter.framework
        echo ios/Flutter/Flutter.podspec
        echo ios/Runner.xcworkspace/xcshareddata/
        echo ios/Runner.xcodeproj/xcshareddata/
        echo 
        echo # Android
        echo android/app/debug
        echo android/app/profile
        echo android/app/release
        echo android/.gradle/
        echo android/captures/
        echo android/gradlew
        echo android/gradlew.bat
        echo android/local.properties
        echo 
        echo # VS Code
        echo .vscode/
        echo 
        echo # IntelliJ
        echo .idea/
        echo *.iml
        echo *.ipr
        echo *.iws
        echo 
        echo # macOS
        echo .DS_Store
        echo 
        echo # Windows
        echo Thumbs.db
        echo 
        echo # Logs
        echo *.log
        echo 
        echo # Database
        echo *.db
        echo *.sqlite
        echo *.sqlite3
    ) > .gitignore
    echo ✅ تم إنشاء .gitignore
)

REM إنشاء README.md
if not exist README.md (
    echo 📝 إنشاء ملف README.md...
    (
        echo # 📱 تطبيق دكتورك - DoctoraK
        echo.
        echo تطبيق صحي ذكي مطور بـ Flutter يقدم معلومات طبية دقيقة وشخصية.
        echo.
        echo ## 🌟 الميزات
        echo - 🔍 البحث عن الأدوية
        echo - 💊 دليل شامل للأدوية
        echo - 🩺 تحليل الأعراض
        echo - 💡 نصائح صحية يومية
        echo - 👤 ملف شخصي صحي
        echo - 🚨 معلومات الطوارئ
        echo.
        echo ## 🛠️ التقنيات المستخدمة
        echo - Flutter 3.32.0
        echo - Dart
        echo - SQLite
        echo - Provider State Management
        echo.
        echo ## 📱 المنصات المدعومة
        echo - ✅ Android
        echo - ✅ iOS
        echo.
        echo ## 🚀 كيفية البناء
        echo.
        echo ### Android:
        echo ```bash
        echo flutter build apk --release
        echo ```
        echo.
        echo ### iOS:
        echo استخدم Codemagic أو GitHub Actions للبناء على macOS
        echo.
        echo ## 📄 الترخيص
        echo هذا المشروع مرخص تحت رخصة MIT
        echo.
        echo ## 📞 التواصل
        echo للدعم والاستفسارات: info@doctorak.app
    ) > README.md
    echo ✅ تم إنشاء README.md
)

REM تهيئة Git repository
if not exist .git (
    echo 🔧 تهيئة Git repository...
    git init
    echo ✅ تم تهيئة Git
)

REM إضافة الملفات
echo 📦 إضافة الملفات...
git add .

REM إنشاء commit
echo 💾 إنشاء commit...
git commit -m "Initial commit: DoctoraK Flutter Health App

✨ Features:
- Drug search and information
- Health tips and advice  
- Symptom analysis
- User health profile
- Emergency medical info
- Arabic language support

🛠️ Tech Stack:
- Flutter 3.32.0
- SQLite database
- Provider state management
- Material Design

📱 Platforms:
- Android (APK ready)
- iOS (configured for build)

🚀 Ready for deployment on both platforms!"

echo.
echo 🎉 Git repository جاهز!
echo.
echo 📋 الخطوات التالية:
echo 1. أنشئ repository جديد على GitHub
echo 2. انسخ الرابط (مثل: https://github.com/username/doctorak-app.git)
echo 3. شغل الأمر التالي:
echo    git remote add origin [GITHUB_URL]
echo    git push -u origin main
echo.
echo 💡 بعد رفع المشروع على GitHub:
echo - ستعمل GitHub Actions تلقائياً لبناء iOS
echo - يمكنك استخدام Codemagic لبناء IPA
echo - ستحصل على ملف IPA جاهز للتثبيت
echo.
pause
