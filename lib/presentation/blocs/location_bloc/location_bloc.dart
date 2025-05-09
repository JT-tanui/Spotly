import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import '../../../core/services/location_service.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final LocationService locationService;

  LocationBloc({required this.locationService}) : super(LocationInitial()) {
    on<RequestLocationPermission>(_onRequestLocationPermission);
    on<GetCurrentLocation>(_onGetCurrentLocation);
    on<StartLocationTracking>(_onStartLocationTracking);
    on<StopLocationTracking>(_onStopLocationTracking);
  }

  Future<void> _onRequestLocationPermission(
    RequestLocationPermission event,
    Emitter<LocationState> emit,
  ) async {
    emit(LocationLoading());
    try {
      final hasPermission = await locationService.requestLocationPermission();
      if (hasPermission) {
        emit(LocationPermissionGranted());
      } else {
        emit(const LocationError(message: 'Location permission denied'));
      }
    } catch (e) {
      emit(const LocationError(
          message: 'Failed to request location permission'));
    }
  }

  Future<void> _onGetCurrentLocation(
    GetCurrentLocation event,
    Emitter<LocationState> emit,
  ) async {
    emit(LocationLoading());
    try {
      final position = await locationService.getCurrentLocation();
      emit(LocationLoaded(position: position));
    } catch (e) {
      emit(const LocationError(message: 'Failed to get current location'));
    }
  }

  Future<void> _onStartLocationTracking(
    StartLocationTracking event,
    Emitter<LocationState> emit,
  ) async {
    try {
      await emit.forEach<Position>(
        locationService.getLocationStream(),
        onData: (position) => LocationLoaded(position: position),
        onError: (_, __) => const LocationError(
          message: 'Failed to track location',
        ),
      );
    } catch (e) {
      emit(const LocationError(message: 'Failed to start location tracking'));
    }
  }

  Future<void> _onStopLocationTracking(
    StopLocationTracking event,
    Emitter<LocationState> emit,
  ) async {
    // No need to implement as the stream will be automatically closed
    // when the bloc is closed
  }
}
