part of 'event_bloc.dart';

abstract class EventState extends Equatable {
  const EventState();

  @override
  List<Object> get props => [];
}

class EventsInitial extends EventState {}

class EventsLoading extends EventState {}

class EventsLoaded extends EventState {
  final List<Event> events;

  const EventsLoaded({required this.events});

  @override
  List<Object> get props => [events];
}

class EventsError extends EventState {
  final String message;

  const EventsError({required this.message});

  @override
  List<Object> get props => [message];
}
