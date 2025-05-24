import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class AssetsService {
  static final AssetsService _instance = AssetsService._internal();
  factory AssetsService() => _instance;
  AssetsService._internal();

  // Cache for loaded JSON data
  final Map<String, dynamic> _jsonCache = {};

  // Asset paths
  static const String _imagesPath = 'assets/images/';
  static const String _iconsPath = 'assets/icons/';
  static const String _dataPath = 'assets/data/';

  // Load JSON data from assets
  Future<Map<String, dynamic>> loadJsonData(String fileName) async {
    // Check cache first
    if (_jsonCache.containsKey(fileName)) {
      return _jsonCache[fileName];
    }

    try {
      final String jsonString = await rootBundle.loadString('$_dataPath$fileName');
      final Map<String, dynamic> data = json.decode(jsonString);
      
      // Cache the data
      _jsonCache[fileName] = data;
      
      if (kDebugMode) {
        debugPrint('✅ Loaded JSON data: $fileName');
      }
      
      return data;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error loading JSON data: $fileName - $e');
      }
      return {};
    }
  }

  // Load app information
  Future<Map<String, dynamic>> loadAppInfo() async {
    return await loadJsonData('app_info.json');
  }

  // Load emergency drugs data
  Future<Map<String, dynamic>> loadEmergencyDrugs() async {
    return await loadJsonData('emergency_drugs.json');
  }

  // Get image asset path
  String getImagePath(String imageName) {
    return '$_imagesPath$imageName';
  }

  // Get icon asset path
  String getIconPath(String iconName) {
    return '$_iconsPath$iconName';
  }

  // Check if asset exists
  Future<bool> assetExists(String assetPath) async {
    try {
      await rootBundle.load(assetPath);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Get app categories from app_info.json
  Future<List<Map<String, dynamic>>> getAppCategories() async {
    try {
      final appInfo = await loadAppInfo();
      return List<Map<String, dynamic>>.from(appInfo['categories'] ?? []);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error loading app categories: $e');
      }
      return [];
    }
  }

  // Get health tips categories
  Future<List<Map<String, dynamic>>> getHealthTipsCategories() async {
    try {
      final appInfo = await loadAppInfo();
      return List<Map<String, dynamic>>.from(appInfo['health_tips_categories'] ?? []);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error loading health tips categories: $e');
      }
      return [];
    }
  }

  // Get emergency contacts
  Future<List<Map<String, dynamic>>> getEmergencyContacts() async {
    try {
      final appInfo = await loadAppInfo();
      return List<Map<String, dynamic>>.from(appInfo['emergency_contacts'] ?? []);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error loading emergency contacts: $e');
      }
      return [];
    }
  }

  // Get app settings
  Future<Map<String, dynamic>> getAppSettings() async {
    try {
      final appInfo = await loadAppInfo();
      return Map<String, dynamic>.from(appInfo['app_settings'] ?? {});
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error loading app settings: $e');
      }
      return {};
    }
  }

  // Get emergency drugs list
  Future<List<Map<String, dynamic>>> getEmergencyDrugsList() async {
    try {
      final emergencyData = await loadEmergencyDrugs();
      return List<Map<String, dynamic>>.from(emergencyData['emergency_drugs'] ?? []);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error loading emergency drugs: $e');
      }
      return [];
    }
  }

  // Get first aid instructions
  Future<List<Map<String, dynamic>>> getFirstAidInstructions() async {
    try {
      final emergencyData = await loadEmergencyDrugs();
      return List<Map<String, dynamic>>.from(emergencyData['first_aid_instructions'] ?? []);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error loading first aid instructions: $e');
      }
      return [];
    }
  }

  // Get emergency numbers
  Future<Map<String, String>> getEmergencyNumbers() async {
    try {
      final emergencyData = await loadEmergencyDrugs();
      final numbers = emergencyData['emergency_numbers'] ?? {};
      return Map<String, String>.from(numbers);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error loading emergency numbers: $e');
      }
      return {};
    }
  }

  // Clear cache
  void clearCache() {
    _jsonCache.clear();
    if (kDebugMode) {
      debugPrint('🗑️ Assets cache cleared');
    }
  }

  // Get cache info
  Map<String, dynamic> getCacheInfo() {
    return {
      'cached_files': _jsonCache.keys.toList(),
      'cache_size': _jsonCache.length,
    };
  }

  // Preload essential data
  Future<void> preloadEssentialData() async {
    try {
      if (kDebugMode) {
        debugPrint('🔄 Preloading essential assets data...');
      }

      // Preload app info and emergency data
      await Future.wait([
        loadAppInfo(),
        loadEmergencyDrugs(),
      ]);

      if (kDebugMode) {
        debugPrint('✅ Essential assets data preloaded successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error preloading essential data: $e');
      }
    }
  }

  // Get asset loading status
  Future<Map<String, bool>> getAssetLoadingStatus() async {
    final status = <String, bool>{};
    
    final essentialFiles = [
      'app_info.json',
      'emergency_drugs.json',
    ];

    for (final file in essentialFiles) {
      try {
        await rootBundle.loadString('$_dataPath$file');
        status[file] = true;
      } catch (e) {
        status[file] = false;
      }
    }

    return status;
  }

  // Validate assets integrity
  Future<List<String>> validateAssetsIntegrity() async {
    final issues = <String>[];

    try {
      // Check if essential JSON files are valid
      final appInfo = await loadAppInfo();
      if (appInfo.isEmpty) {
        issues.add('app_info.json is empty or invalid');
      }

      final emergencyData = await loadEmergencyDrugs();
      if (emergencyData.isEmpty) {
        issues.add('emergency_drugs.json is empty or invalid');
      }

      // Check required fields in app_info.json
      final requiredAppInfoFields = [
        'app_name',
        'app_version',
        'categories',
        'health_tips_categories'
      ];

      for (final field in requiredAppInfoFields) {
        if (!appInfo.containsKey(field)) {
          issues.add('Missing required field in app_info.json: $field');
        }
      }

      // Check required fields in emergency_drugs.json
      final requiredEmergencyFields = [
        'emergency_drugs',
        'first_aid_instructions',
        'emergency_numbers'
      ];

      for (final field in requiredEmergencyFields) {
        if (!emergencyData.containsKey(field)) {
          issues.add('Missing required field in emergency_drugs.json: $field');
        }
      }

    } catch (e) {
      issues.add('Error validating assets: $e');
    }

    return issues;
  }
}
