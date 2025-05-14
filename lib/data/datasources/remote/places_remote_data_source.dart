import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../core/errors/exceptions.dart';
import '../../models/place_model.dart';

abstract class PlacesRemoteDataSource {
  Future<List<PlaceModel>> getNearbyPlaces({
    required double latitude,
    required double longitude,
    required double radius,
  });

  Future<PlaceModel> getPlaceDetails(String placeId);
}

class PlacesRemoteDataSourceImpl implements PlacesRemoteDataSource {
  final Dio dio;
  final String apiKey;

  PlacesRemoteDataSourceImpl({
    required this.dio,
    required this.apiKey,
  });

  @override
  Future<List<PlaceModel>> getNearbyPlaces({
    required double latitude,
    required double longitude,
    required double radius,
  }) async {
    try {
      final response = await dio.get(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json',
        queryParameters: {
          'location': '$latitude,$longitude',
          'radius': radius,
          'key': apiKey,
        },
      );

      if (response.statusCode == 200) {
        final results = response.data['results'] as List;
        return results.map((place) {
          // Convert Google Places API response to our PlaceModel format
          final location = place['geometry']['location'];
          final photos = place['photos'] as List?;
          String photoReference = '';

          if (photos != null && photos.isNotEmpty) {
            photoReference = photos[0]['photo_reference'] as String? ?? '';
          }

          // Generate image URL from photo reference if available
          String imageUrl = photoReference.isNotEmpty
              ? 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=$apiKey'
              : 'https://via.placeholder.com/400x300/3949AB/FFFFFF?text=${place['types']?[0] ?? 'Place'}';

          // Determine the category based on types
          final types = place['types'] as List<dynamic>;
          String category = 'Other';

          if (types.contains('restaurant') || types.contains('food')) {
            category = 'Food';
          } else if (types.contains('bar') || types.contains('night_club')) {
            category = 'Nightlife';
          } else if (types.contains('park') ||
              types.contains('natural_feature')) {
            category = 'Outdoors';
          } else if (types.contains('store') ||
              types.contains('shopping_mall')) {
            category = 'Shopping';
          } else if (types.contains('event_venue') ||
              types.contains('stadium')) {
            category = 'Events';
          }

          return PlaceModel(
            id: place['place_id'] as String,
            name: place['name'] as String,
            description: place['vicinity'] as String? ?? '',
            imageUrl: imageUrl,
            category: category,
            address: place['vicinity'] as String? ?? '',
            rating: (place['rating'] as num?)?.toDouble() ?? 0.0,
            latitude: location['lat'] as double,
            longitude: location['lng'] as double,
            photos: photos != null
                ? photos
                    .map((p) =>
                        'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${p['photo_reference']}&key=$apiKey')
                    .toList()
                    .cast<String>()
                : [],
            photoReference: photoReference,
            types: types.cast<String>().toList(),
            metadata: place as Map<String, dynamic>,
          );
        }).toList();
      } else {
        throw ServerException(
            message: 'Failed to load places: ${response.statusMessage}');
      }
    } catch (e) {
      throw ServerException(message: 'Failed to load places: $e');
    }
  }

  @override
  Future<PlaceModel> getPlaceDetails(String placeId) async {
    try {
      final response = await dio.get(
        'https://maps.googleapis.com/maps/api/place/details/json',
        queryParameters: {
          'place_id': placeId,
          'key': apiKey,
        },
      );

      if (response.statusCode == 200) {
        final result = response.data['result'] as Map<String, dynamic>;
        final location = result['geometry']['location'];
        final photos = result['photos'] as List?;
        String photoReference = '';

        if (photos != null && photos.isNotEmpty) {
          photoReference = photos[0]['photo_reference'] as String? ?? '';
        }

        // Generate image URL from photo reference if available
        String imageUrl = photoReference.isNotEmpty
            ? 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=$apiKey'
            : 'https://via.placeholder.com/400x300/3949AB/FFFFFF?text=${result['types']?[0] ?? 'Place'}';

        // Determine the category based on types
        final types = result['types'] as List<dynamic>;
        String category = 'Other';

        if (types.contains('restaurant') || types.contains('food')) {
          category = 'Food';
        } else if (types.contains('bar') || types.contains('night_club')) {
          category = 'Nightlife';
        } else if (types.contains('park') ||
            types.contains('natural_feature')) {
          category = 'Outdoors';
        } else if (types.contains('store') || types.contains('shopping_mall')) {
          category = 'Shopping';
        } else if (types.contains('event_venue') || types.contains('stadium')) {
          category = 'Events';
        }

        return PlaceModel(
          id: result['place_id'] as String,
          name: result['name'] as String,
          description: result['formatted_address'] as String? ?? '',
          imageUrl: imageUrl,
          category: category,
          address: result['formatted_address'] as String? ?? '',
          rating: (result['rating'] as num?)?.toDouble() ?? 0.0,
          latitude: location['lat'] as double,
          longitude: location['lng'] as double,
          photos: photos != null
              ? photos
                  .map((p) =>
                      'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${p['photo_reference']}&key=$apiKey')
                  .toList()
                  .cast<String>()
              : [],
          photoReference: photoReference,
          types: types.cast<String>().toList(),
          metadata: result,
        );
      } else {
        throw ServerException(
            message: 'Failed to load place details: ${response.statusMessage}');
      }
    } catch (e) {
      throw ServerException(message: 'Failed to load place details: $e');
    }
  }
}
