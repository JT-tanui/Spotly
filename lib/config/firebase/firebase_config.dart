import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FirebaseConfig {
  static FirebaseOptions get androidOptions {
    return FirebaseOptions(
      apiKey: dotenv.env['FIREBASE_API_KEY'] ?? 'placeholder',
      appId: dotenv.env['FIREBASE_APP_ID'] ?? 'placeholder',
      messagingSenderId:
          dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? 'placeholder',
      projectId: dotenv.env['FIREBASE_PROJECT_ID'] ?? 'placeholder',
      storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? 'placeholder',
    );
  }

  static FirebaseOptions get iosOptions {
    return FirebaseOptions(
      apiKey: dotenv.env['FIREBASE_IOS_API_KEY'] ?? 'placeholder',
      appId: dotenv.env['FIREBASE_IOS_APP_ID'] ?? 'placeholder',
      messagingSenderId:
          dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? 'placeholder',
      projectId: dotenv.env['FIREBASE_PROJECT_ID'] ?? 'placeholder',
      storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? 'placeholder',
    );
  }

  static FirebaseOptions get webOptions {
    return FirebaseOptions(
      apiKey: dotenv.env['FIREBASE_WEB_API_KEY'] ?? 'placeholder',
      appId: dotenv.env['FIREBASE_WEB_APP_ID'] ?? 'placeholder',
      messagingSenderId:
          dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? 'placeholder',
      projectId: dotenv.env['FIREBASE_PROJECT_ID'] ?? 'placeholder',
      storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? 'placeholder',
      authDomain: dotenv.env['FIREBASE_WEB_AUTH_DOMAIN'] ?? 'placeholder',
      measurementId: dotenv.env['FIREBASE_WEB_MEASUREMENT_ID'] ?? 'placeholder',
    );
  }

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return webOptions;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return iosOptions;
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return androidOptions;
    }

    // Default to Android if platform is not specifically handled
    return androidOptions;
  }
}
