import 'package:dartz/dartz.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/place.dart';
import '../../domain/repositories/places_repository.dart';
import '../datasources/remote/places_remote_data_source.dart';

class PlacesRepositoryImpl implements PlacesRepository {
  final PlacesRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  PlacesRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Place>>> getNearbyPlaces({
    required double latitude,
    required double longitude,
    required double radius,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final places = await remoteDataSource.getNearbyPlaces(
          latitude: latitude,
          longitude: longitude,
          radius: radius,
        );
        return Right(places);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return Left(ServerFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Place>> getPlaceDetails(String placeId) async {
    if (await networkInfo.isConnected) {
      try {
        final place = await remoteDataSource.getPlaceDetails(placeId);
        return Right(place);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return Left(ServerFailure(message: 'No internet connection'));
    }
  }
}
