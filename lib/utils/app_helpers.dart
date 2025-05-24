import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'app_constants.dart';
import 'app_icons.dart';

class AppHelpers {
  // Date and Time Helpers
  static String formatDate(DateTime date) {
    return DateFormat(AppConstants.displayDateFormat).format(date);
  }

  static String formatTime(DateTime time) {
    return DateFormat(AppConstants.displayTimeFormat).format(time);
  }

  static String formatDateTime(DateTime dateTime) {
    return DateFormat(AppConstants.displayDateTimeFormat).format(dateTime);
  }

  static String getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'الآن';
        }
        return 'منذ ${difference.inMinutes} دقيقة';
      }
      return 'منذ ${difference.inHours} ساعة';
    } else if (difference.inDays == 1) {
      return 'أمس';
    } else if (difference.inDays < 7) {
      return 'منذ ${difference.inDays} أيام';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return 'منذ $weeks أسبوع';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return 'منذ $months شهر';
    } else {
      final years = (difference.inDays / 365).floor();
      return 'منذ $years سنة';
    }
  }

  static String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'صباح الخير';
    } else if (hour < 17) {
      return 'مساء الخير';
    } else {
      return 'مساء الخير';
    }
  }

  // Health Calculations
  static double calculateBMI(double weight, double height) {
    if (height <= 0 || weight <= 0) return 0;
    final heightInMeters = height / 100;
    return weight / (heightInMeters * heightInMeters);
  }

  static String getBMICategory(double bmi) {
    if (bmi < 18.5) return 'نقص في الوزن';
    if (bmi < 25) return 'وزن طبيعي';
    if (bmi < 30) return 'زيادة في الوزن';
    return 'سمنة';
  }

  static Color getBMIColor(double bmi) {
    if (bmi < 18.5) return Colors.blue;
    if (bmi < 25) return Colors.green;
    if (bmi < 30) return Colors.orange;
    return Colors.red;
  }

  static double calculateIdealWeight(double height, String gender) {
    if (height <= 0) return 0;
    
    // Using Devine formula
    if (gender == 'ذكر') {
      return 50 + 2.3 * ((height - 152.4) / 2.54);
    } else {
      return 45.5 + 2.3 * ((height - 152.4) / 2.54);
    }
  }

  static int calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month || 
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  // Validation Helpers
  static bool isValidEmail(String email) {
    return RegExp(AppConstants.emailRegex).hasMatch(email);
  }

  static bool isValidPhone(String phone) {
    return RegExp(AppConstants.phoneRegex).hasMatch(phone);
  }

  static bool isValidName(String name) {
    return RegExp(AppConstants.nameRegex).hasMatch(name);
  }

  static String? validateRequired(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return fieldName != null 
          ? '$fieldName ${AppConstants.requiredFieldMessage}'
          : AppConstants.requiredFieldMessage;
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppConstants.requiredFieldMessage;
    }
    if (!isValidEmail(value)) {
      return AppConstants.invalidEmailMessage;
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppConstants.requiredFieldMessage;
    }
    if (!isValidPhone(value)) {
      return AppConstants.invalidPhoneMessage;
    }
    return null;
  }

  static String? validateAge(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppConstants.requiredFieldMessage;
    }
    final age = int.tryParse(value);
    if (age == null || age < AppConstants.minAge || age > AppConstants.maxAge) {
      return 'العمر يجب أن يكون بين ${AppConstants.minAge} و ${AppConstants.maxAge}';
    }
    return null;
  }

  static String? validateWeight(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppConstants.requiredFieldMessage;
    }
    final weight = double.tryParse(value);
    if (weight == null || weight < AppConstants.minWeight || weight > AppConstants.maxWeight) {
      return 'الوزن يجب أن يكون بين ${AppConstants.minWeight} و ${AppConstants.maxWeight} كجم';
    }
    return null;
  }

  static String? validateHeight(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppConstants.requiredFieldMessage;
    }
    final height = double.tryParse(value);
    if (height == null || height < AppConstants.minHeight || height > AppConstants.maxHeight) {
      return 'الطول يجب أن يكون بين ${AppConstants.minHeight} و ${AppConstants.maxHeight} سم';
    }
    return null;
  }

  // UI Helpers
  static void showSnackBar(BuildContext context, String message, {
    Color? backgroundColor,
    Color? textColor,
    IconData? icon,
    Duration? duration,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: textColor ?? Colors.white),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: textColor ?? Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        duration: duration ?? const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.normalRadius),
        ),
      ),
    );
  }

  static void showSuccessSnackBar(BuildContext context, String message) {
    showSnackBar(
      context,
      message,
      backgroundColor: Colors.green,
      icon: AppIcons.success,
    );
  }

  static void showErrorSnackBar(BuildContext context, String message) {
    showSnackBar(
      context,
      message,
      backgroundColor: Colors.red,
      icon: AppIcons.error,
    );
  }

  static void showWarningSnackBar(BuildContext context, String message) {
    showSnackBar(
      context,
      message,
      backgroundColor: Colors.orange,
      icon: AppIcons.warning,
    );
  }

  static void showInfoSnackBar(BuildContext context, String message) {
    showSnackBar(
      context,
      message,
      backgroundColor: Colors.blue,
      icon: AppIcons.info,
    );
  }

  static Future<bool?> showConfirmDialog(
    BuildContext context,
    String title,
    String message, {
    String? confirmText,
    String? cancelText,
    Color? confirmColor,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText ?? 'إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: confirmColor ?? Colors.red,
            ),
            child: Text(confirmText ?? 'تأكيد'),
          ),
        ],
      ),
    );
  }

  static void showLoadingDialog(BuildContext context, {String? message}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 16),
            Text(message ?? AppConstants.loadingMessage),
          ],
        ),
      ),
    );
  }

  static void hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  // String Helpers
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  static String removeHtmlTags(String htmlText) {
    return htmlText.replaceAll(RegExp(r'<[^>]*>'), '');
  }

  // Number Helpers
  static String formatNumber(double number, {int decimalPlaces = 1}) {
    return number.toStringAsFixed(decimalPlaces);
  }

  static String formatCurrency(double amount, {String currency = 'ريال'}) {
    return '${formatNumber(amount, decimalPlaces: 2)} $currency';
  }

  // Color Helpers
  static Color lighten(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return hslLight.toColor();
  }

  static Color darken(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }

  // Device Helpers
  static bool isTablet(BuildContext context) {
    final data = MediaQuery.of(context);
    return data.size.shortestSide >= 600;
  }

  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  // Search Helpers
  static List<T> filterList<T>(
    List<T> list,
    String query,
    String Function(T) getSearchText,
  ) {
    if (query.isEmpty) return list;
    
    final lowerQuery = query.toLowerCase();
    return list.where((item) {
      final searchText = getSearchText(item).toLowerCase();
      return searchText.contains(lowerQuery);
    }).toList();
  }

  // Health Helpers
  static String getHealthAdvice(double bmi) {
    if (bmi < 18.5) {
      return 'ننصح بزيادة الوزن تدريجياً من خلال نظام غذائي صحي ومتوازن';
    } else if (bmi < 25) {
      return 'وزنك مثالي! حافظ على نمط حياتك الصحي';
    } else if (bmi < 30) {
      return 'ننصح بفقدان بعض الوزن من خلال نظام غذائي صحي وممارسة الرياضة';
    } else {
      return 'ننصح بشدة بمراجعة طبيب مختص ووضع خطة لفقدان الوزن';
    }
  }

  static List<String> getHealthRecommendations(String activityLevel) {
    switch (activityLevel) {
      case 'قليل':
        return [
          'ابدأ بالمشي 15-20 دقيقة يومياً',
          'استخدم السلالم بدلاً من المصعد',
          'قم بتمارين الإطالة البسيطة',
          'اشرب المزيد من الماء',
        ];
      case 'متوسط':
        return [
          'زد مدة التمرين إلى 30-45 دقيقة',
          'أضف تمارين القوة مرتين أسبوعياً',
          'جرب أنشطة جديدة مثل السباحة أو الدراجة',
          'حافظ على نظام غذائي متوازن',
        ];
      case 'عالي':
        return [
          'حافظ على مستوى نشاطك الحالي',
          'تأكد من الحصول على راحة كافية',
          'نوع في التمارين لتجنب الملل',
          'راقب علامات الإفراط في التدريب',
        ];
      default:
        return ['ابدأ بنشاط بدني خفيف ومنتظم'];
    }
  }
}