import 'package:flutter/foundation.dart';
import 'dart:async';

class PerformanceMetrics {
  final String operation;
  final Duration duration;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;

  PerformanceMetrics({
    required this.operation,
    required this.duration,
    required this.timestamp,
    this.metadata,
  });

  @override
  String toString() {
    return 'PerformanceMetrics(operation: $operation, duration: ${duration.inMilliseconds}ms, timestamp: $timestamp)';
  }
}

class PerformanceService {
  static final PerformanceService _instance = PerformanceService._internal();
  factory PerformanceService() => _instance;
  PerformanceService._internal();

  final List<PerformanceMetrics> _metrics = [];
  final Map<String, Stopwatch> _activeOperations = {};
  static const int maxMetricsCount = 100;

  void startOperation(String operationName, {Map<String, dynamic>? metadata}) {
    final stopwatch = Stopwatch()..start();
    _activeOperations[operationName] = stopwatch;
    
    if (kDebugMode) {
      debugPrint('🚀 Started operation: $operationName');
    }
  }

  void endOperation(String operationName, {Map<String, dynamic>? metadata}) {
    final stopwatch = _activeOperations.remove(operationName);
    if (stopwatch == null) {
      if (kDebugMode) {
        debugPrint('⚠️ Operation $operationName was not started');
      }
      return;
    }

    stopwatch.stop();
    final metrics = PerformanceMetrics(
      operation: operationName,
      duration: stopwatch.elapsed,
      timestamp: DateTime.now(),
      metadata: metadata,
    );

    _addMetrics(metrics);

    if (kDebugMode) {
      debugPrint('✅ Completed operation: $operationName in ${stopwatch.elapsedMilliseconds}ms');
    }
  }

  Future<T> measureOperation<T>(
    String operationName,
    Future<T> Function() operation, {
    Map<String, dynamic>? metadata,
  }) async {
    startOperation(operationName, metadata: metadata);
    try {
      final result = await operation();
      endOperation(operationName, metadata: metadata);
      return result;
    } catch (e) {
      endOperation(operationName, metadata: {...?metadata, 'error': e.toString()});
      rethrow;
    }
  }

  T measureSyncOperation<T>(
    String operationName,
    T Function() operation, {
    Map<String, dynamic>? metadata,
  }) {
    startOperation(operationName, metadata: metadata);
    try {
      final result = operation();
      endOperation(operationName, metadata: metadata);
      return result;
    } catch (e) {
      endOperation(operationName, metadata: {...?metadata, 'error': e.toString()});
      rethrow;
    }
  }

  void _addMetrics(PerformanceMetrics metrics) {
    _metrics.add(metrics);
    
    // Keep only recent metrics
    if (_metrics.length > maxMetricsCount) {
      _metrics.removeAt(0);
    }
  }

  List<PerformanceMetrics> getMetrics({String? operationFilter}) {
    if (operationFilter == null) {
      return List.from(_metrics);
    }
    return _metrics.where((m) => m.operation.contains(operationFilter)).toList();
  }

  Map<String, Duration> getAverageOperationTimes() {
    final Map<String, List<Duration>> operationTimes = {};
    
    for (final metric in _metrics) {
      operationTimes.putIfAbsent(metric.operation, () => []).add(metric.duration);
    }

    final Map<String, Duration> averages = {};
    operationTimes.forEach((operation, times) {
      final totalMs = times.fold<int>(0, (sum, duration) => sum + duration.inMilliseconds);
      averages[operation] = Duration(milliseconds: totalMs ~/ times.length);
    });

    return averages;
  }

  void clearMetrics() {
    _metrics.clear();
  }

  // Performance thresholds
  static const Duration slowOperationThreshold = Duration(milliseconds: 1000);
  static const Duration verySlowOperationThreshold = Duration(milliseconds: 3000);

  bool isSlowOperation(Duration duration) {
    return duration >= slowOperationThreshold;
  }

  bool isVerySlowOperation(Duration duration) {
    return duration >= verySlowOperationThreshold;
  }

  void logSlowOperations() {
    final slowOps = _metrics.where((m) => isSlowOperation(m.duration)).toList();
    if (slowOps.isNotEmpty && kDebugMode) {
      debugPrint('🐌 Slow operations detected:');
      for (final op in slowOps) {
        debugPrint('  - ${op.operation}: ${op.duration.inMilliseconds}ms');
      }
    }
  }
}
