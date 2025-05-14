import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../repositories/event_repository.dart';

class DeleteEvent {
  final EventRepository repository;

  DeleteEvent(this.repository);

  Future<Either<Failure, Unit>> call(String eventId) async {
    return repository.deleteEvent(eventId);
  }
}
