import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/place.dart';
import '../repositories/places_repository.dart';

class GetNearbyPlaces implements UseCase<List<Place>, GetNearbyPlacesParams> {
  final PlacesRepository repository;

  GetNearbyPlaces(this.repository);

  @override
  Future<Either<Failure, List<Place>>> call(
      GetNearbyPlacesParams params) async {
    return await repository.getNearbyPlaces(
      latitude: params.latitude,
      longitude: params.longitude,
      radius: params.radius,
    );
  }
}

class GetNearbyPlacesParams {
  final double latitude;
  final double longitude;
  final double radius;

  GetNearbyPlacesParams({
    required this.latitude,
    required this.longitude,
    required this.radius,
  });
}
