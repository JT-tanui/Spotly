class AppConfig {
  static const String appName = 'Spotly';
  static const String appVersion = '1.0.0';

  // API Keys
  static late final String googleMapsApiKey;

  // API Endpoints
  static const String googlePlacesBaseUrl =
      'https://maps.googleapis.com/maps/api/place';

  // Hive Box Names
  static const String eventsBoxName = 'events';

  // Location Settings
  static const double defaultSearchRadius = 1000; // meters
  static const double defaultMapZoom = 15.0;

  // UI Settings
  static const int splashScreenDuration = 2; // seconds

  static void initialize({required String googleMapsKey}) {
    googleMapsApiKey = googleMapsKey;
  }
}
