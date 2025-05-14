import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../domain/entities/place.dart';
import '../../../domain/entities/event.dart';

part 'shared_data_event.dart';
part 'shared_data_state.dart';

/// A BLoC that manages shared data between the Explore page and the Map page.
/// Both pages will listen to this BLoC to ensure consistent data across views.
class SharedDataBloc extends Bloc<SharedDataEvent, SharedDataState> {
  SharedDataBloc() : super(const SharedDataState()) {
    on<SetSelectedPlace>(_onSetSelectedPlace);
    on<SetSelectedEvent>(_onSetSelectedEvent);
    on<SetSelectedCategory>(_onSetSelectedCategory);
    on<UpdateBookmarkedItems>(_onUpdateBookmarkedItems);
    on<UpdateSearchQuery>(_onUpdateSearchQuery);
    on<UpdateItemsList>(_onUpdateItemsList);
    on<SyncMapLocation>(_onSyncMapLocation);
  }

  void _onSetSelectedPlace(
      SetSelectedPlace event, Emitter<SharedDataState> emit) {
    emit(state.copyWith(
      selectedPlace: event.place,
      selectedEvent: null, // Clear selected event when selecting a place
    ));
  }

  void _onSetSelectedEvent(
      SetSelectedEvent event, Emitter<SharedDataState> emit) {
    emit(state.copyWith(
      selectedEvent: event.event,
      selectedPlace: null, // Clear selected place when selecting an event
    ));
  }

  void _onSetSelectedCategory(
      SetSelectedCategory event, Emitter<SharedDataState> emit) {
    emit(state.copyWith(
      selectedCategory: event.category,
    ));
  }

  void _onUpdateBookmarkedItems(
      UpdateBookmarkedItems event, Emitter<SharedDataState> emit) {
    final List<String> updatedBookmarks;

    if (event.isSaving) {
      // Add to bookmarks if not already bookmarked
      if (!state.bookmarkedItemIds.contains(event.itemId)) {
        updatedBookmarks = List.from(state.bookmarkedItemIds)
          ..add(event.itemId);
      } else {
        updatedBookmarks = state.bookmarkedItemIds;
      }
    } else {
      // Remove from bookmarks
      updatedBookmarks = List.from(state.bookmarkedItemIds)
        ..remove(event.itemId);
    }

    emit(state.copyWith(
      bookmarkedItemIds: updatedBookmarks,
    ));
  }

  void _onUpdateSearchQuery(
      UpdateSearchQuery event, Emitter<SharedDataState> emit) {
    emit(state.copyWith(
      searchQuery: event.query,
    ));
  }

  void _onUpdateItemsList(
      UpdateItemsList event, Emitter<SharedDataState> emit) {
    emit(state.copyWith(
      places: event.places,
      events: event.events,
    ));
  }

  void _onSyncMapLocation(
      SyncMapLocation event, Emitter<SharedDataState> emit) {
    emit(state.copyWith(
      mapCenter: event.mapCenter,
      mapZoom: event.mapZoom,
    ));
  }
}
