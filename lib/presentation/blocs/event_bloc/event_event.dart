import 'package:equatable/equatable.dart';
import '../../../domain/entities/event.dart';

abstract class EventEvent extends Equatable {
  const EventEvent();

  @override
  List<Object?> get props => [];
}

class LoadEvents extends EventEvent {
  final int? page;
  final int? pageSize;
  final bool fetchMore;

  const LoadEvents({
    this.page,
    this.pageSize,
    this.fetchMore = false,
  });

  @override
  List<Object?> get props => [page, pageSize, fetchMore];
}

class LoadMyEvents extends EventEvent {
  final int? page;
  final int? pageSize;
  final bool fetchMore;

  const LoadMyEvents({
    this.page,
    this.pageSize,
    this.fetchMore = false,
  });

  @override
  List<Object?> get props => [page, pageSize, fetchMore];
}

class LoadFeaturedEvents extends EventEvent {
  final int? page;
  final int? pageSize;

  const LoadFeaturedEvents({
    this.page,
    this.pageSize,
  });

  @override
  List<Object?> get props => [page, pageSize];
}

class LoadUpcomingEvents extends EventEvent {
  final int? page;
  final int? pageSize;

  const LoadUpcomingEvents({
    this.page,
    this.pageSize,
  });

  @override
  List<Object?> get props => [page, pageSize];
}

class SearchEvents extends EventEvent {
  final String query;
  final int? page;
  final int? pageSize;

  const SearchEvents({
    required this.query,
    this.page,
    this.pageSize,
  });

  @override
  List<Object?> get props => [query, page, pageSize];
}

class LoadEventsByCategory extends EventEvent {
  final String category;
  final int? page;
  final int? pageSize;

  const LoadEventsByCategory({
    required this.category,
    this.page,
    this.pageSize,
  });

  @override
  List<Object?> get props => [category, page, pageSize];
}

class LoadEventById extends EventEvent {
  final String id;

  const LoadEventById(this.id);

  @override
  List<Object?> get props => [id];
}

class CreateEvent extends EventEvent {
  final String title;
  final String description;
  final String location;
  final DateTime startTime;
  final DateTime endTime;
  final String imageUrl;
  final List<String> categories;
  final double price;
  final int capacity;

  const CreateEvent({
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

class UpdateEvent extends EventEvent {
  final Event event;

  const UpdateEvent(this.event);

  @override
  List<Object?> get props => [event];
}

class DeleteEvent extends EventEvent {
  final String eventId;

  const DeleteEvent(this.eventId);

  @override
  List<Object?> get props => [eventId];
}

class JoinEvent extends EventEvent {
  final String eventId;

  const JoinEvent(this.eventId);

  @override
  List<Object?> get props => [eventId];
}

class LeaveEvent extends EventEvent {
  final String eventId;

  const LeaveEvent(this.eventId);

  @override
  List<Object?> get props => [eventId];
}

class GetNearbyEventsEvent extends EventEvent {
  final double latitude;
  final double longitude;
  final double radius;
  final int? page;
  final int? pageSize;

  const GetNearbyEventsEvent({
    required this.latitude,
    required this.longitude,
    required this.radius,
    this.page,
    this.pageSize,
  });

  @override
  List<Object?> get props => [latitude, longitude, radius, page, pageSize];
}
