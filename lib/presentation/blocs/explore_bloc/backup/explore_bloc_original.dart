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
import 'dart:math';

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

class LoadMoreExploreData extends ExploreEvent {
  const LoadMoreExploreData();

  @override
  List<Object?> get props => [];
}

class LoadTrendingNearby extends ExploreEvent {
  const LoadTrendingNearby();

  @override
  List<Object?> get props => [];
}

class LoadWhatsHotNearYou extends ExploreEvent {
  const LoadWhatsHotNearYou();

  @override
  List<Object?> get props => [];
}

// BLoC
class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  ExploreBloc() : super(ExploreInitial()) {
    on<LoadExploreData>(_onLoadExploreData);
    on<RefreshExploreData>(_onRefreshExploreData);
    on<FilterByCategory>(_onFilterByCategory);
    on<LoadMoreExploreData>(_onLoadMoreExploreData);
    on<SearchPlacesAndEvents>(_onSearchPlacesAndEvents);
    on<LoadTrendingNearby>(_onLoadTrendingNearby);
    on<LoadWhatsHotNearYou>(_onLoadWhatsHotNearYou);
  }

  Future<void> _onLoadExploreData(
    LoadExploreData event,
    Emitter<ExploreState> emit,
  ) async {
    try {
      emit(ExploreLoading());
      await Future.delayed(
          const Duration(milliseconds: 800)); // Simulate network delay

      emit(ExploreLoaded(
        recommendedEvents: _generateMockEvents(5, 'Recommended'),
        trendingEvents: _generateMockEvents(5, 'Trending'),
        friendsEvents: _generateMockEvents(3, 'Friends'),
        nearbyEvents: _generateMockEvents(4, 'Nearby'),
        popularVenues: _generateMockVenues(6),
        hasMoreData: true,
        page: 1,
      ));
    } catch (e) {
      emit(ExploreError(
          message: 'Failed to load explore data: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshExploreData(
    RefreshExploreData event,
    Emitter<ExploreState> emit,
  ) async {
    try {
      // If currently loaded, show a refreshing state but keep the old data
      if (state is ExploreLoaded) {
        final currentState = state as ExploreLoaded;
        emit(currentState.copyWith(isRefreshing: true));

        await Future.delayed(
            const Duration(milliseconds: 800)); // Simulate network delay

        emit(ExploreLoaded(
          recommendedEvents: _generateMockEvents(5, 'Recommended'),
          trendingEvents: _generateMockEvents(5, 'Trending'),
          friendsEvents: _generateMockEvents(3, 'Friends'),
          nearbyEvents: _generateMockEvents(4, 'Nearby'),
          popularVenues: _generateMockVenues(6),
          selectedCategory: currentState.selectedCategory,
          hasMoreData: true,
          page: 1,
        ));
      } else {
        add(const LoadExploreData());
      }
    } catch (e) {
      emit(ExploreError(
          message: 'Failed to refresh explore data: ${e.toString()}'));
    }
  }

  Future<void> _onFilterByCategory(
    FilterByCategory event,
    Emitter<ExploreState> emit,
  ) async {
    try {
      if (state is ExploreLoaded) {
        final currentState = state as ExploreLoaded;
        emit(currentState.copyWith(isRefreshing: true));

        await Future.delayed(
            const Duration(milliseconds: 500)); // Simulate filtering delay

        // Generate mock filtered data
        final filteredEvents = _generateMockEvents(
          4,
          event.category
              .split(' ')
              .last, // Use the category name in the event title
        );

        emit(currentState.copyWith(
          recommendedEvents: filteredEvents,
          selectedCategory: event.category,
          isRefreshing: false,
          hasMoreData: true,
          page: 1,
        ));
      }
    } catch (e) {
      emit(ExploreError(
          message: 'Failed to filter by category: ${e.toString()}'));
    }
  }

  Future<void> _onLoadMoreExploreData(
    LoadMoreExploreData event,
    Emitter<ExploreState> emit,
  ) async {
    try {
      if (state is ExploreLoaded) {
        final currentState = state as ExploreLoaded;

        // If we have no more data, don't do anything
        if (!currentState.hasMoreData) return;

        // Show loading more indicator
        emit(currentState.copyWith(isLoadingMore: true));

        // Simulate network delay
        await Future.delayed(const Duration(milliseconds: 800));

        // Generate more mock events
        final moreEvents = _generateMockEvents(8, 'More');

        // Decide if there's more data (for demo, we'll limit to 3 pages)
        final nextPage = currentState.page + 1;
        final hasMoreData = nextPage < 3;

        // Append new events to existing ones
        emit(currentState.copyWith(
          nearbyEvents: [...currentState.nearbyEvents, ...moreEvents],
          isLoadingMore: false,
          hasMoreData: hasMoreData,
          page: nextPage,
        ));
      }
    } catch (e) {
      if (state is ExploreLoaded) {
        final currentState = state as ExploreLoaded;
        emit(currentState.copyWith(
          isLoadingMore: false,
          loadMoreError: 'Failed to load more data: ${e.toString()}',
        ));
      } else {
        emit(
            ExploreError(message: 'Failed to load more data: ${e.toString()}'));
      }
    }
  }

  Future<void> _onSearchPlacesAndEvents(
    SearchPlacesAndEvents event,
    Emitter<ExploreState> emit,
  ) async {
    try {
      // If we're already in a loaded state, keep some of the existing data
      // while showing a loading indicator for the search
      if (state is ExploreLoaded) {
        final currentState = state as ExploreLoaded;
        emit(currentState.copyWith(isSearching: true));
      } else {
        emit(ExploreLoading());
      }

      // Simulate search delay
      await Future.delayed(const Duration(milliseconds: 800));

      // Generate mock events for search results
      final mockEvents = _generateMockEvents(10, 'Search');

      // Filter mock data based on search query
      final searchQuery = event.query.toLowerCase();
      final searchResults = mockEvents
          .where((event) =>
              event.title.toLowerCase().contains(searchQuery) ||
              event.description.toLowerCase().contains(searchQuery) ||
              event.location.toLowerCase().contains(searchQuery))
          .toList();

      // For demo, we'll return a specialized search results state
      if (state is ExploreLoaded) {
        final currentState = state as ExploreLoaded;
        emit(currentState.copyWith(
          searchResults: searchResults,
          isSearching: false,
          searchQuery: event.query,
        ));
      } else {
        emit(ExploreLoaded(
          recommendedEvents: [],
          trendingEvents: [],
          friendsEvents: [],
          nearbyEvents: [],
          popularVenues: [],
          searchResults: searchResults,
          searchQuery: event.query,
          hasMoreData: false,
          page: 1,
        ));
      }
    } catch (e) {
      emit(ExploreError(
          message: 'Failed to search places and events: ${e.toString()}'));
    }
  }

  Future<void> _onLoadTrendingNearby(
    LoadTrendingNearby event,
    Emitter<ExploreState> emit,
  ) async {
    try {
      if (state is ExploreLoaded) {
        final currentState = state as ExploreLoaded;
        emit(currentState.copyWith(isLoadingTrending: true));

        // Simulate network delay
        await Future.delayed(const Duration(milliseconds: 800));

        // Generate mock trending data
        final trendingEvents = _generateMockEvents(5, 'Hot');
        final trendingVenues = _generateMockVenues(3);

        emit(currentState.copyWith(
          trendingEvents: trendingEvents,
          popularVenues: trendingVenues,
          isLoadingTrending: false,
        ));
      }
    } catch (e) {
      if (state is ExploreLoaded) {
        final currentState = state as ExploreLoaded;
        emit(currentState.copyWith(
          isLoadingTrending: false,
        ));
      } else {
        emit(ExploreError(
            message: 'Failed to load trending nearby: ${e.toString()}'));
      }
    }
  }

  Future<void> _onLoadWhatsHotNearYou(
    LoadWhatsHotNearYou event,
    Emitter<ExploreState> emit,
  ) async {
    try {
      if (state is ExploreLoaded) {
        final currentState = state as ExploreLoaded;
        emit(currentState.copyWith(isLoadingHot: true));

        // Simulate network delay
        await Future.delayed(const Duration(milliseconds: 800));

        // Generate mock "What's Hot" data
        final hotEvents = _generateMockEvents(3, 'Hot');

        emit(currentState.copyWith(
          hotEvents: hotEvents,
          isLoadingHot: false,
        ));
      }
    } catch (e) {
      if (state is ExploreLoaded) {
        final currentState = state as ExploreLoaded;
        emit(currentState.copyWith(
          isLoadingHot: false,
        ));
      } else {
        emit(ExploreError(
            message: 'Failed to load what\'s hot: ${e.toString()}'));
      }
    }
  }

  // Helper to generate mock events
  List<Event> _generateMockEvents(int count, String prefix) {
    final List<String> categories = [
      'Music',
      'Food',
      'Sports',
      'Art',
      'Technology',
      'Outdoor'
    ];
    final List<String> locations = [
      'San Francisco',
      'Mission District',
      'SoMa',
      'Castro',
      'North Beach',
      'Marina'
    ];

    // Random images that appear to be events
    final List<String> imageUrls = [
      'https://source.unsplash.com/random/800x600/?concert',
      'https://source.unsplash.com/random/800x600/?festival',
      'https://source.unsplash.com/random/800x600/?party',
      'https://source.unsplash.com/random/800x600/?exhibition',
      'https://source.unsplash.com/random/800x600/?conference',
    ];

    final random = Random();

    return List.generate(
      count,
      (index) {
        final category = categories[random.nextInt(categories.length)];
        final location = locations[random.nextInt(locations.length)];
        final imageUrl = imageUrls[random.nextInt(imageUrls.length)];

        return Event(
          id: 'mock-event-$prefix-$index',
          title: '$prefix $category Event ${index + 1}',
          description: 'This is a mock $category event in $location',
          startTime:
              DateTime.now().add(Duration(hours: random.nextInt(48) + 1)),
          endTime: DateTime.now().add(Duration(hours: random.nextInt(48) + 3)),
          location: location,
          imageUrl: imageUrl,
          price: random.nextInt(50) + 10.0,
          categories: [category],
          capacity: random.nextInt(500) + 100,
          currentAttendees: random.nextInt(200) + 50,
          latitude: 37.7749 + (random.nextDouble() - 0.5) * 0.05,
          longitude: -122.4194 + (random.nextDouble() - 0.5) * 0.05,
          organizerId: 'org-${random.nextInt(100)}',
          organizerName: 'Mock Organizer ${random.nextInt(10) + 1}',
          rating: 3.5 + random.nextDouble() * 1.5,
          reviewCount: random.nextInt(100) + 10,
          tags: ['mock', category.toLowerCase(), 'event'],
        );
      },
    );
  }

  // Helper to generate mock venues
  List<Venue> _generateMockVenues(int count) {
    final List<String> types = [
      'Restaurant',
      'Bar',
      'Café',
      'Club',
      'Gallery',
      'Theater'
    ];
    final List<String> locations = [
      'San Francisco',
      'Mission District',
      'SoMa',
      'Castro',
      'North Beach',
      'Marina'
    ];

    // Random images that appear to be venues
    final List<String> imageUrls = [
      'https://source.unsplash.com/random/800x600/?restaurant',
      'https://source.unsplash.com/random/800x600/?bar',
      'https://source.unsplash.com/random/800x600/?cafe',
      'https://source.unsplash.com/random/800x600/?club',
      'https://source.unsplash.com/random/800x600/?theater',
    ];

    final random = Random();

    return List.generate(
      count,
      (index) {
        final type = types[random.nextInt(types.length)];
        final location = locations[random.nextInt(locations.length)];
        final imageUrl = imageUrls[random.nextInt(imageUrls.length)];

        return Venue(
          id: 'mock-venue-$index',
          name: '$type ${random.nextInt(100) + 1}',
          description: 'This is a mock $type in $location',
          address: '$location, San Francisco, CA',
          imageUrl: imageUrl,
          rating: 3.5 + random.nextDouble() * 1.5,
          reviewCount: random.nextInt(200) + 20,
          categories: [type],
          latitude: 37.7749 + (random.nextDouble() - 0.5) * 0.05,
          longitude: -122.4194 + (random.nextDouble() - 0.5) * 0.05,
          isOpen: random.nextBool(),
          phoneNumber: '+1 (415) 555-${1000 + random.nextInt(9000)}',
          website: 'https://example.com/venue$index',
          openingHours: {
            'monday': '9:00 AM - 9:00 PM',
            'tuesday': '9:00 AM - 9:00 PM',
            'wednesday': '9:00 AM - 9:00 PM',
            'thursday': '9:00 AM - 9:00 PM',
            'friday': '9:00 AM - 10:00 PM',
            'saturday': '10:00 AM - 10:00 PM',
            'sunday': '10:00 AM - 8:00 PM',
          },
        );
      },
    );
  }
}
