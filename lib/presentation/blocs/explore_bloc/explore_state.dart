import 'package:equatable/equatable.dart';
import '../../../domain/entities/event.dart';
import '../../../domain/entities/venue.dart';

abstract class ExploreState extends Equatable {
  const ExploreState();

  @override
  List<Object?> get props => [];
}

class ExploreInitial extends ExploreState {}

class ExploreLoading extends ExploreState {}

class ExploreLoaded extends ExploreState {
  final List<Event> recommendedEvents;
  final List<Event> trendingEvents;
  final List<Event> friendsEvents;
  final List<Event> nearbyEvents;
  final List<Venue> popularVenues;
  final List<Event> searchResults;
  final List<Event> hotEvents;
  final String? selectedCategory;
  final String? errorMessage;
  final String? searchQuery;
  final String? loadMoreError;
  final bool isRefreshing;
  final bool isSearching;
  final bool isLoadingMore;
  final bool isLoadingTrending;
  final bool isLoadingHot;
  final bool hasMoreData;
  final int page;

  const ExploreLoaded({
    required this.recommendedEvents,
    required this.trendingEvents,
    required this.friendsEvents,
    required this.nearbyEvents,
    required this.popularVenues,
    this.searchResults = const [],
    this.hotEvents = const [],
    this.selectedCategory,
    this.errorMessage,
    this.searchQuery,
    this.loadMoreError,
    this.isRefreshing = false,
    this.isSearching = false,
    this.isLoadingMore = false,
    this.isLoadingTrending = false,
    this.isLoadingHot = false,
    this.hasMoreData = false,
    this.page = 1,
  });

  ExploreLoaded copyWith({
    List<Event>? recommendedEvents,
    List<Event>? trendingEvents,
    List<Event>? friendsEvents,
    List<Event>? nearbyEvents,
    List<Venue>? popularVenues,
    List<Event>? searchResults,
    List<Event>? hotEvents,
    String? selectedCategory,
    String? errorMessage,
    String? searchQuery,
    String? loadMoreError,
    bool? isRefreshing,
    bool? isSearching,
    bool? isLoadingMore,
    bool? isLoadingTrending,
    bool? isLoadingHot,
    bool? hasMoreData,
    int? page,
  }) {
    return ExploreLoaded(
      recommendedEvents: recommendedEvents ?? this.recommendedEvents,
      trendingEvents: trendingEvents ?? this.trendingEvents,
      friendsEvents: friendsEvents ?? this.friendsEvents,
      nearbyEvents: nearbyEvents ?? this.nearbyEvents,
      popularVenues: popularVenues ?? this.popularVenues,
      searchResults: searchResults ?? this.searchResults,
      hotEvents: hotEvents ?? this.hotEvents,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      errorMessage: errorMessage ?? this.errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
      loadMoreError: loadMoreError ?? this.loadMoreError,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isSearching: isSearching ?? this.isSearching,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isLoadingTrending: isLoadingTrending ?? this.isLoadingTrending,
      isLoadingHot: isLoadingHot ?? this.isLoadingHot,
      hasMoreData: hasMoreData ?? this.hasMoreData,
      page: page ?? this.page,
    );
  }

  @override
  List<Object?> get props => [
        recommendedEvents,
        trendingEvents,
        friendsEvents,
        nearbyEvents,
        popularVenues,
        searchResults,
        hotEvents,
        selectedCategory,
        errorMessage,
        searchQuery,
        loadMoreError,
        isRefreshing,
        isSearching,
        isLoadingMore,
        isLoadingTrending,
        isLoadingHot,
        hasMoreData,
        page,
      ];

  // Getter to get all events combined
  List<Event> get allEvents {
    final Set<String> seenIds = {};
    final List<Event> result = [];

    // Helper to add events avoiding duplicates
    void addEvents(List<Event> events) {
      for (final event in events) {
        if (!seenIds.contains(event.id)) {
          result.add(event);
          seenIds.add(event.id);
        }
      }
    }

    // Add events from all lists, avoiding duplicates
    addEvents(recommendedEvents);
    addEvents(trendingEvents);
    addEvents(friendsEvents);
    addEvents(nearbyEvents);
    addEvents(searchResults);
    addEvents(hotEvents);

    return result;
  }
}

class ExploreError extends ExploreState {
  final String message;
  final bool canRetry;

  const ExploreError({
    required this.message,
    this.canRetry = true,
  });

  @override
  List<Object?> get props => [message, canRetry];
}
