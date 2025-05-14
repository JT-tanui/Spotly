import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/event.dart';
import '../repositories/event_repository.dart';

class UpdateEvent {
  final EventRepository repository;

  UpdateEvent(this.repository);

  Future<Either<Failure, Event>> call(Event event) async {
    return repository.updateEvent(event);
  }
}
