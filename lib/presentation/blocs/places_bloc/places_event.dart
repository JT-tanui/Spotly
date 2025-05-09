part of 'places_bloc.dart';

abstract class PlacesEvent extends Equatable {
  const PlacesEvent();

  @override
  List<Object> get props => [];
}

class LoadNearbyPlaces extends PlacesEvent {
  final double latitude;
  final double longitude;
  final double radius;

  const LoadNearbyPlaces({
    required this.latitude,
    required this.longitude,
    required this.radius,
  });

  @override
  List<Object> get props => [latitude, longitude, radius];
}
