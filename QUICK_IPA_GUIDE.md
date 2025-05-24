# ⚡ دليل سريع للحصول على ملف IPA

## 🎯 الهدف: الحصول على ملف IPA لتطبيق دكتورك في أسرع وقت

---

## 🚀 **الطريقة الأسرع: Codemagic (15 دقيقة)**

### **الخطوة 1: رفع المشروع (5 دقائق)**
```bash
# شغل سكريبت الإعداد
scripts\setup_github.bat

# بعد إنشاء GitHub repository:
git remote add origin https://github.com/YOUR_USERNAME/doctorak-app.git
git push -u origin main
```

### **الخطوة 2: إعداد Codemagic (5 دقائق)**
1. اذهب إلى [codemagic.io](https://codemagic.io)
2. سجل دخول بـ GitHub
3. اختر "Add application"
4. اختر مشروع doctorak-app
5. اختر "Flutter App"

### **الخطوة 3: بناء IPA (5 دقائق إعداد + 20 دقيقة بناء)**
1. في Codemagic، اختر "Start your first build"
2. اختر "iOS" 
3. اختر "ios-build-ipa" workflow
4. اضغط "Start new build"
5. انتظر 15-25 دقيقة
6. حمل IPA من "Artifacts"

### **⏱️ الوقت الإجمالي: 30 دقيقة**

---

## 💰 **التكلفة: مجاني تماماً**
- ✅ Codemagic: 500 دقيقة مجانية شهرياً
- ✅ GitHub: مجاني للمشاريع العامة
- ⚠️ Apple Developer Account: $99/سنة (للنشر على App Store فقط)

---

## 📱 **ما ستحصل عليه:**
- ✅ ملف IPA جاهز للتثبيت
- ✅ يعمل على أجهزة iOS (مع Apple Developer Account)
- ✅ جاهز للاختبار والتطوير
- ✅ يمكن توزيعه للمختبرين

---

## 🔧 **إذا واجهت مشاكل:**

### **مشكلة: "No signing certificate"**
**الحل:** تحتاج Apple Developer Account ($99/سنة)

### **مشكلة: "Build failed"**
**الحل:** تحقق من logs في Codemagic

### **مشكلة: "Repository not found"**
**الحل:** تأكد من أن repository عام (public)

---

## 🎯 **بدائل سريعة:**

### **GitHub Actions (مجاني):**
1. رفع المشروع على GitHub
2. تفعيل Actions تلقائياً
3. انتظار البناء (20-30 دقيقة)
4. تحميل artifacts

### **Bitrise (مجاني محدود):**
1. ربط مع GitHub
2. إعداد workflow
3. بناء IPA

---

## 📋 **قائمة تحقق سريعة:**

### **قبل البدء:**
- [ ] Git مثبت
- [ ] حساب GitHub
- [ ] اتصال إنترنت مستقر

### **أثناء العملية:**
- [ ] رفع المشروع على GitHub
- [ ] إعداد Codemagic
- [ ] بدء البناء
- [ ] انتظار النتائج

### **بعد الانتهاء:**
- [ ] تحميل IPA
- [ ] اختبار التطبيق
- [ ] توزيع للمختبرين

---

## 🎉 **النتيجة النهائية:**

**في 30 دقيقة ستحصل على:**
- 📱 ملف IPA جاهز
- 🔧 بيئة بناء مُعدة
- 🚀 إمكانية بناء تحديثات مستقبلية
- 📊 تقارير بناء مفصلة

---

## 📞 **تحتاج مساعدة؟**

### **روابط مفيدة:**
- [Codemagic Documentation](https://docs.codemagic.io)
- [GitHub Actions Guide](https://docs.github.com/en/actions)
- [Flutter iOS Deployment](https://docs.flutter.dev/deployment/ios)

### **دعم فني:**
- Codemagic Support: support@codemagic.io
- GitHub Support: support@github.com

---

## ⚡ **ابدأ الآن:**

```bash
# شغل هذا الأمر لبدء العملية
scripts\setup_github.bat
```

**🎯 هدفك: ملف IPA جاهز في 30 دقيقة!**
