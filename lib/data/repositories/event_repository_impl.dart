import 'package:dartz/dartz.dart';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/errors/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/event.dart';
import '../../domain/repositories/event_repository.dart';
import '../datasources/event_local_datasource.dart';
import '../datasources/event_remote_datasource.dart';
import '../models/event_model.dart';
import '../../core/network/network_info.dart';

class EventRepositoryImpl implements EventRepository {
  final EventRemoteDataSource remoteDataSource;
  final EventLocalDataSource localDataSource;
  final FirebaseFirestore _firestore;
  final NetworkInfo networkInfo;

  // Cache expiration time - 5 minutes
  static const cacheExpirationMinutes = 5;
  DateTime? _lastEventsRefreshTime;
  DateTime? _lastMyEventsRefreshTime;

  EventRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required FirebaseFirestore firestore,
    required this.networkInfo,
  }) : _firestore = firestore;

  bool _shouldRefreshCache(DateTime? lastRefreshTime) {
    if (lastRefreshTime == null) return true;
    final difference = DateTime.now().difference(lastRefreshTime);
    return difference.inMinutes >= cacheExpirationMinutes;
  }

  @override
  Future<Either<Failure, List<Event>>> getEvents({
    int? page,
    int? pageSize,
    bool? fetchMore,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteEvents = await remoteDataSource.getEvents();
        await localDataSource.cacheEvents(remoteEvents);
        return Right(remoteEvents);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localEvents = await localDataSource.getCachedEvents();
        return Right(localEvents);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, List<Event>>> getMyEvents({
    int? page,
    int? pageSize,
    bool? fetchMore,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteEvents = await remoteDataSource.getMyEvents();
        return Right(remoteEvents);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<Event>>> getFeaturedEvents({
    int? page,
    int? pageSize,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteEvents = await remoteDataSource.getFeaturedEvents();
        return Right(remoteEvents);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<Event>>> getUpcomingEvents({
    int? page,
    int? pageSize,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteEvents = await remoteDataSource.getUpcomingEvents();
        return Right(remoteEvents);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<Event>>> getEventsByCategory(
    String category, {
    int? page,
    int? pageSize,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteEvents =
            await remoteDataSource.getEventsByCategory(category);
        return Right(remoteEvents);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<Event>>> searchEvents(
    String query, {
    int? page,
    int? pageSize,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteEvents = await remoteDataSource.searchEvents(query);
        return Right(remoteEvents);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Event>> getEventById(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteEvent = await remoteDataSource.getEventById(id);
        return Right(remoteEvent);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localEvent = await localDataSource.getEventById(id);
        return Right(localEvent);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, Event>> createEvent({
    required String title,
    required String description,
    required String location,
    required DateTime startDate,
    required DateTime endDate,
    required String imageUrl,
    required List<String> categories,
    required double price,
    required int maxAttendees,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final event = await remoteDataSource.createEvent(
          title: title,
          description: description,
          location: location,
          startDate: startDate,
          endDate: endDate,
          imageUrl: imageUrl,
          categories: categories,
          price: price,
          maxAttendees: maxAttendees,
        );
        return Right(event);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      final event = await localDataSource.createEvent(
        title: title,
        description: description,
        location: location,
        startDate: startDate,
        endDate: endDate,
        imageUrl: imageUrl,
        categories: categories,
        price: price,
        maxAttendees: maxAttendees,
      );
      return Right(event);
    }
  }

  @override
  Future<Either<Failure, Event>> updateEvent(Event event) async {
    if (await networkInfo.isConnected) {
      try {
        final updatedEvent = await remoteDataSource.updateEvent(event);
        return Right(updatedEvent);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteEvent(String eventId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteEvent(eventId);
        return const Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> joinEvent(String eventId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.joinEvent(eventId);
        return const Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> leaveEvent(String eventId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.leaveEvent(eventId);
        return const Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<Event>>> getNearbyEvents({
    required double latitude,
    required double longitude,
    required double radius,
    int? page,
    int? pageSize,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteEvents = await remoteDataSource.getNearbyEvents(
          latitude: latitude,
          longitude: longitude,
          radius: radius,
        );
        return Right(remoteEvents);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<Event>>> getRecommendedEvents() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteEvents = await remoteDataSource.getRecommendedEvents();
        return Right(remoteEvents);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<Event>>> getTrendingEvents() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteEvents = await remoteDataSource.getTrendingEvents();
        return Right(remoteEvents);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<Event>>> getFriendsEvents() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteEvents = await remoteDataSource.getFriendsEvents();
        return Right(remoteEvents);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<Event>>> getAllEvents() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteEvents = await remoteDataSource.getAllEvents();
        return Right(remoteEvents);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localEvents = await localDataSource.getAllEvents();
        return Right(localEvents);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
