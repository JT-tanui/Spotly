import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import '../../../domain/entities/event.dart';
import '../../../domain/usecases/create_event.dart';
import '../../../domain/usecases/get_user_events.dart';
import '../../../domain/usecases/update_event.dart';
import '../../../domain/usecases/delete_event.dart';
import 'event_event.dart';
import 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final GetUserEvents getUserEvents;
  final CreateEvent createEvent;
  final UpdateEvent updateEvent;
  final DeleteEvent deleteEvent;

  EventBloc({
    required this.getUserEvents,
    required this.createEvent,
    required this.updateEvent,
    required this.deleteEvent,
  }) : super(EventInitial()) {
    on<GetUserEventsEvent>(_onGetUserEvents);
    on<CreateEventEvent>(_onCreateEvent);
    on<UpdateEventEvent>(_onUpdateEvent);
    on<DeleteEventEvent>(_onDeleteEvent);
  }

  Future<void> _onGetUserEvents(
    GetUserEventsEvent event,
    Emitter<EventState> emit,
  ) async {
    emit(EventLoading());
    final result = await getUserEvents(event.userId);
    result.fold(
      (failure) => emit(EventError(failure.toString())),
      (events) => emit(EventLoaded(events)),
    );
  }

  Future<void> _onCreateEvent(
    CreateEventEvent event,
    Emitter<EventState> emit,
  ) async {
    emit(EventLoading());
    final newEvent = Event(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: event.title,
      description: event.description,
      startTime: event.startTime,
      endTime: event.endTime,
      latitude: 0, // TODO: Get from location service
      longitude: 0, // TODO: Get from location service
      address: event.address,
      createdBy: event.createdBy,
      createdAt: DateTime.now(),
      categories: event.categories,
      maxAttendees: event.maxAttendees,
      price: event.price,
      isPrivate: event.isPrivate,
    );

    final result = await createEvent(newEvent);
    result.fold(
      (failure) => emit(EventError(failure.toString())),
      (_) async {
        final eventsResult = await getUserEvents(event.createdBy);
        eventsResult.fold(
          (failure) => emit(EventError(failure.toString())),
          (events) => emit(EventLoaded(events)),
        );
      },
    );
  }

  Future<void> _onUpdateEvent(
    UpdateEventEvent event,
    Emitter<EventState> emit,
  ) async {
    emit(EventLoading());
    final result = await updateEvent(event.event);
    result.fold(
      (failure) => emit(EventError(failure.toString())),
      (_) async {
        final eventsResult = await getUserEvents(event.event.createdBy);
        eventsResult.fold(
          (failure) => emit(EventError(failure.toString())),
          (events) => emit(EventLoaded(events)),
        );
      },
    );
  }

  Future<void> _onDeleteEvent(
    DeleteEventEvent event,
    Emitter<EventState> emit,
  ) async {
    emit(EventLoading());
    final result = await deleteEvent(event.eventId);
    result.fold(
      (failure) => emit(EventError(failure.toString())),
      (_) async {
        // TODO: Get user ID from current state
        final eventsResult = await getUserEvents('current_user_id');
        eventsResult.fold(
          (failure) => emit(EventError(failure.toString())),
          (events) => emit(EventLoaded(events)),
        );
      },
    );
  }
}
