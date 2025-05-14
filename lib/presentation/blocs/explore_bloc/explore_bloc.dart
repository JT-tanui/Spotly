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
    on<UpdateExploreWithMapData>(_onUpdateExploreWithMapData);
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

  Future<void> _onUpdateExploreWithMapData(
    UpdateExploreWithMapData event,
    Emitter<ExploreState> emit,
  ) async {
    try {
      // If we already have an explore state, update it with map data
      if (state is ExploreLoaded) {
        final currentState = state as ExploreLoaded;

        // Only update if we have events from the map
        if (event.events.isNotEmpty) {
          // For any missing data in map events, enhance it with more details
          final enhancedEvents = event.events.map((e) {
            // If the event has a basic/missing title, generate a better one
            String title = e.title;
            if (title.isEmpty ||
                title.contains('mock') ||
                title.contains('event')) {
              final eventTypes = [
                'Festival',
                'Concert',
                'Exhibition',
                'Market',
                'Conference',
                'Party'
              ];
              final random = Random();
              final randomType = eventTypes[random.nextInt(eventTypes.length)];

              // Create a better title based on location or category
              if (e.categories.isNotEmpty) {
                title =
                    '${e.categories.first} $randomType in ${_formatLocation(e.location)}';
              } else {
                title =
                    'Featured $randomType in ${_formatLocation(e.location)}';
              }
            }

            // Enhance the description if needed
            String description = e.description;
            if (description.isEmpty || description.contains('mock')) {
              description =
                  'Join us for this exciting event in ${_formatLocation(e.location)}! Discover the best of what the city has to offer.';
            }

            // Update location to Kenyan locations if needed
            String location = e.location;
            if (location.contains('San Francisco') || location.isEmpty) {
              location = _getRandomKenyanLocation();
            }

            // Create a new enhanced event
            return Event(
              id: e.id,
              title: title,
              description: description,
              location: location,
              latitude: e.latitude,
              longitude: e.longitude,
              startDate: e.startDate,
              endDate: e.endDate,
              imageUrl: e.imageUrl,
              categories: e.categories,
              attendees: e.attendees,
              organizer: e.organizer,
              price: e.price,
              rating: e.rating,
              reviewCount: e.reviewCount,
              tags: e.tags,
              venue: e.venue,
            );
          }).toList();

          // Add some Kenyan-specific events if there aren't many
          if (enhancedEvents.length < 5) {
            enhancedEvents
                .addAll(_generateKenyanEvents(5 - enhancedEvents.length));
          }

          // Distribute events to different sections based on criteria
          final List<Event> recommendedEvents = [];
          final List<Event> trendingEvents = [];
          final List<Event> nearbyEvents = [];
          final List<Event> hotEvents = [];

          for (final event in enhancedEvents) {
            if (event.rating >= 4.0) {
              recommendedEvents.add(event);
            } else if (event.attendees > 100) {
              trendingEvents.add(event);
            } else if (event.categories.any((c) =>
                c.toLowerCase().contains('food') ||
                c.toLowerCase().contains('music'))) {
              hotEvents.add(event);
            } else {
              nearbyEvents.add(event);
            }
          }

          // Ensure each category has at least one event
          if (recommendedEvents.isEmpty && enhancedEvents.isNotEmpty) {
            recommendedEvents.add(enhancedEvents.first);
          }

          if (trendingEvents.isEmpty && enhancedEvents.length > 1) {
            trendingEvents.add(enhancedEvents[1 % enhancedEvents.length]);
          }

          if (hotEvents.isEmpty && enhancedEvents.length > 2) {
            hotEvents.add(enhancedEvents[2 % enhancedEvents.length]);
          }

          // Update state with the new categorized and enhanced events from map
          emit(currentState.copyWith(
            recommendedEvents:
                recommendedEvents.isNotEmpty ? recommendedEvents : null,
            trendingEvents: trendingEvents.isNotEmpty ? trendingEvents : null,
            nearbyEvents: nearbyEvents.isNotEmpty ? nearbyEvents : null,
            hotEvents: hotEvents.isNotEmpty ? hotEvents : null,
          ));
        }
      }
    } catch (e) {
      // If there's an error, log it but don't change state to error
      print('Failed to update explore with map data: ${e.toString()}');
    }
  }

  // Helper to format location names
  String _formatLocation(String location) {
    if (location.isEmpty) return 'Nairobi';

    // Remove any county/state names
    if (location.contains(',')) {
      return location.split(',').first.trim();
    }

    return location;
  }

  // Generate events with Kenyan locations
  List<Event> _generateKenyanEvents(int count) {
    final random = Random();
    final now = DateTime.now();

    final List<String> eventTypes = [
      'Music Festival',
      'Food Festival',
      'Cultural Exhibition',
      'Art Gallery',
      'Tech Meetup',
      'Farmers Market',
      'Jazz Night',
      'Poetry Slam',
      'Film Screening'
    ];

    final List<String> imageUrls = [
      'https://source.unsplash.com/random/800x600/?nairobi',
      'https://source.unsplash.com/random/800x600/?kenya',
      'https://source.unsplash.com/random/800x600/?safari',
      'https://source.unsplash.com/random/800x600/?african',
      'https://source.unsplash.com/random/800x600/?festival',
    ];

    return List.generate(count, (index) {
      final location = _getRandomKenyanLocation();
      final eventType = eventTypes[random.nextInt(eventTypes.length)];
      final startDate = now.add(Duration(days: random.nextInt(30)));
      final endDate = startDate.add(Duration(hours: 2 + random.nextInt(6)));

      // Generate random coordinates around Nairobi
      // Nairobi: -1.286389, 36.817223
      final latitude = -1.286389 + (random.nextDouble() - 0.5) * 0.1;
      final longitude = 36.817223 + (random.nextDouble() - 0.5) * 0.1;

      return Event(
        id: 'kenya-event-${DateTime.now().millisecondsSinceEpoch}-$index',
        title: '$eventType in $location',
        description:
            'Experience the best of $location with this amazing $eventType. Join us for an unforgettable time!',
        startDate: startDate,
        endDate: endDate,
        location: location,
        imageUrl: imageUrls[random.nextInt(imageUrls.length)],
        price: (random.nextInt(2000) + 500).toDouble(),
        categories: [eventType.split(' ').first],
        attendees: random.nextInt(300) + 50,
        latitude: latitude,
        longitude: longitude,
        organizer: 'Spotly Kenya',
        rating: 3.5 + random.nextDouble() * 1.5,
        reviewCount: random.nextInt(100) + 10,
        tags: [
          'kenya',
          'nairobi',
          eventType.toLowerCase().replaceAll(' ', '-')
        ],
      );
    });
  }

  // Get a random Kenyan location
  String _getRandomKenyanLocation() {
    final List<String> kenyanLocations = [
      'Nairobi',
      'Mombasa',
      'Kisumu',
      'Nakuru',
      'Eldoret',
      'Westlands',
      'Karen',
      'Kilimani',
      'Lamu',
      'Malindi',
      'Diani Beach',
      'Naivasha',
      'Thika',
      'Machakos',
      'Kitale',
      'Nyeri',
      'Kakamega',
      'Meru',
      'Nanyuki',
      'Athi River'
    ];

    return kenyanLocations[Random().nextInt(kenyanLocations.length)];
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
        final now = DateTime.now();
        final startDate = now.add(Duration(hours: random.nextInt(48) + 1));
        final endDate = startDate.add(Duration(hours: random.nextInt(48) + 3));

        return Event(
          id: 'mock-event-$prefix-$index',
          title: '$prefix $category Event ${index + 1}',
          description: 'This is a mock $category event in $location',
          startDate: startDate,
          endDate: endDate,
          location: location,
          imageUrl: imageUrl,
          price: random.nextInt(50) + 10.0,
          categories: [category],
          attendees: random.nextInt(200) + 50,
          latitude: 37.7749 + (random.nextDouble() - 0.5) * 0.05,
          longitude: -122.4194 + (random.nextDouble() - 0.5) * 0.05,
          organizer: 'Mock Organizer ${random.nextInt(10) + 1}',
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
          phone: '+1 (415) 555-${1000 + random.nextInt(9000)}',
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
