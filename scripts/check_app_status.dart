#!/usr/bin/env dart

import 'dart:io';
import 'dart:async';
import 'package:logger/logger.dart';

final logger = Logger();

void main(List<String> args) async {
  logger.i('🔍 فحص حالة تطبيق دكتورك / DoctoraK');
  logger.i('=' * 50);
  logger.i('');

  await checkProjectStructure();
  await checkDependencies();
  await checkDatabaseFiles();
  await checkAssets();
  await checkConfiguration();

  logger.i('');
  logger.i('✅ انتهى فحص حالة التطبيق');
}

Future<void> checkProjectStructure() async {
  logger.i('📁 فحص هيكل المشروع:');

  final requiredDirs = [
    'lib',
    'lib/models',
    'lib/services',
    'lib/screens',
    'lib/widgets',
    'lib/providers',
    'lib/theme',
    'lib/utils',
    'android',
    'android/app',
  ];

  final requiredFiles = [
    'pubspec.yaml',
    'lib/main.dart',
    'lib/services/database_service.dart',
    'lib/services/cache_service.dart',
    'lib/providers/app_provider.dart',
    'android/app/build.gradle.kts',
  ];

  for (final dir in requiredDirs) {
    final directory = Directory(dir);
    (await directory.exists())
        ? logger.i('   ✅ $dir')
        : logger.e('   ❌ $dir (مفقود)');
  }

  for (final file in requiredFiles) {
    final fileObj = File(file);
    (await fileObj.exists())
        ? logger.i('   ✅ $file')
        : logger.e('   ❌ $file (مفقود)');
  }

  logger.i('');
}

Future<void> checkDependencies() async {
  logger.i('📦 فحص التبعيات:');

  try {
    final pubspecFile = File('pubspec.yaml');
    if (await pubspecFile.exists()) {
      final content = await pubspecFile.readAsString();

      final requiredDeps = [
        'flutter:',
        'sqflite:',
        'shared_preferences:',
        'provider:',
        'google_fonts:',
        'intl:',
        'path:',
      ];

      for (final dep in requiredDeps) {
        content.contains(dep)
            ? logger.i('   ✅ $dep')
            : logger.e('   ❌ $dep (مفقود)');
      }

      // Check for removed dependencies
      final removedDeps = [
        'page_transition:',
        'lottie:',
        'flutter_svg:',
        'cached_network_image:',
        'glassmorphism:',
        'animations:',
        'flutter_staggered_grid_view:',
      ];

      logger.i('   🗑️ التبعيات المحذوفة:');
      for (final dep in removedDeps) {
        content.contains(dep)
            ? logger.w('   ⚠️ $dep (لا يزال موجود)')
            : logger.i('   ✅ $dep (محذوف بنجاح)');
      }
    } else {
      logger.e('   ❌ pubspec.yaml غير موجود');
    }
  } catch (e) {
    logger.e('   ❌ خطأ في فحص التبعيات: $e');
  }

  logger.i('');
}

Future<void> checkDatabaseFiles() async {
  logger.i('💾 فحص ملفات قاعدة البيانات:');

  final dbServiceFile = File('lib/services/database_service.dart');
  if (await dbServiceFile.exists()) {
    try {
      final content = await dbServiceFile.readAsString();

      if (content.contains('version: 2')) {
        logger.i('   ✅ إصدار قاعدة البيانات: 2');
      } else {
        logger.w('   ⚠️ إصدار قاعدة البيانات قديم');
      }

      final tables = ['drugs', 'health_tips', 'symptoms', 'user_profiles'];
      for (final table in tables) {
        content.contains('CREATE TABLE $table')
            ? logger.i('   ✅ جدول $table')
            : logger.e('   ❌ جدول $table (مفقود)');
      }

      content.contains('CREATE INDEX')
          ? logger.i('   ✅ فهارس قاعدة البيانات')
          : logger.w('   ⚠️ فهارس قاعدة البيانات مفقودة');
    } catch (e) {
      logger.e('   ❌ خطأ في قراءة ملف قاعدة البيانات: $e');
    }
  } else {
    logger.e('   ❌ ملف خدمة قاعدة البيانات مفقود');
  }

  logger.i('');
}

Future<void> checkAssets() async {
  logger.i('🖼️ فحص الأصول:');

  final assetsDir = Directory('assets');
  if (await assetsDir.exists()) {
    logger.i('   ✅ مجلد assets موجود');

    final subDirs = ['images', 'icons'];
    for (final subDir in subDirs) {
      final dir = Directory('assets/$subDir');
      if (await dir.exists()) {
        final files = await dir.list().length;
        logger.i('   ✅ assets/$subDir ($files ملف)');
      } else {
        logger.w('   ⚠️ assets/$subDir (مفقود)');
      }
    }
  } else {
    logger.w('   ⚠️ مجلد assets غير موجود');
  }

  try {
    final pubspecFile = File('pubspec.yaml');
    if (await pubspecFile.exists()) {
      final content = await pubspecFile.readAsString();
      content.contains('assets:')
          ? logger.i('   ✅ تكوين الأصول في pubspec.yaml')
          : logger.w('   ⚠️ تكوين الأصول مفقود في pubspec.yaml');
    }
  } catch (e) {
    logger.e('   ❌ خطأ في فحص تكوين الأصول: $e');
  }

  logger.i('');
}

Future<void> checkConfiguration() async {
  logger.i('⚙️ فحص التكوين:');

  final androidBuildFile = File('android/app/build.gradle.kts');
  if (await androidBuildFile.exists()) {
    try {
      final content = await androidBuildFile.readAsString();

      content.contains('applicationId')
          ? logger.i('   ✅ معرف التطبيق Android')
          : logger.e('   ❌ معرف التطبيق Android مفقود');

      content.contains('minSdk')
          ? logger.i('   ✅ إعدادات SDK Android')
          : logger.e('   ❌ إعدادات SDK Android مفقودة');

      content.contains('isMinifyEnabled')
          ? logger.i('   ✅ إعدادات التحسين')
          : logger.w('   ⚠️ إعدادات التحسين مفقودة');
    } catch (e) {
      logger.e('   ❌ خطأ في فحص تكوين Android: $e');
    }
  } else {
    logger.e('   ❌ ملف تكوين Android مفقود');
  }

  final mainFile = File('lib/main.dart');
  if (await mainFile.exists()) {
    try {
      final content = await mainFile.readAsString();

      (content.contains('دكتورك') || content.contains('DoctoraK'))
          ? logger.i('   ✅ اسم التطبيق صحيح')
          : logger.w('   ⚠️ اسم التطبيق قد يحتاج تحديث');

      content.contains('MaterialApp')
          ? logger.i('   ✅ تكوين Material App')
          : logger.e('   ❌ تكوين Material App مفقود');

      content.contains('Provider')
          ? logger.i('   ✅ تكوين Provider')
          : logger.e('   ❌ تكوين Provider مفقود');
    } catch (e) {
      logger.e('   ❌ خطأ في فحص main.dart: $e');
    }
  } else {
    logger.e('   ❌ ملف main.dart مفقود');
  }

  logger.i('');
}
