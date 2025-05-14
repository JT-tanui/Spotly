import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import '../../../domain/entities/event.dart';
import '../../../domain/repositories/event_repository.dart';
import 'event_event.dart';
import 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final EventRepository _eventRepository;

  EventBloc(this._eventRepository) : super(const EventInitial()) {
    on<LoadEvents>(_onLoadEvents);
    on<LoadMyEvents>(_onLoadMyEvents);
    on<LoadEventById>(_onLoadEventById);
    on<CreateEvent>(_onCreateEvent);
    on<UpdateEvent>(_onUpdateEvent);
    on<DeleteEvent>(_onDeleteEvent);
    on<JoinEvent>(_onJoinEvent);
    on<LeaveEvent>(_onLeaveEvent);
    on<GetNearbyEventsEvent>(_onGetNearbyEvents);
  }

  Future<void> _onLoadEvents(LoadEvents event, Emitter<EventState> emit) async {
    emit(const EventLoading());
    final result = await _eventRepository.getEvents();
    result.fold(
      (failure) => emit(EventError(failure.toString())),
      (events) => emit(EventLoaded(events)),
    );
  }

  Future<void> _onLoadMyEvents(
      LoadMyEvents event, Emitter<EventState> emit) async {
    emit(const EventLoading());
    final result = await _eventRepository.getMyEvents();
    result.fold(
      (failure) => emit(EventError(failure.toString())),
      (events) => emit(EventLoaded(events)),
    );
  }

  Future<void> _onLoadEventById(
      LoadEventById event, Emitter<EventState> emit) async {
    emit(const EventLoading());
    final result = await _eventRepository.getEventById(event.id);
    result.fold(
      (failure) => emit(EventError(failure.toString())),
      (event) => emit(EventDetailLoaded(event)),
    );
  }

  Future<void> _onCreateEvent(
      CreateEvent event, Emitter<EventState> emit) async {
    emit(const EventLoading());
    final result = await _eventRepository.createEvent(
      title: event.title,
      description: event.description,
      location: event.location,
      startDate: event.startTime,
      endDate: event.endTime,
      imageUrl: event.imageUrl,
      categories: event.categories,
      price: event.price,
      maxAttendees: event.capacity,
    );
    result.fold(
      (failure) => emit(EventError(failure.toString())),
      (event) => emit(EventCreated(event)),
    );
  }

  Future<void> _onUpdateEvent(
      UpdateEvent event, Emitter<EventState> emit) async {
    emit(const EventLoading());
    final result = await _eventRepository.updateEvent(event.event);
    result.fold(
      (failure) => emit(EventError(failure.toString())),
      (event) => emit(EventUpdated(event)),
    );
  }

  Future<void> _onDeleteEvent(
      DeleteEvent event, Emitter<EventState> emit) async {
    emit(const EventLoading());
    final result = await _eventRepository.deleteEvent(event.eventId);
    result.fold(
      (failure) => emit(EventError(failure.toString())),
      (_) => emit(EventDeleted(event.eventId)),
    );
  }

  Future<void> _onJoinEvent(JoinEvent event, Emitter<EventState> emit) async {
    emit(const EventLoading());
    final result = await _eventRepository.joinEvent(event.eventId);
    result.fold(
      (failure) => emit(EventError(failure.toString())),
      (_) => emit(EventJoined(event.eventId)),
    );
  }

  Future<void> _onLeaveEvent(LeaveEvent event, Emitter<EventState> emit) async {
    emit(const EventLoading());
    final result = await _eventRepository.leaveEvent(event.eventId);
    result.fold(
      (failure) => emit(EventError(failure.toString())),
      (_) => emit(EventLeft(event.eventId)),
    );
  }

  Future<void> _onGetNearbyEvents(
      GetNearbyEventsEvent event, Emitter<EventState> emit) async {
    emit(const EventLoading());
    final result = await _eventRepository.getNearbyEvents(
      latitude: event.latitude,
      longitude: event.longitude,
      radius: event.radius,
    );
    result.fold(
      (failure) => emit(EventError(failure.toString())),
      (events) => emit(EventLoaded(events)),
    );
  }
}
