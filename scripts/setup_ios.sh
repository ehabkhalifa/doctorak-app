#!/bin/bash

# 📱 سكريبت إعداد iOS لتطبيق دكتورك
# يجب تشغيله على macOS فقط

echo "🍎 إعداد تطبيق دكتورك لـ iOS"
echo "=================================="

# التحقق من النظام
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ هذا السكريبت يعمل على macOS فقط"
    echo "💡 استخدم خدمات البناء السحابية للبناء على Windows"
    exit 1
fi

# التحقق من Flutter
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter غير مثبت"
    echo "💡 قم بتثبيت Flutter من: https://flutter.dev"
    exit 1
fi

# التحقق من Xcode
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Xcode غير مثبت"
    echo "💡 قم بتثبيت Xcode من App Store"
    exit 1
fi

echo "✅ النظام جاهز للبناء"
echo ""

# تنظيف المشروع
echo "🧹 تنظيف المشروع..."
flutter clean

# تحديث التبعيات
echo "📦 تحديث التبعيات..."
flutter pub get

# التحقق من إعدادات iOS
echo "🔍 فحص إعدادات iOS..."
flutter doctor

# إنشاء مجلد الأيقونات إذا لم يكن موجود
echo "🎨 إعداد الأيقونات..."
mkdir -p ios/Runner/Assets.xcassets/AppIcon.appiconset

# إنشاء ملف Contents.json للأيقونات
cat > ios/Runner/Assets.xcassets/AppIcon.appiconset/Contents.json << 'EOF'
{
  "images" : [
    {
      "idiom" : "iphone",
      "scale" : "2x",
      "size" : "20x20"
    },
    {
      "idiom" : "iphone",
      "scale" : "3x",
      "size" : "20x20"
    },
    {
      "idiom" : "iphone",
      "scale" : "2x",
      "size" : "29x29"
    },
    {
      "idiom" : "iphone",
      "scale" : "3x",
      "size" : "29x29"
    },
    {
      "idiom" : "iphone",
      "scale" : "2x",
      "size" : "40x40"
    },
    {
      "idiom" : "iphone",
      "scale" : "3x",
      "size" : "40x40"
    },
    {
      "idiom" : "iphone",
      "scale" : "2x",
      "size" : "60x60"
    },
    {
      "idiom" : "iphone",
      "scale" : "3x",
      "size" : "60x60"
    },
    {
      "idiom" : "ipad",
      "scale" : "1x",
      "size" : "20x20"
    },
    {
      "idiom" : "ipad",
      "scale" : "2x",
      "size" : "20x20"
    },
    {
      "idiom" : "ipad",
      "scale" : "1x",
      "size" : "29x29"
    },
    {
      "idiom" : "ipad",
      "scale" : "2x",
      "size" : "29x29"
    },
    {
      "idiom" : "ipad",
      "scale" : "1x",
      "size" : "40x40"
    },
    {
      "idiom" : "ipad",
      "scale" : "2x",
      "size" : "40x40"
    },
    {
      "idiom" : "ipad",
      "scale" : "1x",
      "size" : "76x76"
    },
    {
      "idiom" : "ipad",
      "scale" : "2x",
      "size" : "76x76"
    },
    {
      "idiom" : "ipad",
      "scale" : "2x",
      "size" : "83.5x83.5"
    },
    {
      "idiom" : "ios-marketing",
      "scale" : "1x",
      "size" : "1024x1024"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF

echo "✅ تم إعداد ملف الأيقونات"

# محاولة بناء التطبيق للتأكد من الإعدادات
echo "🏗️ اختبار البناء..."
if flutter build ios --debug --no-codesign; then
    echo "✅ البناء نجح!"
    echo ""
    echo "🎉 التطبيق جاهز لـ iOS!"
    echo ""
    echo "📋 الخطوات التالية:"
    echo "1. افتح المشروع في Xcode:"
    echo "   open ios/Runner.xcworkspace"
    echo ""
    echo "2. قم بإعداد:"
    echo "   - Team & Signing"
    echo "   - Bundle Identifier"
    echo "   - App Icons"
    echo ""
    echo "3. للبناء للإنتاج:"
    echo "   flutter build ios --release"
    echo ""
    echo "4. للنشر على App Store:"
    echo "   - Product → Archive في Xcode"
    echo "   - Distribute App → App Store Connect"
else
    echo "❌ فشل في البناء"
    echo "💡 تحقق من الأخطاء أعلاه وأعد المحاولة"
    exit 1
fi
