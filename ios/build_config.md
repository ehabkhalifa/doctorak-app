# 📱 إعدادات بناء iOS لتطبيق دكتورك

## 📋 معلومات التطبيق:
- **اسم التطبيق:** دكتورك - DoctoraK
- **Bundle ID:** com.doctorak.healthapp
- **الإصدار:** 1.0.0
- **Build Number:** 1

## 🔧 إعدادات Xcode المطلوبة:

### 1. **Team & Signing:**
```
Development Team: [يجب إضافة Apple Developer Team ID]
Bundle Identifier: com.doctorak.healthapp
Signing Certificate: iPhone Developer
Provisioning Profile: Automatic
```

### 2. **Deployment Info:**
```
Deployment Target: iOS 12.0+
Devices: iPhone, iPad
Orientations: Portrait, Landscape
```

### 3. **Capabilities المطلوبة:**
- [ ] HealthKit (للبيانات الصحية)
- [ ] Background App Refresh
- [ ] Push Notifications (للتذكيرات)
- [ ] App Groups (للمشاركة بين الإضافات)

### 4. **Privacy Permissions:**
- [ ] Health Share Usage Description
- [ ] Health Update Usage Description
- [ ] Background App Refresh

## 🏗️ خطوات البناء:

### **على macOS:**
```bash
# 1. تنظيف المشروع
flutter clean

# 2. تحديث التبعيات
flutter pub get

# 3. بناء iOS
flutter build ios --release

# 4. فتح في Xcode
open ios/Runner.xcworkspace
```

### **في Xcode:**
1. اختر Target: Runner
2. اختر Device: Generic iOS Device
3. Product → Archive
4. Distribute App → App Store Connect

## 📦 متطلبات App Store:

### **الأيقونات المطلوبة:**
- App Icon: 1024x1024 px
- iPhone Icons: 60x60, 120x120, 180x180
- iPad Icons: 76x76, 152x152, 167x167

### **Screenshots المطلوبة:**
- iPhone 6.7": 1290x2796 px
- iPhone 6.5": 1242x2688 px  
- iPhone 5.5": 1242x2208 px
- iPad Pro 12.9": 2048x2732 px

### **معلومات App Store:**
- وصف التطبيق (عربي/إنجليزي)
- الكلمات المفتاحية
- فئة التطبيق: Medical/Health & Fitness
- التقييم العمري: 4+ (مناسب لجميع الأعمار)

## 🔐 إعدادات الأمان:

### **App Transport Security:**
```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <false/>
</dict>
```

### **Data Protection:**
- تشفير البيانات المحلية
- حماية بيانات المستخدم
- عدم تخزين معلومات حساسة

## 🌍 دعم اللغات:
- العربية (الأساسية)
- الإنجليزية (الثانوية)

## 📝 ملاحظات مهمة:

1. **Apple Developer Account مطلوب** ($99/سنة)
2. **macOS مطلوب** لبناء التطبيق
3. **Xcode 15+** مطلوب
4. **iOS 12.0+** الحد الأدنى المدعوم

## 🚀 البدائل للبناء على Windows:

### 1. **Codemagic (مجاني/مدفوع):**
- https://codemagic.io
- 500 دقيقة بناء مجانية شهرياً
- دعم Flutter و iOS

### 2. **GitHub Actions:**
- استخدام macOS runners
- مجاني للمشاريع العامة

### 3. **Bitrise:**
- خدمة CI/CD
- دعم Flutter و iOS

### 4. **استئجار Mac في السحابة:**
- MacStadium
- AWS EC2 Mac instances

## 📞 الدعم:
للمساعدة في النشر على App Store، يمكن التواصل مع:
- Apple Developer Support
- مجتمع Flutter العربي
- مطوري iOS المحليين
