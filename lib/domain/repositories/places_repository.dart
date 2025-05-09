import 'package:dartz/dartz.dart';
import '../entities/place.dart';
import '../../core/errors/failures.dart';

abstract class PlacesRepository {
  Future<Either<Failure, List<Place>>> getNearbyPlaces({
    required double latitude,
    required double longitude,
    required double radius,
  });

  Future<Either<Failure, Place>> getPlaceDetails(String placeId);
}
