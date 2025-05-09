import 'package:equatable/equatable.dart';
import '../../../domain/entities/event.dart';
import '../../../domain/entities/event_category.dart';

abstract class EventEvent extends Equatable {
  const EventEvent();

  @override
  List<Object?> get props => [];
}

class GetUserEventsEvent extends EventEvent {
  final String userId;

  const GetUserEventsEvent(this.userId);

  @override
  List<Object> get props => [userId];
}

class CreateEventEvent extends EventEvent {
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final String address;
  final List<EventCategory> categories;
  final int? maxAttendees;
  final double? price;
  final bool isPrivate;
  final String createdBy;

  const CreateEventEvent({
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.address,
    required this.categories,
    this.maxAttendees,
    this.price,
    this.isPrivate = false,
    required this.createdBy,
  });

  @override
  List<Object?> get props => [
        title,
        description,
        startTime,
        endTime,
        address,
        categories,
        maxAttendees,
        price,
        isPrivate,
        createdBy,
      ];
}

class UpdateEventEvent extends EventEvent {
  final Event event;

  const UpdateEventEvent(this.event);

  @override
  List<Object> get props => [event];
}

class DeleteEventEvent extends EventEvent {
  final String eventId;

  const DeleteEventEvent(this.eventId);

  @override
  List<Object> get props => [eventId];
}
