import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../core/error/failures.dart';
import '../entities/event.dart';
import '../repositories/event_repository.dart';

class PaginationParams extends Equatable {
  final int? page;
  final int? pageSize;

  const PaginationParams({
    this.page,
    this.pageSize,
  });

  @override
  List<Object?> get props => [page, pageSize];
}

class GetUpcomingEvents {
  final EventRepository repository;

  GetUpcomingEvents(this.repository);

  Future<Either<Failure, List<Event>>> call([PaginationParams? params]) async {
    return repository.getUpcomingEvents(
      page: params?.page,
      pageSize: params?.pageSize,
    );
  }
}
