import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../core/error/failures.dart';
import '../entities/event.dart';
import '../repositories/event_repository.dart';

class GetNearbyEventsParams extends Equatable {
  final double latitude;
  final double longitude;
  final double radius;
  final int? page;
  final int? pageSize;

  const GetNearbyEventsParams({
    required this.latitude,
    required this.longitude,
    required this.radius,
    this.page,
    this.pageSize,
  });

  @override
  List<Object?> get props => [latitude, longitude, radius, page, pageSize];
}

class GetNearbyEvents {
  final EventRepository repository;

  GetNearbyEvents(this.repository);

  Future<Either<Failure, List<Event>>> call(
      GetNearbyEventsParams params) async {
    return repository.getNearbyEvents(
      latitude: params.latitude,
      longitude: params.longitude,
      radius: params.radius,
      page: params.page,
      pageSize: params.pageSize,
    );
  }
}
