#!/usr/bin/env dart

import 'dart:io';
import 'dart:async';

// Simple status checker without Flutter dependencies
void main(List<String> args) async {
  print('🔍 فحص حالة تطبيق دكتورك / DoctoraK');
  print('=' * 50);
  print('');

  await checkProjectStructure();
  await checkDependencies();
  await checkDatabaseFiles();
  await checkAssets();
  await checkConfiguration();
  
  print('');
  print('✅ انتهى فحص حالة التطبيق');
}

Future<void> checkProjectStructure() async {
  print('📁 فحص هيكل المشروع:');
  
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
    if (await directory.exists()) {
      print('   ✅ $dir');
    } else {
      print('   ❌ $dir (مفقود)');
    }
  }
  
  for (final file in requiredFiles) {
    final fileObj = File(file);
    if (await fileObj.exists()) {
      print('   ✅ $file');
    } else {
      print('   ❌ $file (مفقود)');
    }
  }
  
  print('');
}

Future<void> checkDependencies() async {
  print('📦 فحص التبعيات:');
  
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
        if (content.contains(dep)) {
          print('   ✅ $dep');
        } else {
          print('   ❌ $dep (مفقود)');
        }
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
      
      print('   🗑️ التبعيات المحذوفة:');
      for (final dep in removedDeps) {
        if (!content.contains(dep)) {
          print('   ✅ $dep (محذوف بنجاح)');
        } else {
          print('   ⚠️ $dep (لا يزال موجود)');
        }
      }
      
    } else {
      print('   ❌ pubspec.yaml غير موجود');
    }
  } catch (e) {
    print('   ❌ خطأ في فحص التبعيات: $e');
  }
  
  print('');
}

Future<void> checkDatabaseFiles() async {
  print('💾 فحص ملفات قاعدة البيانات:');
  
  final dbServiceFile = File('lib/services/database_service.dart');
  if (await dbServiceFile.exists()) {
    try {
      final content = await dbServiceFile.readAsString();
      
      // Check database version
      if (content.contains('version: 2')) {
        print('   ✅ إصدار قاعدة البيانات: 2');
      } else {
        print('   ⚠️ إصدار قاعدة البيانات قديم');
      }
      
      // Check tables
      final tables = ['drugs', 'health_tips', 'symptoms', 'user_profiles'];
      for (final table in tables) {
        if (content.contains('CREATE TABLE $table')) {
          print('   ✅ جدول $table');
        } else {
          print('   ❌ جدول $table (مفقود)');
        }
      }
      
      // Check indexes
      if (content.contains('CREATE INDEX')) {
        print('   ✅ فهارس قاعدة البيانات');
      } else {
        print('   ⚠️ فهارس قاعدة البيانات مفقودة');
      }
      
    } catch (e) {
      print('   ❌ خطأ في قراءة ملف قاعدة البيانات: $e');
    }
  } else {
    print('   ❌ ملف خدمة قاعدة البيانات مفقود');
  }
  
  print('');
}

Future<void> checkAssets() async {
  print('🖼️ فحص الأصول:');
  
  // Check if assets directory exists
  final assetsDir = Directory('assets');
  if (await assetsDir.exists()) {
    print('   ✅ مجلد assets موجود');
    
    // Check subdirectories
    final subDirs = ['images', 'icons'];
    for (final subDir in subDirs) {
      final dir = Directory('assets/$subDir');
      if (await dir.exists()) {
        final files = await dir.list().length;
        print('   ✅ assets/$subDir ($files ملف)');
      } else {
        print('   ⚠️ assets/$subDir (مفقود)');
      }
    }
  } else {
    print('   ⚠️ مجلد assets غير موجود');
  }
  
  // Check pubspec.yaml for assets configuration
  try {
    final pubspecFile = File('pubspec.yaml');
    if (await pubspecFile.exists()) {
      final content = await pubspecFile.readAsString();
      if (content.contains('assets:')) {
        print('   ✅ تكوين الأصول في pubspec.yaml');
      } else {
        print('   ⚠️ تكوين الأصول مفقود في pubspec.yaml');
      }
    }
  } catch (e) {
    print('   ❌ خطأ في فحص تكوين الأصول: $e');
  }
  
  print('');
}

Future<void> checkConfiguration() async {
  print('⚙️ فحص التكوين:');
  
  // Check Android configuration
  final androidBuildFile = File('android/app/build.gradle.kts');
  if (await androidBuildFile.exists()) {
    try {
      final content = await androidBuildFile.readAsString();
      
      if (content.contains('applicationId')) {
        print('   ✅ معرف التطبيق Android');
      } else {
        print('   ❌ معرف التطبيق Android مفقود');
      }
      
      if (content.contains('minSdk')) {
        print('   ✅ إعدادات SDK Android');
      } else {
        print('   ❌ إعدادات SDK Android مفقودة');
      }
      
      // Check optimization settings
      if (content.contains('isMinifyEnabled')) {
        print('   ✅ إعدادات التحسين');
      } else {
        print('   ⚠️ إعدادات التحسين مفقودة');
      }
      
    } catch (e) {
      print('   ❌ خطأ في فحص تكوين Android: $e');
    }
  } else {
    print('   ❌ ملف تكوين Android مفقود');
  }
  
  // Check main.dart
  final mainFile = File('lib/main.dart');
  if (await mainFile.exists()) {
    try {
      final content = await mainFile.readAsString();
      
      if (content.contains('دكتورك') || content.contains('DoctoraK')) {
        print('   ✅ اسم التطبيق صحيح');
      } else {
        print('   ⚠️ اسم التطبيق قد يحتاج تحديث');
      }
      
      if (content.contains('MaterialApp')) {
        print('   ✅ تكوين Material App');
      } else {
        print('   ❌ تكوين Material App مفقود');
      }
      
      if (content.contains('Provider')) {
        print('   ✅ تكوين Provider');
      } else {
        print('   ❌ تكوين Provider مفقود');
      }
      
    } catch (e) {
      print('   ❌ خطأ في فحص main.dart: $e');
    }
  } else {
    print('   ❌ ملف main.dart مفقود');
  }
  
  print('');
}
