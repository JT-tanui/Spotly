import 'package:dartz/dartz.dart';
import '../entities/event.dart';
import '../../core/errors/failures.dart';

abstract class EventRepository {
  Future<Either<Failure, List<Event>>> getUserEvents();

  Future<Either<Failure, Event>> createEvent(Event event);

  Future<Either<Failure, void>> deleteEvent(String eventId);

  Future<Either<Failure, Event>> updateEvent(Event event);
}
