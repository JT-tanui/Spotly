import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/event.dart';
import '../repositories/event_repository.dart';

class UpdateEvent implements UseCase<Event, Event> {
  final EventRepository repository;

  UpdateEvent(this.repository);

  @override
  Future<Either<Failure, Event>> call(Event event) async {
    return await repository.updateEvent(event);
  }
}
