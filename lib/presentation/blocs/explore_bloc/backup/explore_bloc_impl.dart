import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/event.dart';
import '../../../domain/entities/venue.dart';
import '../../../domain/repositories/event_repository.dart';
import '../../../domain/repositories/venue_repository.dart';
import '../../../domain/usecases/get_featured_events.dart';
import '../../../domain/usecases/get_upcoming_events.dart';
import 'explore_bloc.dart' as bloc;
import 'explore_event.dart' as events;
import 'explore_state.dart' as states;
import 'package:flutter/foundation.dart';

class ExploreBlocImpl extends bloc.ExploreBloc {
  final GetFeaturedEvents _getFeaturedEvents;
  final GetUpcomingEvents _getUpcomingEvents;
  final EventRepository _eventRepository;
  final VenueRepository _venueRepository;

  ExploreBlocImpl({
    required GetFeaturedEvents getFeaturedEvents,
    required GetUpcomingEvents getUpcomingEvents,
    required EventRepository eventRepository,
    required VenueRepository venueRepository,
  })  : _getFeaturedEvents = getFeaturedEvents,
        _getUpcomingEvents = getUpcomingEvents,
        _eventRepository = eventRepository,
        _venueRepository = venueRepository,
        super(
          eventRepository: eventRepository,
          venueRepository: venueRepository,
        );

  @override
  Future<void> _onLoadExploreData(
    events.LoadExploreData event,
    Emitter<states.ExploreState> emit,
  ) async {
    try {
      emit(states.ExploreLoading());

      // Load all required data in parallel
      final results = await Future.wait([
        _getFeaturedEvents(),
        _getUpcomingEvents(),
      ]);

      final featuredEvents = results[0] as List<Event>;
      final upcomingEvents = results[1] as List<Event>;

      // Even if the data is empty, we should show an empty state rather than an error
      emit(states.ExploreLoaded(
        recommendedEvents: featuredEvents,
        trendingEvents: featuredEvents,
        friendsEvents: upcomingEvents,
        nearbyEvents: upcomingEvents,
        popularVenues: [], // TODO: Implement venue loading
      ));
    } catch (e) {
      debugPrint('Error loading explore data: $e');
      // Instead of emitting an error, emit an empty state
      emit(states.ExploreLoaded(
        recommendedEvents: const [],
        trendingEvents: const [],
        friendsEvents: const [],
        nearbyEvents: const [],
        popularVenues: const [],
        errorMessage: 'Could not load events. Tap to retry.',
      ));
    }
  }

  @override
  Future<void> _onRefreshExploreData(
    events.RefreshExploreData event,
    Emitter<states.ExploreState> emit,
  ) async {
    try {
      final results = await Future.wait([
        _getFeaturedEvents(),
        _getUpcomingEvents(),
      ]);

      final featuredEvents = results[0] as List<Event>;
      final upcomingEvents = results[1] as List<Event>;

      emit(states.ExploreLoaded(
        recommendedEvents: featuredEvents,
        trendingEvents: featuredEvents,
        friendsEvents: upcomingEvents,
        nearbyEvents: upcomingEvents,
        popularVenues: [],
      ));
    } catch (e) {
      emit(states.ExploreError(
        message: 'Failed to refresh explore data: ${e.toString()}',
      ));
    }
  }

  @override
  Future<void> _onFilterByCategory(
    events.FilterByCategory event,
    Emitter<states.ExploreState> emit,
  ) async {
    try {
      final result = await _eventRepository.getEventsByCategory(event.category);
      result.fold(
        (failure) => emit(states.ExploreError(
          message: 'Failed to filter by category: ${failure.toString()}',
        )),
        (events) {
          if (state is states.ExploreLoaded) {
            final currentState = state as states.ExploreLoaded;
            emit(currentState.copyWith(
              recommendedEvents: events,
              selectedCategory: event.category,
            ));
          } else {
            emit(states.ExploreLoaded(
              recommendedEvents: events,
              trendingEvents: const [],
              friendsEvents: const [],
              nearbyEvents: const [],
              popularVenues: const [],
              selectedCategory: event.category,
            ));
          }
        },
      );
    } catch (e) {
      emit(states.ExploreError(
        message: 'Failed to filter by category: ${e.toString()}',
      ));
    }
  }
}
