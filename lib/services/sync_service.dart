import 'package:flutter/foundation.dart';
import 'database_service.dart';
import 'cache_service.dart';
import 'error_service.dart';

enum SyncStatus {
  synced,
  outOfSync,
  syncing,
  error,
}

class SyncInfo {
  final String component;
  final SyncStatus status;
  final DateTime lastSync;
  final String? errorMessage;
  final int itemCount;

  SyncInfo({
    required this.component,
    required this.status,
    required this.lastSync,
    this.errorMessage,
    required this.itemCount,
  });

  @override
  String toString() {
    return 'SyncInfo(component: $component, status: $status, lastSync: $lastSync, itemCount: $itemCount)';
  }
}

class SyncService {
  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;
  SyncService._internal();

  final DatabaseService _databaseService = DatabaseService();
  final CacheService _cacheService = CacheService();
  final ErrorService _errorService = ErrorService();

  final Map<String, DateTime> _lastSyncTimes = {};
  final Map<String, SyncStatus> _syncStatuses = {};

  // Check overall sync status
  Future<Map<String, SyncInfo>> checkSyncStatus() async {
    final Map<String, SyncInfo> syncInfo = {};

    try {
      // Check database stats
      final dbStats = await _databaseService.getDatabaseStats();
      
      // Check each component
      syncInfo['drugs'] = await _checkComponentSync('drugs', dbStats['drugs'] ?? 0);
      syncInfo['health_tips'] = await _checkComponentSync('health_tips', dbStats['health_tips'] ?? 0);
      syncInfo['symptoms'] = await _checkComponentSync('symptoms', dbStats['symptoms'] ?? 0);
      syncInfo['user_profiles'] = await _checkComponentSync('user_profiles', dbStats['user_profiles'] ?? 0);

      // Check cache consistency
      syncInfo['cache'] = await _checkCacheSync();

    } catch (e) {
      final error = _errorService.handleException(e, context: 'Check Sync Status');
      
      // Return error status for all components
      for (final component in ['drugs', 'health_tips', 'symptoms', 'user_profiles', 'cache']) {
        syncInfo[component] = SyncInfo(
          component: component,
          status: SyncStatus.error,
          lastSync: DateTime.now(),
          errorMessage: error.message,
          itemCount: 0,
        );
      }
    }

    return syncInfo;
  }

  Future<SyncInfo> _checkComponentSync(String component, int itemCount) async {
    final lastSync = _lastSyncTimes[component] ?? DateTime.fromMillisecondsSinceEpoch(0);
    final status = _syncStatuses[component] ?? SyncStatus.synced;

    // Check if data exists
    if (itemCount == 0) {
      return SyncInfo(
        component: component,
        status: SyncStatus.outOfSync,
        lastSync: lastSync,
        errorMessage: 'لا توجد بيانات في $component',
        itemCount: itemCount,
      );
    }

    // Check if sync is recent (within last hour)
    final timeSinceSync = DateTime.now().difference(lastSync);
    if (timeSinceSync.inHours > 1) {
      return SyncInfo(
        component: component,
        status: SyncStatus.outOfSync,
        lastSync: lastSync,
        errorMessage: 'آخر مزامنة منذ ${timeSinceSync.inHours} ساعة',
        itemCount: itemCount,
      );
    }

    return SyncInfo(
      component: component,
      status: status,
      lastSync: lastSync,
      itemCount: itemCount,
    );
  }

  Future<SyncInfo> _checkCacheSync() async {
    try {
      await _cacheService.init();
      
      // Check if cache has data
      final cachedDrugs = await _cacheService.getCache<List<dynamic>>(CacheService.drugsKey);
      final cachedTips = await _cacheService.getCache<List<dynamic>>(CacheService.healthTipsKey);
      final cachedSymptoms = await _cacheService.getCache<List<dynamic>>(CacheService.symptomsKey);

      int cacheItemCount = 0;
      if (cachedDrugs != null) cacheItemCount += cachedDrugs.length;
      if (cachedTips != null) cacheItemCount += cachedTips.length;
      if (cachedSymptoms != null) cacheItemCount += cachedSymptoms.length;

      final status = cacheItemCount > 0 ? SyncStatus.synced : SyncStatus.outOfSync;
      final lastSync = _lastSyncTimes['cache'] ?? DateTime.fromMillisecondsSinceEpoch(0);

      return SyncInfo(
        component: 'cache',
        status: status,
        lastSync: lastSync,
        itemCount: cacheItemCount,
      );

    } catch (e) {
      return SyncInfo(
        component: 'cache',
        status: SyncStatus.error,
        lastSync: DateTime.now(),
        errorMessage: 'خطأ في فحص الكاش: ${e.toString()}',
        itemCount: 0,
      );
    }
  }

  // Force sync all data
  Future<bool> forceSyncAll() async {
    try {
      _updateSyncStatus('all', SyncStatus.syncing);

      // Clear cache
      await _cacheService.clearCache();

      // Refresh database
      await _databaseService.refreshAllData();

      // Update sync times
      final now = DateTime.now();
      _lastSyncTimes['drugs'] = now;
      _lastSyncTimes['health_tips'] = now;
      _lastSyncTimes['symptoms'] = now;
      _lastSyncTimes['user_profiles'] = now;
      _lastSyncTimes['cache'] = now;

      // Update statuses
      _updateSyncStatus('drugs', SyncStatus.synced);
      _updateSyncStatus('health_tips', SyncStatus.synced);
      _updateSyncStatus('symptoms', SyncStatus.synced);
      _updateSyncStatus('user_profiles', SyncStatus.synced);
      _updateSyncStatus('cache', SyncStatus.synced);

      if (kDebugMode) {
        debugPrint('✅ Force sync completed successfully');
      }

      return true;
    } catch (e) {
      final error = _errorService.handleException(e, context: 'Force Sync All');
      
      _updateSyncStatus('all', SyncStatus.error);
      
      if (kDebugMode) {
        debugPrint('❌ Force sync failed: ${error.message}');
      }

      return false;
    }
  }

  // Update sync status for a component
  void _updateSyncStatus(String component, SyncStatus status) {
    if (component == 'all') {
      _syncStatuses['drugs'] = status;
      _syncStatuses['health_tips'] = status;
      _syncStatuses['symptoms'] = status;
      _syncStatuses['user_profiles'] = status;
      _syncStatuses['cache'] = status;
    } else {
      _syncStatuses[component] = status;
    }
  }

  // Mark component as synced
  void markAsSynced(String component) {
    _lastSyncTimes[component] = DateTime.now();
    _syncStatuses[component] = SyncStatus.synced;
  }

  // Get sync summary
  Future<String> getSyncSummary() async {
    final syncInfo = await checkSyncStatus();
    final buffer = StringBuffer();
    
    buffer.writeln('📊 حالة المزامنة:');
    buffer.writeln('');
    
    for (final info in syncInfo.values) {
      final statusIcon = _getStatusIcon(info.status);
      buffer.writeln('$statusIcon ${info.component}: ${info.itemCount} عنصر');
      
      if (info.errorMessage != null) {
        buffer.writeln('   ⚠️ ${info.errorMessage}');
      }
      
      buffer.writeln('   📅 آخر مزامنة: ${_formatDateTime(info.lastSync)}');
      buffer.writeln('');
    }
    
    return buffer.toString();
  }

  String _getStatusIcon(SyncStatus status) {
    switch (status) {
      case SyncStatus.synced:
        return '✅';
      case SyncStatus.outOfSync:
        return '⚠️';
      case SyncStatus.syncing:
        return '🔄';
      case SyncStatus.error:
        return '❌';
    }
  }

  String _formatDateTime(DateTime dateTime) {
    if (dateTime.millisecondsSinceEpoch == 0) {
      return 'لم تتم المزامنة بعد';
    }
    
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 1) {
      return 'الآن';
    } else if (difference.inHours < 1) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else if (difference.inDays < 1) {
      return 'منذ ${difference.inHours} ساعة';
    } else {
      return 'منذ ${difference.inDays} يوم';
    }
  }
}
