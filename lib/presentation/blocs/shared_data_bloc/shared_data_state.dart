part of 'shared_data_bloc.dart';

class SharedDataState extends Equatable {
  final Place? selectedPlace;
  final Event? selectedEvent;
  final String? selectedCategory;
  final List<String> bookmarkedItemIds;
  final String? searchQuery;
  final List<Place> places;
  final List<Event> events;
  final LatLng? mapCenter;
  final double? mapZoom;

  const SharedDataState({
    this.selectedPlace,
    this.selectedEvent,
    this.selectedCategory,
    this.bookmarkedItemIds = const [],
    this.searchQuery,
    this.places = const [],
    this.events = const [],
    this.mapCenter,
    this.mapZoom,
  });

  SharedDataState copyWith({
    Place? selectedPlace,
    Event? selectedEvent,
    String? selectedCategory,
    List<String>? bookmarkedItemIds,
    String? searchQuery,
    List<Place>? places,
    List<Event>? events,
    LatLng? mapCenter,
    double? mapZoom,
  }) {
    return SharedDataState(
      selectedPlace: selectedPlace ?? this.selectedPlace,
      selectedEvent: selectedEvent ?? this.selectedEvent,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      bookmarkedItemIds: bookmarkedItemIds ?? this.bookmarkedItemIds,
      searchQuery: searchQuery ?? this.searchQuery,
      places: places ?? this.places,
      events: events ?? this.events,
      mapCenter: mapCenter ?? this.mapCenter,
      mapZoom: mapZoom ?? this.mapZoom,
    );
  }

  @override
  List<Object?> get props => [
        selectedPlace,
        selectedEvent,
        selectedCategory,
        bookmarkedItemIds,
        searchQuery,
        places,
        events,
        mapCenter,
        mapZoom,
      ];
}
