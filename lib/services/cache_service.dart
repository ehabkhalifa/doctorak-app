import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/app_constants.dart';

class CacheService {
  static final CacheService _instance = CacheService._internal();
  factory CacheService() => _instance;
  CacheService._internal();

  SharedPreferences? _prefs;
  final Map<String, dynamic> _memoryCache = {};
  final Map<String, DateTime> _cacheTimestamps = {};

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Memory Cache Operations
  void setMemoryCache(String key, dynamic value) {
    _memoryCache[key] = value;
    _cacheTimestamps[key] = DateTime.now();
  }

  T? getMemoryCache<T>(String key) {
    if (!_memoryCache.containsKey(key)) return null;
    
    final timestamp = _cacheTimestamps[key];
    if (timestamp != null && 
        DateTime.now().difference(timestamp) > AppConstants.cacheExpiration) {
      _memoryCache.remove(key);
      _cacheTimestamps.remove(key);
      return null;
    }
    
    return _memoryCache[key] as T?;
  }

  // Persistent Cache Operations
  Future<void> setCache(String key, dynamic value) async {
    await init();
    final data = {
      'value': value,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    await _prefs!.setString(key, jsonEncode(data));
    setMemoryCache(key, value);
  }

  Future<T?> getCache<T>(String key) async {
    // Check memory cache first
    final memoryValue = getMemoryCache<T>(key);
    if (memoryValue != null) return memoryValue;

    // Check persistent cache
    await init();
    final cachedData = _prefs!.getString(key);
    if (cachedData == null) return null;

    try {
      final data = jsonDecode(cachedData);
      final timestamp = DateTime.fromMillisecondsSinceEpoch(data['timestamp']);
      
      if (DateTime.now().difference(timestamp) > AppConstants.cacheExpiration) {
        await _prefs!.remove(key);
        return null;
      }

      final value = data['value'] as T;
      setMemoryCache(key, value);
      return value;
    } catch (e) {
      await _prefs!.remove(key);
      return null;
    }
  }

  Future<void> removeCache(String key) async {
    await init();
    await _prefs!.remove(key);
    _memoryCache.remove(key);
    _cacheTimestamps.remove(key);
  }

  Future<void> clearCache() async {
    await init();
    await _prefs!.clear();
    _memoryCache.clear();
    _cacheTimestamps.clear();
  }

  // Cache Keys
  static const String drugsKey = 'cached_drugs';
  static const String healthTipsKey = 'cached_health_tips';
  static const String symptomsKey = 'cached_symptoms';
  static const String userProfileKey = 'cached_user_profile';
  static const String searchResultsKey = 'cached_search_results';
}
