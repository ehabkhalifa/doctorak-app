import 'package:flutter/material.dart';

enum LoadingState {
  idle,
  loading,
  success,
  error,
  refreshing,
}

class LoadingStateManager {
  final Map<String, LoadingState> _states = {};
  final Map<String, String?> _messages = {};
  final Map<String, double?> _progress = {};

  LoadingState getState(String key) => _states[key] ?? LoadingState.idle;
  String? getMessage(String key) => _messages[key];
  double? getProgress(String key) => _progress[key];

  void setState(String key, LoadingState state, {String? message, double? progress}) {
    _states[key] = state;
    _messages[key] = message;
    _progress[key] = progress;
  }

  void setLoading(String key, {String? message}) {
    setState(key, LoadingState.loading, message: message);
  }

  void setSuccess(String key, {String? message}) {
    setState(key, LoadingState.success, message: message);
  }

  void setError(String key, {String? message}) {
    setState(key, LoadingState.error, message: message);
  }

  void setRefreshing(String key, {String? message}) {
    setState(key, LoadingState.refreshing, message: message);
  }

  void setIdle(String key) {
    setState(key, LoadingState.idle);
  }

  void clearState(String key) {
    _states.remove(key);
    _messages.remove(key);
    _progress.remove(key);
  }

  void clearAll() {
    _states.clear();
    _messages.clear();
    _progress.clear();
  }

  bool isLoading(String key) => getState(key) == LoadingState.loading;
  bool isRefreshing(String key) => getState(key) == LoadingState.refreshing;
  bool hasError(String key) => getState(key) == LoadingState.error;
  bool isSuccess(String key) => getState(key) == LoadingState.success;
}

class LoadingOverlay extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final String? message;
  final double? progress;

  const LoadingOverlay({
    super.key,
    required this.child,
    required this.isLoading,
    this.message,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black.withValues(alpha: 0.3),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (progress != null) ...[
                      CircularProgressIndicator(value: progress),
                      const SizedBox(height: 16),
                      Text('${(progress! * 100).toInt()}%'),
                    ] else ...[
                      const CircularProgressIndicator(),
                    ],
                    if (message != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        message!,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class SmartRefreshIndicator extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  final bool enabled;

  const SmartRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;

    return RefreshIndicator(
      onRefresh: onRefresh,
      color: Theme.of(context).primaryColor,
      backgroundColor: Colors.white,
      strokeWidth: 2.5,
      displacement: 60,
      child: child,
    );
  }
}

// Loading States Constants
class LoadingKeys {
  static const String appInit = 'app_init';
  static const String drugSearch = 'drug_search';
  static const String healthTips = 'health_tips';
  static const String symptoms = 'symptoms';
  static const String userProfile = 'user_profile';
  static const String dataRefresh = 'data_refresh';
}
