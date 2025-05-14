import 'package:equatable/equatable.dart';
import '../../../domain/entities/event.dart';

abstract class EventState extends Equatable {
  const EventState();

  @override
  List<Object?> get props => [];
}

class EventInitial extends EventState {
  const EventInitial();
}

class EventLoading extends EventState {
  final bool isFirstLoad;

  const EventLoading({this.isFirstLoad = true});

  @override
  List<Object?> get props => [isFirstLoad];
}

class EventLoaded extends EventState {
  final List<Event> events;
  final bool hasReachedMax;
  final int? currentPage;
  final int? totalPages;
  final int? totalEvents;

  const EventLoaded(
    this.events, {
    this.hasReachedMax = false,
    this.currentPage,
    this.totalPages,
    this.totalEvents,
  });

  EventLoaded copyWith({
    List<Event>? events,
    bool? hasReachedMax,
    int? currentPage,
    int? totalPages,
    int? totalEvents,
  }) {
    return EventLoaded(
      events ?? this.events,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalEvents: totalEvents ?? this.totalEvents,
    );
  }

  @override
  List<Object?> get props => [
        events,
        hasReachedMax,
        currentPage,
        totalPages,
        totalEvents,
      ];
}

class EventDetailLoaded extends EventState {
  final Event event;

  const EventDetailLoaded(this.event);

  @override
  List<Object?> get props => [event];
}

class EventError extends EventState {
  final String message;

  const EventError(this.message);

  @override
  List<Object?> get props => [message];
}

class EventCreated extends EventState {
  final Event event;

  const EventCreated(this.event);

  @override
  List<Object?> get props => [event];
}

class EventUpdated extends EventState {
  final Event event;

  const EventUpdated(this.event);

  @override
  List<Object?> get props => [event];
}

class EventDeleted extends EventState {
  final String eventId;

  const EventDeleted(this.eventId);

  @override
  List<Object?> get props => [eventId];
}

class EventJoined extends EventState {
  final String eventId;

  const EventJoined(this.eventId);

  @override
  List<Object?> get props => [eventId];
}

class EventLeft extends EventState {
  final String eventId;

  const EventLeft(this.eventId);

  @override
  List<Object?> get props => [eventId];
}
