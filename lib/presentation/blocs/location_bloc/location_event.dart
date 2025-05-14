import 'package:equatable/equatable.dart';

abstract class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object> get props => [];
}

class RequestLocationPermission extends LocationEvent {}

class GetCurrentLocation extends LocationEvent {}

class StartLocationTracking extends LocationEvent {}

class StopLocationTracking extends LocationEvent {}

class SetManualLocation extends LocationEvent {
  final String address;
  final double latitude;
  final double longitude;

  const SetManualLocation({
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object> get props => [address, latitude, longitude];
}
