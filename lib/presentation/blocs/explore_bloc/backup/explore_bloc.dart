import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';
import '../../../domain/entities/event.dart';
import '../../../domain/entities/venue.dart';
import '../../../domain/repositories/event_repository.dart';
import '../../../domain/repositories/venue_repository.dart';
import '../../../domain/failures/failures.dart';
import 'explore_event.dart';
import 'explore_state.dart';

// Events
abstract class ExploreEvent extends Equatable {
  const ExploreEvent();

  @override
  List<Object?> get props => [];
}

class LoadExploreData extends ExploreEvent {
  const LoadExploreData();
}

class RefreshExploreData extends ExploreEvent {
  const RefreshExploreData();
}

class FilterByCategory extends ExploreEvent {
  final String category;

  const FilterByCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class SearchPlacesAndEvents extends ExploreEvent {
  final String query;

  const SearchPlacesAndEvents(this.query);

  @override
  List<Object?> get props => [query];
}

// BLoC
class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  final EventRepository _eventRepository;
  final VenueRepository _venueRepository;

  ExploreBloc({
    required EventRepository eventRepository,
    required VenueRepository venueRepository,
  })  : _eventRepository = eventRepository,
        _venueRepository = venueRepository,
        super(ExploreInitial()) {
    on<LoadExploreData>(_onLoadExploreData);
    on<RefreshExploreData>(_onRefreshExploreData);
    on<FilterByCategory>(_onFilterByCategory);
  }

  Future<void> _onLoadExploreData(
    LoadExploreData event,
    Emitter<ExploreState> emit,
  ) async {
    try {
      emit(ExploreLoading());

      final recommendedEventsEither =
          await _eventRepository.getRecommendedEvents();
      final trendingEventsEither = await _eventRepository.getTrendingEvents();
      final friendsEventsEither = await _eventRepository.getFriendsEvents();
      final nearbyEventsEither = await _eventRepository.getNearbyEvents(
        latitude: 0.0, // TODO: Get from location service
        longitude: 0.0, // TODO: Get from location service
        radius: 10.0, // TODO: Make configurable
      );
      final popularVenuesEither = await _venueRepository.getPopularVenues();

      // Handle failures
      if (recommendedEventsEither.isLeft() ||
          trendingEventsEither.isLeft() ||
          friendsEventsEither.isLeft() ||
          nearbyEventsEither.isLeft() ||
          popularVenuesEither.isLeft()) {
        emit(ExploreError(
          message: 'Failed to load some data',
          canRetry: true,
        ));
        return;
      }

      emit(ExploreLoaded(
        recommendedEvents: recommendedEventsEither.getOrElse(() => []),
        trendingEvents: trendingEventsEither.getOrElse(() => []),
        friendsEvents: friendsEventsEither.getOrElse(() => []),
        nearbyEvents: nearbyEventsEither.getOrElse(() => []),
        popularVenues: popularVenuesEither.getOrElse(() => []),
      ));
    } catch (e) {
      emit(ExploreError(message: e.toString()));
    }
  }

  Future<void> _onRefreshExploreData(
    RefreshExploreData event,
    Emitter<ExploreState> emit,
  ) async {
    try {
      if (state is ExploreLoaded) {
        final currentState = state as ExploreLoaded;
        emit(currentState.copyWith());

        final recommendedEventsEither =
            await _eventRepository.getRecommendedEvents();
        final trendingEventsEither = await _eventRepository.getTrendingEvents();
        final friendsEventsEither = await _eventRepository.getFriendsEvents();
        final nearbyEventsEither = await _eventRepository.getNearbyEvents(
          latitude: 0.0, // TODO: Get from location service
          longitude: 0.0, // TODO: Get from location service
          radius: 10.0, // TODO: Make configurable
        );
        final popularVenuesEither = await _venueRepository.getPopularVenues();

        // Handle failures
        if (recommendedEventsEither.isLeft() ||
            trendingEventsEither.isLeft() ||
            friendsEventsEither.isLeft() ||
            nearbyEventsEither.isLeft() ||
            popularVenuesEither.isLeft()) {
          emit(ExploreError(
            message: 'Failed to refresh some data',
            canRetry: true,
          ));
          return;
        }

        emit(ExploreLoaded(
          recommendedEvents: recommendedEventsEither.getOrElse(() => []),
          trendingEvents: trendingEventsEither.getOrElse(() => []),
          friendsEvents: friendsEventsEither.getOrElse(() => []),
          nearbyEvents: nearbyEventsEither.getOrElse(() => []),
          popularVenues: popularVenuesEither.getOrElse(() => []),
          selectedCategory: currentState.selectedCategory,
        ));
      }
    } catch (e) {
      emit(ExploreError(message: e.toString()));
    }
  }

  Future<void> _onFilterByCategory(
    FilterByCategory event,
    Emitter<ExploreState> emit,
  ) async {
    try {
      if (state is ExploreLoaded) {
        final currentState = state as ExploreLoaded;
        final filteredEventsEither =
            await _eventRepository.getEventsByCategory(event.category);

        if (filteredEventsEither.isLeft()) {
          emit(ExploreError(
            message: 'Failed to filter by category',
            canRetry: true,
          ));
          return;
        }

        emit(currentState.copyWith(
          recommendedEvents: filteredEventsEither.getOrElse(() => []),
          selectedCategory: event.category,
        ));
      }
    } catch (e) {
      emit(ExploreError(message: e.toString()));
    }
  }
}
