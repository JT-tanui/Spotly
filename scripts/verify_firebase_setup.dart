import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path/path.dart' as path;

/// A simple script to verify that Firebase is properly configured in the project.
///
/// Run this with:
/// dart run scripts/verify_firebase_setup.dart
void main() async {
  print('💡 Spotly Firebase Setup Verification');
  print('---------------------------------------');

  // Check environment file
  await verifyEnvironmentFile();

  // Check Android files
  await verifyAndroidFiles();

  // Check iOS files
  await verifyIOSFiles();

  // Check Web files
  await verifyWebFiles();

  print('\n✅ Verification completed!');
  print('If any issues were found, please resolve them before continuing.');
}

Future<void> verifyEnvironmentFile() async {
  print('\n🔍 Checking environment file...');

  final envFile = File('.environment');
  if (!await envFile.exists()) {
    printError('Environment file (.environment) not found!');
    return;
  }

  try {
    await dotenv.load(fileName: '.environment');
    printSuccess('Environment file loaded successfully.');

    // Check required keys
    final requiredKeys = [
      'FIREBASE_API_KEY',
      'FIREBASE_APP_ID',
      'FIREBASE_PROJECT_ID',
      'GOOGLE_MAPS_API_KEY',
    ];

    final missingKeys = <String>[];
    for (final key in requiredKeys) {
      if (dotenv.env[key] == null || dotenv.env[key]!.isEmpty) {
        missingKeys.add(key);
      }
    }

    if (missingKeys.isNotEmpty) {
      printWarning(
          'Missing or empty environment variables: ${missingKeys.join(', ')}');
    } else {
      printSuccess('All required environment variables are present.');
    }
  } catch (e) {
    printError('Failed to load environment file: $e');
  }
}

Future<void> verifyAndroidFiles() async {
  print('\n🔍 Checking Android configuration...');

  // Check google-services.json
  final googleServicesFile = File('android/app/google-services.json');
  if (!await googleServicesFile.exists()) {
    printError('google-services.json not found!');
  } else {
    printSuccess('google-services.json found.');

    // Verify content
    final content = await googleServicesFile.readAsString();
    if (!content.contains('spotly-6790d')) {
      printWarning(
          'google-services.json might not be configured correctly for this project.');
    }
  }

  // Check build.gradle files
  final appBuildGradle = File('android/app/build.gradle.kts');
  if (await appBuildGradle.exists()) {
    final content = await appBuildGradle.readAsString();
    if (!content.contains('com.google.gms.google-services')) {
      printWarning(
          'Google services plugin not applied in app/build.gradle.kts');
    } else {
      printSuccess('Google services plugin applied in build.gradle.kts');
    }

    if (!content.contains('com.jml.spotly')) {
      printWarning(
          'Package name in build.gradle.kts does not match Firebase configuration');
    } else {
      printSuccess(
          'Package name in build.gradle.kts matches Firebase configuration');
    }
  } else {
    printError('android/app/build.gradle.kts not found!');
  }
}

Future<void> verifyIOSFiles() async {
  print('\n🔍 Checking iOS configuration...');

  // Check GoogleService-Info.plist
  final googleServiceInfoFile = File('ios/Runner/GoogleService-Info.plist');
  if (!await googleServiceInfoFile.exists()) {
    printError('GoogleService-Info.plist not found!');
  } else {
    printSuccess('GoogleService-Info.plist found.');

    // Verify content
    final content = await googleServiceInfoFile.readAsString();
    if (!content.contains('spotly-6790d')) {
      printWarning(
          'GoogleService-Info.plist might not be configured correctly for this project.');
    }

    if (!content.contains('com.jml.spotly')) {
      printWarning(
          'Bundle ID in GoogleService-Info.plist does not match Firebase configuration');
    } else {
      printSuccess(
          'Bundle ID in GoogleService-Info.plist matches Firebase configuration');
    }
  }
}

Future<void> verifyWebFiles() async {
  print('\n🔍 Checking Web configuration...');

  // Check firebase-config.js
  final firebaseConfigFile = File('web/firebase-config.js');
  if (!await firebaseConfigFile.exists()) {
    printError('firebase-config.js not found!');
  } else {
    printSuccess('firebase-config.js found.');

    // Verify content
    final content = await firebaseConfigFile.readAsString();
    if (!content.contains('spotly-6790d')) {
      printWarning(
          'firebase-config.js might not be configured correctly for this project.');
    }
  }

  // Check index.html
  final indexHtmlFile = File('web/index.html');
  if (await indexHtmlFile.exists()) {
    final content = await indexHtmlFile.readAsString();
    if (!content.contains('firebase-config.js')) {
      printWarning('firebase-config.js not included in index.html');
    } else {
      printSuccess('firebase-config.js is included in index.html');
    }
  } else {
    printError('web/index.html not found!');
  }
}

// Helper functions for prettier output
void printSuccess(String message) {
  print('✅ $message');
}

void printWarning(String message) {
  print('⚠️ $message');
}

void printError(String message) {
  print('❌ $message');
}
