class AppConstants {
  // App Information
  static const String appName = 'تطبيق صحي ذكي';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'تطبيق صحي شامل يقدم معلومات دقيقة وشخصية للمستخدمين';
  
  // Database
  static const String databaseName = 'healthy_app.db';
  static const int databaseVersion = 2;
  
  // Animation Durations
  static const Duration fastAnimation = Duration(milliseconds: 200);
  static const Duration normalAnimation = Duration(milliseconds: 300);
  static const Duration slowAnimation = Duration(milliseconds: 500);
  static const Duration verySlowAnimation = Duration(milliseconds: 800);
  
  // Spacing
  static const double smallSpacing = 8.0;
  static const double normalSpacing = 16.0;
  static const double largeSpacing = 24.0;
  static const double extraLargeSpacing = 32.0;
  
  // Border Radius
  static const double smallRadius = 8.0;
  static const double normalRadius = 12.0;
  static const double largeRadius = 16.0;
  static const double extraLargeRadius = 20.0;
  static const double circularRadius = 50.0;
  
  // Elevation
  static const double lowElevation = 2.0;
  static const double normalElevation = 4.0;
  static const double highElevation = 8.0;
  static const double veryHighElevation = 16.0;
  
  // Font Sizes
  static const double smallFontSize = 12.0;
  static const double normalFontSize = 14.0;
  static const double mediumFontSize = 16.0;
  static const double largeFontSize = 18.0;
  static const double extraLargeFontSize = 20.0;
  static const double titleFontSize = 24.0;
  static const double headlineFontSize = 28.0;
  static const double displayFontSize = 32.0;
  
  // Icon Sizes
  static const double smallIconSize = 16.0;
  static const double normalIconSize = 24.0;
  static const double largeIconSize = 32.0;
  static const double extraLargeIconSize = 48.0;
  
  // Button Heights
  static const double smallButtonHeight = 36.0;
  static const double normalButtonHeight = 48.0;
  static const double largeButtonHeight = 56.0;
  
  // Card Dimensions
  static const double cardMinHeight = 120.0;
  static const double cardMaxHeight = 200.0;
  static const double cardPadding = 16.0;
  
  // Health Metrics
  static const double minBMI = 10.0;
  static const double maxBMI = 50.0;
  static const double normalBMIMin = 18.5;
  static const double normalBMIMax = 24.9;
  static const double overweightBMIMin = 25.0;
  static const double overweightBMIMax = 29.9;
  static const double obeseBMIMin = 30.0;
  
  // Age Limits
  static const int minAge = 1;
  static const int maxAge = 120;
  
  // Weight Limits (kg)
  static const double minWeight = 1.0;
  static const double maxWeight = 300.0;
  
  // Height Limits (cm)
  static const double minHeight = 30.0;
  static const double maxHeight = 250.0;
  
  // Search
  static const int minSearchLength = 2;
  static const int maxSearchResults = 50;
  static const Duration searchDebounceTime = Duration(milliseconds: 500);
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // Cache
  static const Duration cacheExpiration = Duration(hours: 24);
  static const int maxCacheSize = 100;
  
  // Network
  static const Duration networkTimeout = Duration(seconds: 30);
  static const int maxRetries = 3;
  
  // Validation Messages
  static const String requiredFieldMessage = 'هذا الحقل مطلوب';
  static const String invalidEmailMessage = 'البريد الإلكتروني غير صحيح';
  static const String invalidPhoneMessage = 'رقم الهاتف غير صحيح';
  static const String passwordTooShortMessage = 'كلمة المرور قصيرة جداً';
  static const String passwordsNotMatchMessage = 'كلمات المرور غير متطابقة';
  
  // Success Messages
  static const String saveSuccessMessage = 'تم الحفظ بنجاح';
  static const String updateSuccessMessage = 'تم التحديث بنجاح';
  static const String deleteSuccessMessage = 'تم الحذف بنجاح';
  static const String shareSuccessMessage = 'تم المشاركة بنجاح';
  
  // Error Messages
  static const String generalErrorMessage = 'حدث خطأ غير متوقع';
  static const String networkErrorMessage = 'خطأ في الاتصال بالإنترنت';
  static const String databaseErrorMessage = 'خطأ في قاعدة البيانات';
  static const String notFoundMessage = 'العنصر غير موجود';
  static const String accessDeniedMessage = 'ليس لديك صلاحية للوصول';
  
  // Warning Messages
  static const String unsavedChangesMessage = 'لديك تغييرات غير محفوظة';
  static const String deleteConfirmationMessage = 'هل أنت متأكد من الحذف؟';
  static const String logoutConfirmationMessage = 'هل أنت متأكد من تسجيل الخروج؟';
  
  // Info Messages
  static const String noDataMessage = 'لا توجد بيانات للعرض';
  static const String loadingMessage = 'جاري التحميل...';
  static const String searchingMessage = 'جاري البحث...';
  static const String processingMessage = 'جاري المعالجة...';
  
  // Drug Categories
  static const List<String> drugCategories = [
    'الكل',
    'مسكنات',
    'مضادات الالتهاب',
    'مضادات حيوية',
    'فيتامينات',
    'أدوية القلب',
    'أدوية الضغط',
    'أدوية السكري',
    'مكملات غذائية',
  ];
  
  // Health Tip Categories
  static const List<String> healthTipCategories = [
    'الكل',
    'تغذية',
    'رياضة',
    'نوم',
    'صحة نفسية',
    'وقاية',
    'علاج طبيعي',
  ];
  
  // Severity Levels
  static const List<String> severityLevels = [
    'خفيف',
    'متوسط',
    'شديد',
  ];
  
  // Activity Levels
  static const List<String> activityLevels = [
    'قليل',
    'متوسط',
    'عالي',
  ];
  
  // Gender Options
  static const List<String> genderOptions = [
    'ذكر',
    'أنثى',
  ];
  
  // Time of Day
  static const List<String> timeOfDay = [
    'الصباح',
    'الظهر',
    'المساء',
    'الليل',
  ];
  
  // Days of Week
  static const List<String> daysOfWeek = [
    'الأحد',
    'الاثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة',
    'السبت',
  ];
  
  // Months
  static const List<String> months = [
    'يناير',
    'فبراير',
    'مارس',
    'أبريل',
    'مايو',
    'يونيو',
    'يوليو',
    'أغسطس',
    'سبتمبر',
    'أكتوبر',
    'نوفمبر',
    'ديسمبر',
  ];
  
  // Common Symptoms
  static const List<String> commonSymptoms = [
    'صداع',
    'تعب وإرهاق',
    'ألم في المعدة',
    'سعال',
    'حمى',
    'دوخة',
    'ألم في الظهر',
    'أرق',
    'غثيان',
    'ألم في المفاصل',
  ];
  
  // Common Vitamins
  static const List<String> commonVitamins = [
    'فيتامين A',
    'فيتامين B1',
    'فيتامين B2',
    'فيتامين B6',
    'فيتامين B12',
    'فيتامين C',
    'فيتامين D',
    'فيتامين E',
    'فيتامين K',
    'حمض الفوليك',
    'البيوتين',
    'النياسين',
  ];
  
  // Common Supplements
  static const List<String> commonSupplements = [
    'أوميغا 3',
    'الكالسيوم',
    'المغنيسيوم',
    'الزنك',
    'الحديد',
    'البروبيوتيك',
    'الكركم',
    'الجينسنغ',
    'الكوكيو 10',
    'الزنجبيل',
  ];
  
  // Health Goals
  static const List<String> healthGoals = [
    'فقدان الوزن',
    'زيادة الوزن',
    'الحفاظ على الوزن الحالي',
    'تحسين اللياقة البدنية',
    'تحسين النوم',
    'تقليل التوتر',
    'تحسين الهضم',
    'تقوية المناعة',
    'تحسين الطاقة',
    'تحسين التركيز',
  ];
  
  // Regular Expressions
  static const String emailRegex = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phoneRegex = r'^[0-9]{10,15}$';
  static const String nameRegex = r'^[a-zA-Zأ-ي\s]{2,50}$';
  
  // Date Formats
  static const String dateFormat = 'yyyy-MM-dd';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm';
  static const String displayDateFormat = 'dd/MM/yyyy';
  static const String displayTimeFormat = 'hh:mm a';
  static const String displayDateTimeFormat = 'dd/MM/yyyy hh:mm a';
}