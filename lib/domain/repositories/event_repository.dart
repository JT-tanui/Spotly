import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/event.dart';

abstract class EventRepository {
  // Basic event operations
  Future<Either<Failure, List<Event>>> getEvents({
    int? page,
    int? pageSize,
    bool? fetchMore,
  });
  Future<Either<Failure, List<Event>>> getMyEvents({
    int? page,
    int? pageSize,
    bool? fetchMore,
  });
  Future<Either<Failure, List<Event>>> getFeaturedEvents({
    int? page,
    int? pageSize,
  });
  Future<Either<Failure, List<Event>>> getUpcomingEvents({
    int? page,
    int? pageSize,
  });
  Future<Either<Failure, List<Event>>> getEventsByCategory(
    String category, {
    int? page,
    int? pageSize,
  });
  Future<Either<Failure, List<Event>>> searchEvents(
    String query, {
    int? page,
    int? pageSize,
  });
  Future<Either<Failure, Event>> getEventById(String id);

  // CRUD operations
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
  });
  Future<Either<Failure, Event>> updateEvent(Event event);
  Future<Either<Failure, Unit>> deleteEvent(String eventId);

  // Participation operations
  Future<Either<Failure, Unit>> joinEvent(String eventId);
  Future<Either<Failure, Unit>> leaveEvent(String eventId);

  // Location-based operations
  Future<Either<Failure, List<Event>>> getNearbyEvents({
    required double latitude,
    required double longitude,
    required double radius,
    int? page,
    int? pageSize,
  });

  // Explore page specific operations
  Future<Either<Failure, List<Event>>> getRecommendedEvents();
  Future<Either<Failure, List<Event>>> getTrendingEvents();
  Future<Either<Failure, List<Event>>> getFriendsEvents();

  Future<Either<Failure, List<Event>>> getAllEvents();
}
