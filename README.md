# 📱 دكتورك - DoctoraK

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.32.0-blue.svg)
![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-green.svg)
![License](https://img.shields.io/badge/License-MIT-yellow.svg)

**تطبيق صحي ذكي مطور بـ Flutter يقدم معلومات طبية دقيقة وشخصية**

[العربية](#العربية) • [English](#english) • [التحميل](#التحميل) • [المساهمة](#المساهمة)

</div>

---

## العربية

### 🎯 نظرة عامة
تطبيق دكتورك هو تطبيق طبي ذكي يساعدك في البحث عن الأدوية، تحليل الأعراض، والحصول على نصائح صحية مخصصة. مطور بتقنية Flutter لضمان الأداء العالي على جميع المنصات.

### ✨ المميزات الرئيسية

- 🔍 **البحث الذكي عن الأدوية**
  - البحث بالاسم التجاري أو المادة الفعالة
  - معلومات شاملة عن الجرعات والاستخدامات
  - تحذيرات وتفاعلات الأدوية

- 🩺 **تحليل الأعراض المتقدم**
  - تحليل أولي للأعراض
  - اقتراحات للرعاية الصحية
  - إرشادات للحالات الطارئة

- 💡 **نصائح صحية يومية**
  - نصائح مخصصة حسب العمر والجنس
  - معلومات عن التغذية والرياضة
  - نصائح للوقاية من الأمراض

- 👤 **الملف الصحي الشخصي**
  - تتبع المؤشرات الصحية
  - حساب مؤشر كتلة الجسم
  - تاريخ الأدوية والعلاجات

- 🚨 **معلومات الطوارئ**
  - أرقام الطوارئ المحلية
  - الإسعافات الأولية
  - أدوية الطوارئ الأساسية

### 🛠️ التقنيات المستخدمة

- **Frontend**: Flutter 3.32.0 + Dart
- **State Management**: Provider
- **Database**: SQLite (محلية)
- **UI/UX**: Material Design 3
- **Architecture**: Clean Architecture
- **Testing**: Unit Tests + Widget Tests

### 📱 المنصات المدعومة

- ✅ **Android** (API 21+)
- ✅ **iOS** (iOS 12.0+)
- 🔄 **Web** (قيد التطوير)

---

## English

### 🎯 Overview
DoctoraK is a smart medical application that helps you search for medications, analyze symptoms, and get personalized health tips. Built with Flutter for high performance across all platforms.

### ✨ Key Features

- 🔍 **Smart Drug Search**
  - Search by brand name or active ingredient
  - Comprehensive dosage and usage information
  - Drug warnings and interactions

- 🩺 **Advanced Symptom Analysis**
  - Preliminary symptom analysis
  - Healthcare suggestions
  - Emergency care guidelines

- 💡 **Daily Health Tips**
  - Personalized tips based on age and gender
  - Nutrition and exercise information
  - Disease prevention advice

- 👤 **Personal Health Profile**
  - Track health indicators
  - BMI calculator
  - Medication and treatment history

- 🚨 **Emergency Information**
  - Local emergency numbers
  - First aid instructions
  - Essential emergency medications

### 🛠️ Tech Stack

- **Frontend**: Flutter 3.32.0 + Dart
- **State Management**: Provider
- **Database**: SQLite (Local)
- **UI/UX**: Material Design 3
- **Architecture**: Clean Architecture
- **Testing**: Unit Tests + Widget Tests

### 📱 Supported Platforms

- ✅ **Android** (API 21+)
- ✅ **iOS** (iOS 12.0+)
- 🔄 **Web** (In Development)

---

## 🚀 التحميل والتثبيت

### متطلبات النظام

#### للتطوير:
- Flutter SDK 3.32.0+
- Dart SDK 3.0+
- Android Studio / VS Code
- Git

#### للمستخدمين:
- **Android**: Android 5.0+ (API 21)
- **iOS**: iOS 12.0+

### خطوات التثبيت

```bash
# استنساخ المشروع
git clone https://github.com/ehabkhalifa/doctorak-app.git
cd doctorak-app

# تثبيت التبعيات
flutter pub get

# تشغيل التطبيق
flutter run
```

### بناء التطبيق

#### Android APK:
```bash
flutter build apk --release
```

#### iOS IPA:
```bash
# يتطلب macOS + Xcode
flutter build ios --release

# أو استخدم Codemagic للبناء السحابي
# راجع docs/create_ipa_guide.md
```

---

## 📊 إحصائيات المشروع

- **📁 الملفات**: 50+ ملف
- **📝 الأكواد**: 5000+ سطر
- **🧪 الاختبارات**: 20+ اختبار
- **📱 الشاشات**: 5 شاشات رئيسية
- **🗄️ قاعدة البيانات**: 4 جداول
- **🌐 اللغات**: العربية + الإنجليزية

---

## 🏗️ هيكل المشروع

```
lib/
├── main.dart                 # نقطة البداية
├── models/                   # نماذج البيانات
│   ├── drug.dart
│   ├── health_tip.dart
│   └── user_profile.dart
├── screens/                  # شاشات التطبيق
│   ├── home_screen.dart
│   ├── drug_search_screen.dart
│   ├── health_tips_screen.dart
│   ├── symptom_analysis_screen.dart
│   └── profile_screen.dart
├── services/                 # الخدمات
│   ├── database_service.dart
│   ├── cache_service.dart
│   ├── sync_service.dart
│   └── assets_service.dart
├── providers/                # إدارة الحالة
│   └── app_provider.dart
├── widgets/                  # المكونات المخصصة
│   ├── custom_widgets.dart
│   └── skeleton_widgets.dart
├── theme/                    # التصميم
│   └── app_theme.dart
└── utils/                    # الأدوات المساعدة
    ├── app_constants.dart
    ├── app_helpers.dart
    └── app_diagnostics.dart
```

---

## 🧪 الاختبار

```bash
# تشغيل جميع الاختبارات
flutter test

# اختبار ملفات محددة
flutter test test/assets_test.dart

# تشغيل اختبارات التكامل
flutter drive --target=test_driver/app.dart
```

---

## 📈 الأداء والتحسينات

### تحسينات الحجم:
- **قبل التحسين**: ~900 MB
- **بعد التحسين**: ~62 MB
- **نسبة التحسن**: 93% تقليل

### تحسينات الأداء:
- Tree-shaking للأيقونات (99.5% تقليل)
- فهارس قاعدة البيانات محسنة
- نظام كاش ذكي
- تحميل البيانات بشكل تدريجي

---

## 🤝 المساهمة

نرحب بمساهماتكم! يرجى اتباع الخطوات التالية:

1. **Fork** المشروع
2. إنشاء فرع جديد (`git checkout -b feature/amazing-feature`)
3. تنفيذ التغييرات (`git commit -m 'Add amazing feature'`)
4. رفع التغييرات (`git push origin feature/amazing-feature`)
5. فتح **Pull Request**

### إرشادات المساهمة:
- اتبع معايير Dart/Flutter
- أضف اختبارات للميزات الجديدة
- حدث التوثيق عند الحاجة
- تأكد من عمل جميع الاختبارات

---

## 📄 الترخيص

هذا المشروع مرخص تحت [رخصة MIT](LICENSE) - راجع ملف LICENSE للتفاصيل.

---

## 📞 التواصل والدعم

- **البريد الإلكتروني**: info@doctorak.app
- **GitHub Issues**: [إبلاغ عن مشكلة](https://github.com/ehabkhalifa/doctorak-app/issues)
- **المطور**: [Ehab Khalifa](https://github.com/ehabkhalifa)

---

## 🙏 شكر وتقدير

- **Flutter Team** - للإطار الرائع
- **Material Design** - للتصميم الجميل
- **المجتمع العربي** - للدعم والمساندة
- **جميع المساهمين** - لجعل هذا المشروع أفضل

---

## ⚠️ إخلاء المسؤولية

هذا التطبيق مخصص للأغراض التعليمية والمعلوماتية فقط. لا يغني عن استشارة الطبيب المختص. يرجى استشارة مقدم الرعاية الصحية قبل اتخاذ أي قرارات طبية.

---

<div align="center">

**⭐ إذا أعجبك المشروع، لا تنس إعطاؤه نجمة! ⭐**

Made with ❤️ by [Ehab Khalifa](https://github.com/ehabkhalifa)

</div>
