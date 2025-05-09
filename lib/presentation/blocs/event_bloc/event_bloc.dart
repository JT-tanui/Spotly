import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/event.dart';
import '../../../domain/usecases/get_user_events.dart';
import '../../../domain/usecases/create_event.dart';
import '../../../domain/usecases/update_event.dart';
import '../../../domain/usecases/delete_event.dart';
import '../../../core/usecases/usecase.dart';

part 'event_event.dart';
part 'event_state.dart';

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
  }) : super(EventsInitial()) {
    on<LoadEvents>(_onLoadEvents);
    on<CreateEventEvent>(_onCreateEvent);
    on<DeleteEventEvent>(_onDeleteEvent);
    on<UpdateEventEvent>(_onUpdateEvent);
  }

  Future<void> _onLoadEvents(
    LoadEvents event,
    Emitter<EventState> emit,
  ) async {
    emit(EventsLoading());

    final result = await getUserEvents(NoParams());

    result.fold(
      (failure) => emit(EventsError(message: 'Failed to load events')),
      (events) => emit(EventsLoaded(events: events)),
    );
  }

  Future<void> _onCreateEvent(
    CreateEventEvent event,
    Emitter<EventState> emit,
  ) async {
    emit(EventsLoading());

    final result = await createEvent(event.event);

    result.fold(
      (failure) => emit(EventsError(message: 'Failed to create event')),
      (event) => add(LoadEvents()),
    );
  }

  Future<void> _onDeleteEvent(
    DeleteEventEvent event,
    Emitter<EventState> emit,
  ) async {
    emit(EventsLoading());

    final result = await deleteEvent(event.eventId);

    result.fold(
      (failure) => emit(EventsError(message: 'Failed to delete event')),
      (_) => add(LoadEvents()),
    );
  }

  Future<void> _onUpdateEvent(
    UpdateEventEvent event,
    Emitter<EventState> emit,
  ) async {
    emit(EventsLoading());

    final result = await updateEvent(event.event);

    result.fold(
      (failure) => emit(EventsError(message: 'Failed to update event')),
      (event) => add(LoadEvents()),
    );
  }
}
