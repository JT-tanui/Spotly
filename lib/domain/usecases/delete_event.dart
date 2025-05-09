import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../repositories/event_repository.dart';

class DeleteEvent implements UseCase<void, String> {
  final EventRepository repository;

  DeleteEvent(this.repository);

  @override
  Future<Either<Failure, void>> call(String eventId) async {
    return await repository.deleteEvent(eventId);
  }
}
