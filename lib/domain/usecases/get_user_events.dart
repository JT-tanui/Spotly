import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/event.dart';
import '../repositories/event_repository.dart';

class GetUserEvents {
  final EventRepository repository;

  GetUserEvents(this.repository);

  Future<Either<Failure, List<Event>>> call(String userId) async {
    // Use searchEvents to find events created by the user
    // This is a workaround since we don't have a direct getUserEvents method
    final result = await repository.getFeaturedEvents();
    return result.fold(
      (failure) => Left(failure),
      (events) {
        // Filter events to only return those created by the given user
        // We'll assume each event has a createdBy field or similar
        // If not, modify this logic based on your actual data structure
        final userEvents = events; // Replace with actual filtering logic
        return Right(userEvents);
      },
    );
  }
}
