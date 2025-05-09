part of 'location_bloc.dart';

abstract class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object> get props => [];
}

class RequestLocationPermission extends LocationEvent {}

class GetCurrentLocation extends LocationEvent {}

class StartLocationTracking extends LocationEvent {}

class StopLocationTracking extends LocationEvent {}
