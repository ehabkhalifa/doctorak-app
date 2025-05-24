import 'package:flutter/material.dart';

class AppIcons {
  // Health Icons
  static const IconData heart = Icons.favorite_rounded;
  static const IconData heartbeat = Icons.monitor_heart_rounded;
  static const IconData health = Icons.health_and_safety_rounded;
  static const IconData medical = Icons.medical_services_rounded;
  static const IconData pharmacy = Icons.local_pharmacy_rounded;
  static const IconData hospital = Icons.local_hospital_rounded;
  
  // Drug Icons
  static const IconData pill = Icons.medication_rounded;
  static const IconData capsule = Icons.medication_liquid_rounded;
  static const IconData syringe = Icons.vaccines_rounded;
  static const IconData prescription = Icons.receipt_long_rounded;
  
  // Symptom Icons
  static const IconData headache = Icons.psychology_rounded;
  static const IconData fever = Icons.thermostat_rounded;
  static const IconData pain = Icons.healing_rounded;
  static const IconData fatigue = Icons.battery_0_bar_rounded;
  static const IconData nausea = Icons.sick_rounded;
  
  // Wellness Icons
  static const IconData exercise = Icons.fitness_center_rounded;
  static const IconData nutrition = Icons.restaurant_rounded;
  static const IconData sleep = Icons.bedtime_rounded;
  static const IconData meditation = Icons.self_improvement_rounded;
  static const IconData water = Icons.water_drop_rounded;
  
  // Navigation Icons
  static const IconData home = Icons.home_rounded;
  static const IconData search = Icons.search_rounded;
  static const IconData tips = Icons.tips_and_updates_rounded;
  static const IconData analysis = Icons.analytics_rounded;
  static const IconData profile = Icons.person_rounded;
  
  // Action Icons
  static const IconData add = Icons.add_rounded;
  static const IconData edit = Icons.edit_rounded;
  static const IconData delete = Icons.delete_rounded;
  static const IconData save = Icons.save_rounded;
  static const IconData share = Icons.share_rounded;
  static const IconData bookmark = Icons.bookmark_rounded;
  static const IconData favorite = Icons.favorite_rounded;
  
  // Status Icons
  static const IconData success = Icons.check_circle_rounded;
  static const IconData warning = Icons.warning_rounded;
  static const IconData error = Icons.error_rounded;
  static const IconData info = Icons.info_rounded;
  
  // Category Icons
  static const IconData vitamins = Icons.science_rounded;
  static const IconData supplements = Icons.biotech_rounded;
  static const IconData antibiotics = Icons.coronavirus_rounded;
  static const IconData painkillers = Icons.healing_rounded;
  
  // Time Icons
  static const IconData morning = Icons.wb_sunny_rounded;
  static const IconData afternoon = Icons.wb_cloudy_rounded;
  static const IconData evening = Icons.nights_stay_rounded;
  static const IconData night = Icons.bedtime_rounded;
  
  // Measurement Icons
  static const IconData weight = Icons.monitor_weight_rounded;
  static const IconData height = Icons.height_rounded;
  static const IconData bmi = Icons.calculate_rounded;
  static const IconData temperature = Icons.device_thermostat_rounded;
  
  // Communication Icons
  static const IconData notification = Icons.notifications_rounded;
  static const IconData message = Icons.message_rounded;
  static const IconData call = Icons.call_rounded;
  static const IconData email = Icons.email_rounded;
  
  // Settings Icons
  static const IconData settings = Icons.settings_rounded;
  static const IconData language = Icons.language_rounded;
  static const IconData theme = Icons.palette_rounded;
  static const IconData privacy = Icons.privacy_tip_rounded;
  
  // Custom Health Category Colors
  static const Map<String, Color> categoryColors = {
    'مسكنات': Color(0xFF3498DB),
    'مضادات الالتهاب': Color(0xFF2ECC71),
    'مضادات حيوية': Color(0xFFE74C3C),
    'فيتامينات': Color(0xFFF39C12),
    'أدوية القلب': Color(0xFF9B59B6),
    'أدوية الضغط': Color(0xFF1ABC9C),
    'أدوية السكري': Color(0xFFE67E22),
    'مكملات غذائية': Color(0xFF34495E),
  };
  
  // Health Tip Category Colors
  static const Map<String, Color> tipCategoryColors = {
    'تغذية': Color(0xFF27AE60),
    'رياضة': Color(0xFF3498DB),
    'نوم': Color(0xFF8E44AD),
    'صحة نفسية': Color(0xFFE91E63),
    'وقاية': Color(0xFFFF9800),
    'علاج طبيعي': Color(0xFF009688),
  };
  
  // Severity Colors
  static const Map<String, Color> severityColors = {
    'خفيف': Color(0xFF4CAF50),
    'متوسط': Color(0xFFFF9800),
    'شديد': Color(0xFFF44336),
  };
  
  // BMI Colors
  static const Map<String, Color> bmiColors = {
    'نقص في الوزن': Color(0xFF2196F3),
    'وزن طبيعي': Color(0xFF4CAF50),
    'زيادة في الوزن': Color(0xFFFF9800),
    'سمنة': Color(0xFFF44336),
  };
  
  // Activity Level Colors
  static const Map<String, Color> activityColors = {
    'قليل': Color(0xFFF44336),
    'متوسط': Color(0xFFFF9800),
    'عالي': Color(0xFF4CAF50),
  };
  
  // Helper method to get category icon
  static IconData getCategoryIcon(String category) {
    switch (category) {
      case 'مسكنات':
        return painkillers;
      case 'مضادات الالتهاب':
        return pain;
      case 'مضادات حيوية':
        return antibiotics;
      case 'فيتامينات':
        return vitamins;
      case 'أدوية القلب':
        return heartbeat;
      case 'أدوية الضغط':
        return medical;
      case 'أدوية السكري':
        return pill;
      case 'مكملات غذائية':
        return supplements;
      case 'تغذية':
        return nutrition;
      case 'رياضة':
        return exercise;
      case 'نوم':
        return sleep;
      case 'صحة نفسية':
        return meditation;
      case 'وقاية':
        return health;
      case 'علاج طبيعي':
        return pain;
      default:
        return medical;
    }
  }
  
  // Helper method to get category color
  static Color getCategoryColor(String category) {
    return categoryColors[category] ?? 
           tipCategoryColors[category] ?? 
           const Color(0xFF6C757D);
  }
  
  // Helper method to get severity color
  static Color getSeverityColor(String severity) {
    return severityColors[severity] ?? const Color(0xFF6C757D);
  }
  
  // Helper method to get BMI color
  static Color getBMIColor(String bmiCategory) {
    return bmiColors[bmiCategory] ?? const Color(0xFF6C757D);
  }
  
  // Helper method to get activity color
  static Color getActivityColor(String activityLevel) {
    return activityColors[activityLevel] ?? const Color(0xFF6C757D);
  }
  
  // Animated Icons
  static Widget getAnimatedIcon(IconData icon, {
    Color? color,
    double? size,
    Duration? duration,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.8, end: 1.0),
      duration: duration ?? const Duration(milliseconds: 600),
      curve: Curves.elasticOut,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: Icon(
            icon,
            color: color,
            size: size,
          ),
        );
      },
    );
  }
}