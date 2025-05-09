import 'dart:convert';
import 'package:dio/dio.dart';
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
        return results
            .map((place) => PlaceModel.fromJson(place as Map<String, dynamic>))
            .toList();
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
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
        final result = response.data['result'];
        return PlaceModel.fromJson(result as Map<String, dynamic>);
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
}
