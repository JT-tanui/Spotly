import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../core/error/failures.dart';
import '../entities/event.dart';
import '../repositories/event_repository.dart';

class EventParams extends Equatable {
  final String title;
  final String description;
  final String location;
  final DateTime startTime;
  final DateTime endTime;
  final String imageUrl;
  final List<String> categories;
  final double price;
  final int capacity;

  const EventParams({
    required this.title,
    required this.description,
    required this.location,
    required this.startTime,
    required this.endTime,
    required this.imageUrl,
    required this.categories,
    required this.price,
    required this.capacity,
  });

  @override
  List<Object?> get props => [
        title,
        description,
        location,
        startTime,
        endTime,
        imageUrl,
        categories,
        price,
        capacity,
      ];
}

class CreateEvent {
  final EventRepository repository;

  CreateEvent(this.repository);

  Future<Either<Failure, Event>> call(EventParams params) async {
    return repository.createEvent(
      title: params.title,
      description: params.description,
      location: params.location,
      startDate: params.startTime,
      endDate: params.endTime,
      imageUrl: params.imageUrl,
      categories: params.categories,
      price: params.price,
      maxAttendees: params.capacity,
    );
  }
}
