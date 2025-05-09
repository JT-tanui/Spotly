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
  Future<Either<Failure, List<Event>>> getUserEvents() async {
    try {
      final events = await localDataSource.getUserEvents();
      return Right(events);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Event>> createEvent(Event event) async {
    try {
      final eventModel = await localDataSource.createEvent(event as EventModel);
      return Right(eventModel);
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
      final eventModel = await localDataSource.updateEvent(event as EventModel);
      return Right(eventModel);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
