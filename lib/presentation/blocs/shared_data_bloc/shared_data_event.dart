part of 'shared_data_bloc.dart';

abstract class SharedDataEvent extends Equatable {
  const SharedDataEvent();

  @override
  List<Object?> get props => [];
}

class SetSelectedPlace extends SharedDataEvent {
  final Place place;

  const SetSelectedPlace(this.place);

  @override
  List<Object?> get props => [place];
}

class SetSelectedEvent extends SharedDataEvent {
  final Event event;

  const SetSelectedEvent(this.event);

  @override
  List<Object?> get props => [event];
}

class SetSelectedCategory extends SharedDataEvent {
  final String category;

  const SetSelectedCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class UpdateBookmarkedItems extends SharedDataEvent {
  final String itemId;
  final bool isSaving;

  const UpdateBookmarkedItems({
    required this.itemId,
    required this.isSaving,
  });

  @override
  List<Object?> get props => [itemId, isSaving];
}

class UpdateSearchQuery extends SharedDataEvent {
  final String query;

  const UpdateSearchQuery(this.query);

  @override
  List<Object?> get props => [query];
}

class UpdateItemsList extends SharedDataEvent {
  final List<Place> places;
  final List<Event> events;

  const UpdateItemsList({
    required this.places,
    required this.events,
  });

  @override
  List<Object?> get props => [places, events];
}

class SyncMapLocation extends SharedDataEvent {
  final double mapZoom;
  final LatLng mapCenter;

  const SyncMapLocation({
    required this.mapCenter,
    required this.mapZoom,
  });

  @override
  List<Object?> get props => [mapCenter, mapZoom];
}
