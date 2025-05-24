import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../utils/app_constants.dart';
import '../utils/app_helpers.dart';

enum ErrorType {
  network,
  database,
  validation,
  permission,
  unknown,
}

class AppError {
  final String message;
  final ErrorType type;
  final String? details;
  final StackTrace? stackTrace;
  final DateTime timestamp;

  AppError({
    required this.message,
    required this.type,
    this.details,
    this.stackTrace,
  }) : timestamp = DateTime.now();

  @override
  String toString() {
    return 'AppError: $message (Type: $type, Time: $timestamp)';
  }
}

class ErrorService {
  static final ErrorService _instance = ErrorService._internal();
  factory ErrorService() => _instance;
  ErrorService._internal();

  final List<AppError> _errorLog = [];
  static const int maxErrorLogSize = 100;

  void logError(AppError error) {
    _errorLog.add(error);
    
    // Keep only recent errors
    if (_errorLog.length > maxErrorLogSize) {
      _errorLog.removeAt(0);
    }

    // Log to console in debug mode
    if (kDebugMode) {
      debugPrint('🔴 ${error.toString()}');
      if (error.details != null) {
        debugPrint('Details: ${error.details}');
      }
      if (error.stackTrace != null) {
        debugPrint('StackTrace: ${error.stackTrace}');
      }
    }
  }

  AppError handleException(dynamic exception, {String? context}) {
    ErrorType type = ErrorType.unknown;
    String message = AppConstants.generalErrorMessage;

    if (exception is FormatException) {
      type = ErrorType.validation;
      message = 'خطأ في تنسيق البيانات';
    } else if (exception.toString().contains('database')) {
      type = ErrorType.database;
      message = AppConstants.databaseErrorMessage;
    } else if (exception.toString().contains('network') || 
               exception.toString().contains('connection')) {
      type = ErrorType.network;
      message = AppConstants.networkErrorMessage;
    } else if (exception.toString().contains('permission')) {
      type = ErrorType.permission;
      message = AppConstants.accessDeniedMessage;
    }

    final error = AppError(
      message: message,
      type: type,
      details: context != null ? '$context: ${exception.toString()}' : exception.toString(),
      stackTrace: StackTrace.current,
    );

    logError(error);
    return error;
  }

  void showErrorToUser(BuildContext context, AppError error) {
    String userMessage = error.message;
    Color backgroundColor = Colors.red;
    IconData icon = Icons.error;

    switch (error.type) {
      case ErrorType.network:
        backgroundColor = Colors.orange;
        icon = Icons.wifi_off;
        break;
      case ErrorType.database:
        backgroundColor = Colors.red.shade700;
        icon = Icons.storage;
        break;
      case ErrorType.validation:
        backgroundColor = Colors.amber;
        icon = Icons.warning;
        break;
      case ErrorType.permission:
        backgroundColor = Colors.purple;
        icon = Icons.lock;
        break;
      case ErrorType.unknown:
        backgroundColor = Colors.grey.shade600;
        icon = Icons.help_outline;
        break;
    }

    AppHelpers.showSnackBar(
      context,
      userMessage,
      backgroundColor: backgroundColor,
      icon: icon,
      duration: const Duration(seconds: 4),
    );
  }

  List<AppError> getRecentErrors({int limit = 10}) {
    return _errorLog.reversed.take(limit).toList();
  }

  void clearErrorLog() {
    _errorLog.clear();
  }

  // Specific error creators
  static AppError networkError([String? details]) {
    return AppError(
      message: AppConstants.networkErrorMessage,
      type: ErrorType.network,
      details: details,
    );
  }

  static AppError databaseError([String? details]) {
    return AppError(
      message: AppConstants.databaseErrorMessage,
      type: ErrorType.database,
      details: details,
    );
  }

  static AppError validationError(String message, [String? details]) {
    return AppError(
      message: message,
      type: ErrorType.validation,
      details: details,
    );
  }
}
