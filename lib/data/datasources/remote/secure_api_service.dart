import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// SecureApiService handles API calls that require sensitive API keys
/// Instead of exposing keys to the client, we use a backend service
class SecureApiService {
  static final String _apiBaseUrl =
      dotenv.env['API_BASE_URL'] ?? 'https://api.spotly.com';
  static final String _apiVersion = dotenv.env['API_VERSION'] ?? 'v1';

  static String get baseUrl => '$_apiBaseUrl/$_apiVersion';

  /// Make a secure API call to Google Maps services through our backend
  /// This prevents exposing API keys in the client-side code
  static Future<Map<String, dynamic>> getPlaces({
    required double latitude,
    required double longitude,
    required double radius,
    String? keyword,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/places/nearby'),
        headers: {
          'Content-Type': 'application/json',
        },
        // Pass the parameters to the backend, which will add the API key
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to fetch places: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch places: $e');
    }
  }

  /// Perform a secure Firebase operation through our backend service
  /// The actual Firebase API key is only used on the server side
  static Future<Map<String, dynamic>> performSecureFirebaseOperation({
    required String operation,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/firebase/$operation'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: json.encode(data),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
            'Failed to perform Firebase operation: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to perform Firebase operation: $e');
    }
  }
}

/// Backend service structure (implemented separately on your backend)
/// 
/// // Example backend code (Node.js/Express)
/// app.get('/api/v1/places/nearby', (req, res) => {
///   const { latitude, longitude, radius, keyword } = req.query;
///   // Add the API key from server environment variables
///   const apiKey = process.env.GOOGLE_MAPS_API_KEY;
///   
///   // Make the request to Google Places API
///   // Return the results to the client
/// });
/// 
/// app.post('/api/v1/firebase/:operation', (req, res) => {
///   const { operation } = req.params;
///   const data = req.body;
///   
///   // Use Firebase Admin SDK with server credentials
///   // Perform the requested operation
///   // Return results to client
/// }); 