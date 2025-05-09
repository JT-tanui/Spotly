part of 'places_bloc.dart';

abstract class PlacesState extends Equatable {
  const PlacesState();

  @override
  List<Object> get props => [];
}

class PlacesInitial extends PlacesState {}

class PlacesLoading extends PlacesState {}

class PlacesLoaded extends PlacesState {
  final List<Place> places;

  const PlacesLoaded({required this.places});

  @override
  List<Object> get props => [places];
}

class PlacesError extends PlacesState {
  final String message;

  const PlacesError({required this.message});

  @override
  List<Object> get props => [message];
}
