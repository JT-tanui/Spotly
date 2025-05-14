import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// A script to inject environment variables into the web build
/// This allows us to keep sensitive keys out of version control
///
/// Usage: dart run scripts/inject_web_env.dart
void main() async {
  print('💡 Injecting environment variables into web build');

  // Load environment variables
  await dotenv.load(fileName: '.environment');
  if (dotenv.env.isEmpty) {
    print(
        '❌ Failed to load environment variables. Make sure .environment file exists.');
    exit(1);
  }

  final webConfigFile = File('web/firebase-config.js');
  if (!await webConfigFile.exists()) {
    print('❌ Firebase config file not found at web/firebase-config.js');
    exit(1);
  }

  try {
    String content = await webConfigFile.readAsString();

    // Replace placeholder values with actual environment variables
    content = content.replaceAll(
        '__FIREBASE_WEB_API_KEY__', dotenv.env['FIREBASE_WEB_API_KEY'] ?? '');
    content = content.replaceAll('__FIREBASE_WEB_AUTH_DOMAIN__',
        dotenv.env['FIREBASE_WEB_AUTH_DOMAIN'] ?? '');
    content = content.replaceAll(
        '__FIREBASE_PROJECT_ID__', dotenv.env['FIREBASE_PROJECT_ID'] ?? '');
    content = content.replaceAll('__FIREBASE_STORAGE_BUCKET__',
        dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? '');
    content = content.replaceAll('__FIREBASE_MESSAGING_SENDER_ID__',
        dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '');
    content = content.replaceAll(
        '__FIREBASE_WEB_APP_ID__', dotenv.env['FIREBASE_WEB_APP_ID'] ?? '');
    content = content.replaceAll('__FIREBASE_WEB_MEASUREMENT_ID__',
        dotenv.env['FIREBASE_WEB_MEASUREMENT_ID'] ?? '');

    // Write the updated content
    await webConfigFile.writeAsString(content);
    print(
        '✅ Successfully injected environment variables into web/firebase-config.js');
  } catch (e) {
    print('❌ Failed to update web config file: $e');
    exit(1);
  }
}
