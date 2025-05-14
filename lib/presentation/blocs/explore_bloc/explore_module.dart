// This file exports all the necessary components from explore_bloc, explore_event, and explore_state
// to avoid import conflicts and make imports cleaner

// Export the main bloc class and state classes
export 'explore_bloc.dart'
    show ExploreBloc, ExploreLoaded, ExploreLoading, ExploreError, ExploreState;

// Export the state classes
export 'explore_state.dart';

// Re-export event classes with aliases to avoid conflicts
import 'explore_event.dart' as events;
export 'explore_event.dart'
    hide ExploreEvent; // Export everything except the base class

// Re-export the ExploreEvent base class
export 'explore_event.dart' show ExploreEvent;

// Create type aliases for all events to ensure they match the ExploreEvent type
typedef LoadExploreData = events.LoadExploreData;
typedef RefreshExploreData = events.RefreshExploreData;
typedef LoadMoreExploreData = events.LoadMoreExploreData;
typedef FilterByCategory = events.FilterByCategory;
typedef SearchPlacesAndEvents = events.SearchPlacesAndEvents;
typedef LoadTrendingNearby = events.LoadTrendingNearby;
typedef LoadWhatsHotNearYou = events.LoadWhatsHotNearYou;
