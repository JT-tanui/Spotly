import 'package:dartz/dartz.dart';
import '../entities/venue.dart';
import '../failures/failures.dart';

abstract class VenueRepository {
  Future<Either<Failure, List<Venue>>> getPopularVenues();
  Future<Either<Failure, List<Venue>>> getNearbyVenues({
    required double latitude,
    required double longitude,
    required double radius,
  });
  Future<Either<Failure, List<Venue>>> getVenuesByCategory(String category);
}
