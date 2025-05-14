import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  // App Information
  static const String appName = 'Spotly';
  static const String appVersion = '1.0.0';

  // Map Configuration
  static const double defaultMapZoom = 15.0;
  static const double minMapZoom = 3.0;
  static const double maxMapZoom = 20.0;

  // API keys and endpoints
  static const String placesApiBaseUrl =
      'https://maps.googleapis.com/maps/api/place';

  // Cache Configuration
  static const int cacheDuration = 24; // hours

  // Pagination
  static const int defaultPageSize = 20;

  // Default radius for nearby searches (in meters)
  static const int defaultSearchRadius = 5000;

  // App Colors
  static const int primaryColorValue = 0xFF5E35B1; // Deep Purple
  static const int accentColorValue = 0xFFFF4081; // Pink

  // API Keys
  static late final String googleMapsApiKey;

  // Hive Box Names
  static const String eventsBoxName = 'events';

  // Location Settings
  static const double defaultSearchRadiusMeters = 1000; // meters

  // UI Settings
  static const int splashScreenDuration = 2; // seconds

  static void initialize() {
    // Load API keys from environment variables
    googleMapsApiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? 'placeholder';

    // Set default values for required environment variables
    if (dotenv.env['APP_ENV'] == null) {
      dotenv.env['APP_ENV'] = 'development';
    }
    if (dotenv.env['DEBUG_MODE'] == null) {
      dotenv.env['DEBUG_MODE'] = 'true';
    }
  }
}
