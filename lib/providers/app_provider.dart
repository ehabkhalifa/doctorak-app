import 'package:flutter/material.dart';
import '../models/drug.dart';
import '../models/user_profile.dart';
import '../models/health_tip.dart';
import '../services/database_service.dart';
import '../services/cache_service.dart';
import '../services/error_service.dart';
import '../services/loading_service.dart';

class AppProvider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  final CacheService _cacheService = CacheService();
  final ErrorService _errorService = ErrorService();
  final LoadingStateManager _loadingManager = LoadingStateManager();

  List<Drug> _drugs = [];
  List<HealthTip> _healthTips = [];
  List<Symptom> _symptoms = [];
  UserProfile? _userProfile;
  String _searchQuery = '';

  // Getters
  List<Drug> get drugs => _drugs;
  List<HealthTip> get healthTips => _healthTips;
  List<Symptom> get symptoms => _symptoms;
  UserProfile? get userProfile => _userProfile;
  bool get isLoading => _loadingManager.isLoading(LoadingKeys.appInit);
  String get searchQuery => _searchQuery;

  // Loading state getters
  bool get isDrugsLoading => _loadingManager.isLoading(LoadingKeys.drugSearch);
  bool get isHealthTipsLoading => _loadingManager.isLoading(LoadingKeys.healthTips);
  bool get isSymptomsLoading => _loadingManager.isLoading(LoadingKeys.symptoms);
  bool get isRefreshing => _loadingManager.isRefreshing(LoadingKeys.dataRefresh);

  // Initialize data
  Future<void> initializeData() async {
    _loadingManager.setLoading(LoadingKeys.appInit, message: 'جاري تحميل البيانات...');
    notifyListeners();

    try {
      await _cacheService.init();

      // Try to load from cache first
      final cachedDrugs = await _cacheService.getCache<List<dynamic>>(CacheService.drugsKey);
      final cachedTips = await _cacheService.getCache<List<dynamic>>(CacheService.healthTipsKey);
      final cachedSymptoms = await _cacheService.getCache<List<dynamic>>(CacheService.symptomsKey);

      if (cachedDrugs != null && cachedTips != null && cachedSymptoms != null) {
        _drugs = cachedDrugs.map((e) => Drug.fromMap(e)).toList();
        _healthTips = cachedTips.map((e) => HealthTip.fromMap(e)).toList();
        _symptoms = cachedSymptoms.map((e) => Symptom.fromMap(e)).toList();
        _userProfile = await _databaseService.getUserProfile();

        _loadingManager.setSuccess(LoadingKeys.appInit);
        notifyListeners();
        return;
      }

      // Load from database if cache is empty
      _drugs = await _databaseService.getAllDrugs();
      _healthTips = await _databaseService.getAllHealthTips();
      _symptoms = await _databaseService.getAllSymptoms();
      _userProfile = await _databaseService.getUserProfile();

      // Cache the data
      await _cacheService.setCache(CacheService.drugsKey, _drugs.map((e) => e.toMap()).toList());
      await _cacheService.setCache(CacheService.healthTipsKey, _healthTips.map((e) => e.toMap()).toList());
      await _cacheService.setCache(CacheService.symptomsKey, _symptoms.map((e) => e.toMap()).toList());

      _loadingManager.setSuccess(LoadingKeys.appInit);
    } catch (e) {
      final error = _errorService.handleException(e, context: 'Initialize Data');
      _loadingManager.setError(LoadingKeys.appInit, message: error.message);
    }

    notifyListeners();
  }

  // Drug operations
  Future<void> searchDrugs(String query, [String? category]) async {
    _searchQuery = query;
    _loadingManager.setLoading(LoadingKeys.drugSearch, message: 'جاري البحث...');
    notifyListeners();

    try {
      // Check cache for search results
      final cacheKey = '${CacheService.searchResultsKey}_${query}_$category';
      final cachedResults = await _cacheService.getCache<List<dynamic>>(cacheKey);

      if (cachedResults != null) {
        _drugs = cachedResults.map((e) => Drug.fromMap(e)).toList();
        _loadingManager.setSuccess(LoadingKeys.drugSearch);
        notifyListeners();
        return;
      }

      if (query.isEmpty && (category == null || category == 'الكل')) {
        _drugs = await _databaseService.getAllDrugs();
      } else {
        _drugs = await _databaseService.searchDrugs(query);
        // Filter by category if specified
        if (category != null && category != 'الكل') {
          _drugs = _drugs.where((drug) => drug.category == category).toList();
        }
      }

      // Cache search results
      await _cacheService.setCache(cacheKey, _drugs.map((e) => e.toMap()).toList());
      _loadingManager.setSuccess(LoadingKeys.drugSearch);
    } catch (e) {
      final error = _errorService.handleException(e, context: 'Search Drugs');
      _loadingManager.setError(LoadingKeys.drugSearch, message: error.message);
    }

    notifyListeners();
  }

  // Health tips operations
  Future<void> loadHealthTips() async {
    _loadingManager.setLoading(LoadingKeys.healthTips, message: 'جاري تحميل النصائح...');
    notifyListeners();

    try {
      _healthTips = await _databaseService.getAllHealthTips();
      await _cacheService.setCache(CacheService.healthTipsKey, _healthTips.map((e) => e.toMap()).toList());
      _loadingManager.setSuccess(LoadingKeys.healthTips);
    } catch (e) {
      final error = _errorService.handleException(e, context: 'Load Health Tips');
      _loadingManager.setError(LoadingKeys.healthTips, message: error.message);
    }

    notifyListeners();
  }

  Future<void> loadHealthTipsByCategory(String category) async {
    _loadingManager.setLoading(LoadingKeys.healthTips, message: 'جاري تحميل النصائح...');
    notifyListeners();

    try {
      _healthTips = await _databaseService.getHealthTipsByCategory(category);
      _loadingManager.setSuccess(LoadingKeys.healthTips);
    } catch (e) {
      final error = _errorService.handleException(e, context: 'Load Health Tips by Category');
      _loadingManager.setError(LoadingKeys.healthTips, message: error.message);
    }

    notifyListeners();
  }

  // Symptom operations
  Future<void> searchSymptoms(String query) async {
    _loadingManager.setLoading(LoadingKeys.symptoms, message: 'جاري البحث في الأعراض...');
    notifyListeners();

    try {
      if (query.isEmpty) {
        _symptoms = await _databaseService.getAllSymptoms();
      } else {
        _symptoms = await _databaseService.searchSymptoms(query);
      }

      await _cacheService.setCache(CacheService.symptomsKey, _symptoms.map((e) => e.toMap()).toList());
      _loadingManager.setSuccess(LoadingKeys.symptoms);
    } catch (e) {
      final error = _errorService.handleException(e, context: 'Search Symptoms');
      _loadingManager.setError(LoadingKeys.symptoms, message: error.message);
    }

    notifyListeners();
  }

  // User profile operations
  Future<void> saveUserProfile(UserProfile profile) async {
    try {
      if (_userProfile == null) {
        await _databaseService.insertUserProfile(profile);
      } else {
        await _databaseService.updateUserProfile(profile);
      }
      _userProfile = profile;
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving user profile: $e');
    }
  }

  Future<void> loadUserProfile() async {
    try {
      _userProfile = await _databaseService.getUserProfile();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading user profile: $e');
    }
  }

  // Clear search
  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  // Refresh all data
  Future<void> refreshData() async {
    _loadingManager.setRefreshing(LoadingKeys.dataRefresh, message: 'جاري تحديث البيانات...');
    notifyListeners();

    try {
      // Clear cache first
      await _cacheService.clearCache();

      // إعادة تحميل البيانات من قاعدة البيانات
      await _databaseService.refreshAllData();

      // إعادة تحميل البيانات في التطبيق
      await searchDrugs(''); // تحميل جميع الأدوية
      await loadHealthTips(); // تحميل النصائح الصحية
      await searchSymptoms(''); // تحميل جميع الأعراض
      await loadUserProfile(); // تحميل الملف الشخصي

      _loadingManager.setSuccess(LoadingKeys.dataRefresh, message: 'تم تحديث البيانات بنجاح');
    } catch (e) {
      final error = _errorService.handleException(e, context: 'Refresh Data');
      _loadingManager.setError(LoadingKeys.dataRefresh, message: error.message);
    }

    notifyListeners();
  }

  // Get database statistics
  Future<Map<String, int>> getDatabaseStats() async {
    return await _databaseService.getDatabaseStats();
  }
}