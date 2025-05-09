import 'package:dartz/dartz.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/event.dart';
import '../../domain/repositories/event_repository.dart';
import '../datasources/local/event_local_data_source.dart';
import '../models/event_model.dart';

class EventRepositoryImpl implements EventRepository {
  final EventLocalDataSource localDataSource;

  EventRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Event>>> getUserEvents(String userId) async {
    try {
      final events = await localDataSource.getUserEvents();
      return Right(events.where((event) => event.createdBy == userId).toList());
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Event>> createEvent(Event event) async {
    try {
      final eventModel = EventModel.fromEntity(event);
      final createdEvent = await localDataSource.createEvent(eventModel);
      return Right(createdEvent);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteEvent(String eventId) async {
    try {
      await localDataSource.deleteEvent(eventId);
      return const Right(null);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Event>> updateEvent(Event event) async {
    try {
      final eventModel = EventModel.fromEntity(event);
      final updatedEvent = await localDataSource.updateEvent(eventModel);
      return Right(updatedEvent);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
