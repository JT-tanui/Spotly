import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/event.dart';
import '../repositories/event_repository.dart';

class GetUserEvents implements UseCase<List<Event>, String> {
  final EventRepository repository;

  GetUserEvents(this.repository);

  @override
  Future<Either<Failure, List<Event>>> call(String userId) async {
    return await repository.getUserEvents(userId);
  }
}
