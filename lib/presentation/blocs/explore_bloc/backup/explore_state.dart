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
  final String? selectedCategory;
  final String? errorMessage;

  const ExploreLoaded({
    required this.recommendedEvents,
    required this.trendingEvents,
    required this.friendsEvents,
    required this.nearbyEvents,
    required this.popularVenues,
    this.selectedCategory,
    this.errorMessage,
  });

  ExploreLoaded copyWith({
    List<Event>? recommendedEvents,
    List<Event>? trendingEvents,
    List<Event>? friendsEvents,
    List<Event>? nearbyEvents,
    List<Venue>? popularVenues,
    String? selectedCategory,
    String? errorMessage,
  }) {
    return ExploreLoaded(
      recommendedEvents: recommendedEvents ?? this.recommendedEvents,
      trendingEvents: trendingEvents ?? this.trendingEvents,
      friendsEvents: friendsEvents ?? this.friendsEvents,
      nearbyEvents: nearbyEvents ?? this.nearbyEvents,
      popularVenues: popularVenues ?? this.popularVenues,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        recommendedEvents,
        trendingEvents,
        friendsEvents,
        nearbyEvents,
        popularVenues,
        selectedCategory,
        errorMessage,
      ];
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
