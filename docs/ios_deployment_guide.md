# 📱 دليل شامل لنشر تطبيق دكتورك على App Store

## 🎯 نظرة عامة
هذا الدليل يوضح كيفية نشر تطبيق دكتورك على App Store من البداية حتى النهاية.

---

## 📋 المتطلبات الأساسية

### **1. 💻 الأجهزة والبرامج:**
- ✅ جهاز Mac (macOS 12.0+)
- ✅ Xcode 15.0+ (من App Store)
- ✅ Flutter SDK (مثبت ومُعد)
- ✅ حساب Apple Developer ($99/سنة)

### **2. 📄 المستندات المطلوبة:**
- ✅ هوية المطور
- ✅ معلومات الشركة (إن وجدت)
- ✅ وصف التطبيق (عربي/إنجليزي)
- ✅ سياسة الخصوصية
- ✅ شروط الاستخدام

---

## 🔧 إعداد بيئة التطوير

### **الخطوة 1: تثبيت الأدوات**
```bash
# تحديث Xcode Command Line Tools
xcode-select --install

# التحقق من Flutter
flutter doctor

# تثبيت CocoaPods (إذا لم يكن مثبت)
sudo gem install cocoapods
```

### **الخطوة 2: إعداد المشروع**
```bash
# الانتقال لمجلد المشروع
cd /path/to/flutter_application_1

# تشغيل سكريبت الإعداد
chmod +x scripts/setup_ios.sh
./scripts/setup_ios.sh
```

---

## 🏗️ بناء التطبيق

### **الخطوة 1: إعداد Xcode**
```bash
# فتح المشروع في Xcode
open ios/Runner.xcworkspace
```

### **الخطوة 2: إعدادات المشروع في Xcode**

#### **أ. General Settings:**
- **Display Name:** دكتورك - DoctoraK
- **Bundle Identifier:** com.doctorak.healthapp
- **Version:** 1.0.0
- **Build:** 1
- **Deployment Target:** iOS 12.0

#### **ب. Signing & Capabilities:**
- **Team:** [اختر فريق المطور]
- **Signing Certificate:** iPhone Distribution
- **Provisioning Profile:** Automatic

#### **ج. إضافة Capabilities:**
1. **HealthKit** (للبيانات الصحية)
2. **Background App Refresh**
3. **Push Notifications**

### **الخطوة 3: إضافة الأيقونات**
1. إنشاء أيقونة 1024x1024 بكسل
2. استخدام أداة مثل [App Icon Generator](https://appicon.co)
3. سحب الأيقونات إلى `Assets.xcassets/AppIcon.appiconset`

### **الخطوة 4: البناء للاختبار**
```bash
# بناء للمحاكي
flutter build ios --debug --simulator

# بناء للجهاز
flutter build ios --debug
```

---

## 📦 إعداد App Store Connect

### **الخطوة 1: إنشاء App في App Store Connect**
1. اذهب إلى [App Store Connect](https://appstoreconnect.apple.com)
2. اضغط "My Apps" → "+"
3. املأ المعلومات:
   - **App Name:** دكتورك - DoctoraK
   - **Primary Language:** Arabic
   - **Bundle ID:** com.doctorak.healthapp
   - **SKU:** doctorak-health-app-001

### **الخطوة 2: معلومات التطبيق**

#### **أ. App Information:**
- **Name:** دكتورك - DoctoraK
- **Subtitle:** تطبيق صحي ذكي
- **Category:** Medical
- **Content Rights:** Does Not Use Third-Party Content

#### **ب. Pricing and Availability:**
- **Price:** Free
- **Availability:** All Countries

#### **ج. App Privacy:**
- **Privacy Policy URL:** https://doctorak.app/privacy
- **Data Collection:** Health Data, Usage Data

---

## 🖼️ إعداد المحتوى المرئي

### **الخطوة 1: Screenshots المطلوبة**

#### **iPhone Screenshots:**
- **6.7" Display (iPhone 14 Pro Max):** 1290 x 2796 px
- **6.5" Display (iPhone 11 Pro Max):** 1242 x 2688 px
- **5.5" Display (iPhone 8 Plus):** 1242 x 2208 px

#### **iPad Screenshots:**
- **12.9" Display (iPad Pro):** 2048 x 2732 px
- **10.5" Display (iPad Air):** 1668 x 2224 px

### **الخطوة 2: App Preview Videos (اختياري)**
- مدة: 15-30 ثانية
- دقة: مطابقة لدقة الجهاز
- تنسيق: .mov أو .mp4

---

## 🚀 النشر على App Store

### **الخطوة 1: إنشاء Archive**
1. في Xcode، اختر **Generic iOS Device**
2. **Product** → **Archive**
3. انتظر حتى اكتمال البناء

### **الخطوة 2: رفع التطبيق**
1. في **Organizer**، اختر Archive
2. اضغط **Distribute App**
3. اختر **App Store Connect**
4. اختر **Upload**
5. اتبع الخطوات

### **الخطوة 3: إعداد الإصدار**
1. في App Store Connect، اذهب لتطبيقك
2. اضغط **+ Version or Platform**
3. املأ معلومات الإصدار:

#### **Version Information:**
- **Version:** 1.0.0
- **What's New:** الإصدار الأول من تطبيق دكتورك

#### **App Description:**
```
تطبيق دكتورك هو تطبيق صحي ذكي يقدم:

🔍 البحث عن الأدوية والمعلومات الطبية
💊 دليل شامل للأدوية والجرعات
🩺 تحليل الأعراض والنصائح الصحية
👤 ملف شخصي صحي مخصص
📱 واجهة سهلة الاستخدام باللغة العربية

الميزات الرئيسية:
• قاعدة بيانات شاملة للأدوية
• نصائح صحية يومية
• تحليل الأعراض الذكي
• معلومات الطوارئ الطبية
• دعم كامل للغة العربية

تطبيق دكتورك مصمم لمساعدتك في اتخاذ قرارات صحية مدروسة.

تنبيه: هذا التطبيق لا يغني عن استشارة الطبيب المختص.
```

#### **Keywords:**
```
صحة,طب,أدوية,نصائح,علاج,دواء,طبيب,مستشفى,عيادة,صيدلية
```

### **الخطوة 4: المراجعة والنشر**
1. اضغط **Save**
2. اضغط **Submit for Review**
3. انتظر مراجعة Apple (1-7 أيام)

---

## 🔍 نصائح لتجاوز مراجعة Apple

### **1. 📋 App Review Guidelines:**
- تأكد من عدم وجود محتوى طبي مضلل
- أضف تنبيه "لا يغني عن استشارة الطبيب"
- تأكد من دقة المعلومات الطبية

### **2. 🔒 الخصوصية:**
- أضف سياسة خصوصية واضحة
- اشرح كيفية استخدام البيانات الصحية
- تأكد من الحصول على موافقة المستخدم

### **3. 🎯 الوظائف:**
- تأكد من عمل جميع الميزات
- اختبر على أجهزة مختلفة
- تأكد من سرعة التطبيق

---

## 🆘 حل المشاكل الشائعة

### **مشكلة: "No suitable application records were found"**
**الحل:** تأكد من تطابق Bundle ID في Xcode مع App Store Connect

### **مشكلة: "Invalid Bundle"**
**الحل:** تأكد من إعدادات Signing صحيحة

### **مشكلة: "Missing Compliance"**
**الحل:** أضف Export Compliance في App Store Connect

---

## 📞 الدعم والمساعدة

### **Apple Developer Support:**
- https://developer.apple.com/support/
- https://developer.apple.com/contact/

### **مجتمع Flutter:**
- https://flutter.dev/community
- https://github.com/flutter/flutter/issues

### **مراجع مفيدة:**
- [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)
- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- [App Store Connect Help](https://help.apple.com/app-store-connect/)

---

## ✅ قائمة التحقق النهائية

- [ ] تم إعداد Apple Developer Account
- [ ] تم إنشاء App في App Store Connect
- [ ] تم إعداد Bundle ID صحيح
- [ ] تم إضافة الأيقونات بجميع الأحجام
- [ ] تم إضافة Screenshots
- [ ] تم كتابة وصف التطبيق
- [ ] تم إعداد سياسة الخصوصية
- [ ] تم اختبار التطبيق على أجهزة حقيقية
- [ ] تم رفع Build إلى App Store Connect
- [ ] تم إرسال للمراجعة

**🎉 مبروك! تطبيق دكتورك جاهز للنشر على App Store!**
