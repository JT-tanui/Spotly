import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'firebase_config.dart';

class FirebaseService {
  static String? _fcmToken;
  static bool _isInitialized = false;

  // Getter for the FCM token
  static String? get fcmToken => _fcmToken;

  // Check if Firebase is initialized
  static bool get isInitialized => _isInitialized;

  /// Initialize Firebase services
  static Future<void> initialize() async {
    try {
      final options = FirebaseConfig.currentPlatform;

      // Validate Firebase configuration
      if (_isInvalidFirebaseConfig(options)) {
        debugPrint(
            'Firebase configuration is not set properly. Skipping initialization.');
        _isInitialized = false;
        return;
      }

      // Initialize Firebase
      await Firebase.initializeApp(options: options);
      _isInitialized = true;
      debugPrint('Firebase initialized successfully');

      // Request notification permissions
      await _requestNotificationPermissions();

      // Get and store FCM token
      await _getFCMToken();

      // Set up FCM token refresh listener
      FirebaseMessaging.instance.onTokenRefresh.listen(_updateFCMToken);
    } catch (e) {
      debugPrint('Firebase initialization failed: $e');
      _isInitialized = false;
      // Continue without Firebase functionality
    }
  }

  /// Check if the Firebase config has invalid or placeholder values
  static bool _isInvalidFirebaseConfig(FirebaseOptions options) {
    return options.apiKey.isEmpty ||
        options.projectId.isEmpty ||
        options.appId.isEmpty;
  }

  /// Request notification permissions
  static Future<void> _requestNotificationPermissions() async {
    try {
      final messaging = FirebaseMessaging.instance;
      final settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      debugPrint('User granted permission: ${settings.authorizationStatus}');
    } catch (e) {
      debugPrint('Failed to request notification permissions: $e');
    }
  }

  /// Get the FCM token and store it
  static Future<void> _getFCMToken() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      _fcmToken = token;
      debugPrint(
          'FCM Token: ${_fcmToken?.substring(0, 5)}...'); // Only log part of token for security
    } catch (e) {
      debugPrint('Failed to get FCM token: $e');
    }
  }

  /// Update FCM token when it refreshes
  static void _updateFCMToken(String token) {
    _fcmToken = token;
    debugPrint('FCM Token refreshed: ${_fcmToken?.substring(0, 5)}...');
    // TODO: Send updated token to backend
  }

  /// Handle background messages
  static Future<void> handleBackgroundMessage(RemoteMessage message) async {
    debugPrint('Handling background message: ${message.messageId}');
    // Add secure handling for background messages
    // Do not log full message content for security reasons

    // Process message data payload
    if (message.data.isNotEmpty) {
      _processMessageData(message.data);
    }
  }

  /// Handle foreground messages
  static Future<void> handleForegroundMessage(RemoteMessage message) async {
    debugPrint('Handling foreground message: ${message.messageId}');

    // Process notification payload
    if (message.notification != null) {
      debugPrint(
          'Message contains notification: ${message.notification!.title}');
      // Show local notification if needed
    }

    // Process message data payload
    if (message.data.isNotEmpty) {
      _processMessageData(message.data);
    }
  }

  /// Process message data securely
  static void _processMessageData(Map<String, dynamic> data) {
    // Validate message data before processing
    if (_isValidMessageData(data)) {
      debugPrint('Processing valid message data');
      // TODO: Process message data
    } else {
      debugPrint('Invalid message data received - ignoring');
    }
  }

  /// Validate message data for security
  static bool _isValidMessageData(Map<String, dynamic> data) {
    // Add validation logic to prevent malicious payloads
    // This is just a simple example - implement more robust validation
    final requiredFields = ['type', 'sender'];
    return requiredFields.every((field) => data.containsKey(field));
  }
}
