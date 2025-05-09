part of 'event_bloc.dart';

abstract class EventEvent extends Equatable {
  const EventEvent();

  @override
  List<Object> get props => [];
}

class LoadEvents extends EventEvent {}

class CreateEventEvent extends EventEvent {
  final Event event;

  const CreateEventEvent(this.event);

  @override
  List<Object> get props => [event];
}

class DeleteEventEvent extends EventEvent {
  final String eventId;

  const DeleteEventEvent(this.eventId);

  @override
  List<Object> get props => [eventId];
}

class UpdateEventEvent extends EventEvent {
  final Event event;

  const UpdateEventEvent(this.event);

  @override
  List<Object> get props => [event];
}
