import 'package:flutter/foundation.dart';
import '../services/database_service.dart';
import '../services/cache_service.dart';
import '../services/sync_service.dart';
import '../services/performance_service.dart';
import '../services/error_service.dart';

class AppDiagnostics {
  static final AppDiagnostics _instance = AppDiagnostics._internal();
  factory AppDiagnostics() => _instance;
  AppDiagnostics._internal();

  final DatabaseService _databaseService = DatabaseService();
  final CacheService _cacheService = CacheService();
  final SyncService _syncService = SyncService();
  final PerformanceService _performanceService = PerformanceService();
  final ErrorService _errorService = ErrorService();

  // Run comprehensive diagnostics
  Future<String> runDiagnostics() async {
    final buffer = StringBuffer();
    
    buffer.writeln('🔍 تشخيص شامل للتطبيق');
    buffer.writeln('=' * 50);
    buffer.writeln('');

    // 1. Database Status
    buffer.writeln(await _checkDatabaseStatus());
    buffer.writeln('');

    // 2. Cache Status
    buffer.writeln(await _checkCacheStatus());
    buffer.writeln('');

    // 3. Sync Status
    buffer.writeln(await _checkSyncStatus());
    buffer.writeln('');

    // 4. Performance Status
    buffer.writeln(_checkPerformanceStatus());
    buffer.writeln('');

    // 5. Error Status
    buffer.writeln(_checkErrorStatus());
    buffer.writeln('');

    // 6. Overall Health Score
    buffer.writeln(await _calculateHealthScore());

    return buffer.toString();
  }

  Future<String> _checkDatabaseStatus() async {
    final buffer = StringBuffer();
    buffer.writeln('📊 حالة قاعدة البيانات:');
    
    try {
      final stats = await _databaseService.getDatabaseStats();
      
      buffer.writeln('✅ قاعدة البيانات متصلة');
      buffer.writeln('   📋 الأدوية: ${stats['drugs']} عنصر');
      buffer.writeln('   💡 النصائح الصحية: ${stats['health_tips']} عنصر');
      buffer.writeln('   🩺 الأعراض: ${stats['symptoms']} عنصر');
      buffer.writeln('   👤 الملفات الشخصية: ${stats['user_profiles']} عنصر');
      
      // Check for empty tables
      final emptyTables = stats.entries.where((e) => e.value == 0).map((e) => e.key).toList();
      if (emptyTables.isNotEmpty) {
        buffer.writeln('   ⚠️ جداول فارغة: ${emptyTables.join(', ')}');
      }
      
    } catch (e) {
      buffer.writeln('❌ خطأ في قاعدة البيانات: ${e.toString()}');
    }
    
    return buffer.toString();
  }

  Future<String> _checkCacheStatus() async {
    final buffer = StringBuffer();
    buffer.writeln('💾 حالة الكاش:');
    
    try {
      await _cacheService.init();
      
      final cachedDrugs = await _cacheService.getCache<List<dynamic>>(CacheService.drugsKey);
      final cachedTips = await _cacheService.getCache<List<dynamic>>(CacheService.healthTipsKey);
      final cachedSymptoms = await _cacheService.getCache<List<dynamic>>(CacheService.symptomsKey);
      
      buffer.writeln('✅ الكاش يعمل بشكل صحيح');
      buffer.writeln('   📋 الأدوية المحفوظة: ${cachedDrugs?.length ?? 0}');
      buffer.writeln('   💡 النصائح المحفوظة: ${cachedTips?.length ?? 0}');
      buffer.writeln('   🩺 الأعراض المحفوظة: ${cachedSymptoms?.length ?? 0}');
      
      final totalCached = (cachedDrugs?.length ?? 0) + 
                         (cachedTips?.length ?? 0) + 
                         (cachedSymptoms?.length ?? 0);
      
      if (totalCached == 0) {
        buffer.writeln('   ⚠️ الكاش فارغ - قد يحتاج إعادة تحميل');
      }
      
    } catch (e) {
      buffer.writeln('❌ خطأ في الكاش: ${e.toString()}');
    }
    
    return buffer.toString();
  }

  Future<String> _checkSyncStatus() async {
    final buffer = StringBuffer();
    buffer.writeln('🔄 حالة المزامنة:');
    
    try {
      final syncInfo = await _syncService.checkSyncStatus();
      
      int syncedCount = 0;
      int totalCount = syncInfo.length;
      
      for (final info in syncInfo.values) {
        final statusIcon = _getStatusIcon(info.status);
        buffer.writeln('   $statusIcon ${info.component}: ${info.status.name}');
        
        if (info.status == SyncStatus.synced) {
          syncedCount++;
        }
        
        if (info.errorMessage != null) {
          buffer.writeln('      ⚠️ ${info.errorMessage}');
        }
      }
      
      final syncPercentage = (syncedCount / totalCount * 100).round();
      buffer.writeln('   📊 نسبة المزامنة: $syncPercentage%');
      
    } catch (e) {
      buffer.writeln('❌ خطأ في فحص المزامنة: ${e.toString()}');
    }
    
    return buffer.toString();
  }

  String _checkPerformanceStatus() {
    final buffer = StringBuffer();
    buffer.writeln('⚡ حالة الأداء:');
    
    try {
      final metrics = _performanceService.getMetrics();
      final averages = _performanceService.getAverageOperationTimes();
      
      buffer.writeln('✅ مراقب الأداء يعمل');
      buffer.writeln('   📈 العمليات المسجلة: ${metrics.length}');
      
      if (averages.isNotEmpty) {
        buffer.writeln('   ⏱️ متوسط أوقات العمليات:');
        for (final entry in averages.entries) {
          final isSlowOperation = _performanceService.isSlowOperation(entry.value);
          final icon = isSlowOperation ? '🐌' : '⚡';
          buffer.writeln('      $icon ${entry.key}: ${entry.value.inMilliseconds}ms');
        }
      }
      
      // Check for slow operations
      final slowOps = metrics.where((m) => _performanceService.isSlowOperation(m.duration)).length;
      if (slowOps > 0) {
        buffer.writeln('   ⚠️ عمليات بطيئة: $slowOps');
      }
      
    } catch (e) {
      buffer.writeln('❌ خطأ في فحص الأداء: ${e.toString()}');
    }
    
    return buffer.toString();
  }

  String _checkErrorStatus() {
    final buffer = StringBuffer();
    buffer.writeln('🚨 حالة الأخطاء:');
    
    try {
      final recentErrors = _errorService.getRecentErrors(limit: 5);
      
      if (recentErrors.isEmpty) {
        buffer.writeln('✅ لا توجد أخطاء حديثة');
      } else {
        buffer.writeln('⚠️ أخطاء حديثة: ${recentErrors.length}');
        
        for (final error in recentErrors) {
          final typeIcon = _getErrorTypeIcon(error.type);
          buffer.writeln('   $typeIcon ${error.message}');
        }
      }
      
    } catch (e) {
      buffer.writeln('❌ خطأ في فحص الأخطاء: ${e.toString()}');
    }
    
    return buffer.toString();
  }

  Future<String> _calculateHealthScore() async {
    final buffer = StringBuffer();
    buffer.writeln('🎯 نقاط صحة التطبيق:');
    
    int score = 100;
    final issues = <String>[];
    
    try {
      // Check database
      final dbStats = await _databaseService.getDatabaseStats();
      final emptyTables = dbStats.values.where((count) => count == 0).length;
      if (emptyTables > 0) {
        score -= emptyTables * 15;
        issues.add('جداول فارغة في قاعدة البيانات');
      }
      
      // Check sync
      final syncInfo = await _syncService.checkSyncStatus();
      final outOfSyncCount = syncInfo.values.where((info) => info.status != SyncStatus.synced).length;
      if (outOfSyncCount > 0) {
        score -= outOfSyncCount * 10;
        issues.add('مكونات غير متزامنة');
      }
      
      // Check errors
      final recentErrors = _errorService.getRecentErrors(limit: 10);
      if (recentErrors.isNotEmpty) {
        score -= recentErrors.length * 5;
        issues.add('أخطاء حديثة');
      }
      
      // Check performance
      final metrics = _performanceService.getMetrics();
      final slowOps = metrics.where((m) => _performanceService.isSlowOperation(m.duration)).length;
      if (slowOps > 0) {
        score -= slowOps * 3;
        issues.add('عمليات بطيئة');
      }
      
      score = score.clamp(0, 100);
      
      final healthIcon = _getHealthIcon(score);
      buffer.writeln('$healthIcon النقاط: $score/100');
      
      if (issues.isNotEmpty) {
        buffer.writeln('   🔧 مشاكل تحتاج إصلاح:');
        for (final issue in issues) {
          buffer.writeln('      • $issue');
        }
      }
      
      if (score >= 90) {
        buffer.writeln('   🎉 التطبيق في حالة ممتازة!');
      } else if (score >= 70) {
        buffer.writeln('   👍 التطبيق في حالة جيدة');
      } else if (score >= 50) {
        buffer.writeln('   ⚠️ التطبيق يحتاج بعض التحسينات');
      } else {
        buffer.writeln('   🚨 التطبيق يحتاج إصلاحات عاجلة');
      }
      
    } catch (e) {
      buffer.writeln('❌ خطأ في حساب نقاط الصحة: ${e.toString()}');
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

  String _getErrorTypeIcon(ErrorType type) {
    switch (type) {
      case ErrorType.network:
        return '🌐';
      case ErrorType.database:
        return '💾';
      case ErrorType.validation:
        return '✏️';
      case ErrorType.permission:
        return '🔒';
      case ErrorType.unknown:
        return '❓';
    }
  }

  String _getHealthIcon(int score) {
    if (score >= 90) return '🟢';
    if (score >= 70) return '🟡';
    if (score >= 50) return '🟠';
    return '🔴';
  }

  // Quick health check
  Future<bool> isAppHealthy() async {
    try {
      final dbStats = await _databaseService.getDatabaseStats();
      final syncInfo = await _syncService.checkSyncStatus();
      final recentErrors = _errorService.getRecentErrors(limit: 5);
      
      // Check if database has data
      final hasData = dbStats.values.any((count) => count > 0);
      
      // Check if most components are synced
      final syncedCount = syncInfo.values.where((info) => info.status == SyncStatus.synced).length;
      final mostlySynced = syncedCount >= (syncInfo.length * 0.7);
      
      // Check if no critical errors
      final noCriticalErrors = recentErrors.length < 3;
      
      return hasData && mostlySynced && noCriticalErrors;
      
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error checking app health: $e');
      }
      return false;
    }
  }
}
