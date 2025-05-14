import 'package:equatable/equatable.dart';
import '../../../domain/entities/event.dart';

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

class LoadMoreExploreData extends ExploreEvent {
  const LoadMoreExploreData();
}

class FilterByCategory extends ExploreEvent {
  final String category;

  const FilterByCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class SearchPlacesAndEvents extends ExploreEvent {
  final String query;
  final double? latitude;
  final double? longitude;

  const SearchPlacesAndEvents({
    required this.query,
    this.latitude,
    this.longitude,
  });

  @override
  List<Object?> get props => [query, latitude, longitude];
}

class LoadTrendingNearby extends ExploreEvent {
  final double latitude;
  final double longitude;
  final double radiusInKm;

  const LoadTrendingNearby({
    required this.latitude,
    required this.longitude,
    this.radiusInKm = 10.0,
  });

  @override
  List<Object?> get props => [latitude, longitude, radiusInKm];
}

class LoadWhatsHotNearYou extends ExploreEvent {
  final double? latitude;
  final double? longitude;

  const LoadWhatsHotNearYou({
    this.latitude,
    this.longitude,
  });

  @override
  List<Object?> get props => [latitude, longitude];
}

// New event to update the explore page with data from the map
class UpdateExploreWithMapData extends ExploreEvent {
  final List<Event> events;
  final List<dynamic> places;

  const UpdateExploreWithMapData({
    required this.events,
    required this.places,
  });

  @override
  List<Object?> get props => [events, places];
}
