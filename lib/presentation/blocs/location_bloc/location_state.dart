part of 'location_bloc.dart';

abstract class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object> get props => [];
}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationPermissionGranted extends LocationState {}

class LocationLoaded extends LocationState {
  final Position position;

  const LocationLoaded({required this.position});

  @override
  List<Object> get props => [position];
}

class LocationError extends LocationState {
  final String message;

  const LocationError({required this.message});

  @override
  List<Object> get props => [message];
}
