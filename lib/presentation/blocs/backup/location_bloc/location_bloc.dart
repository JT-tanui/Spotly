import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import '../../../core/services/location_service.dart';
import 'dart:async';

import 'location_event.dart';
import 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final LocationService locationService;
  StreamSubscription<Position>? _positionSubscription;

  LocationBloc({required this.locationService}) : super(LocationInitial()) {
    on<RequestLocationPermission>(_onRequestLocationPermission);
    on<GetCurrentLocation>(_onGetCurrentLocation);
    on<StartLocationTracking>(_onStartLocationTracking);
    on<StopLocationTracking>(_onStopLocationTracking);
  }

  @override
  Future<void> close() {
    _positionSubscription?.cancel();
    return super.close();
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

      // Get address from coordinates
      String? address;
      try {
        address = await locationService.getAddressFromCoordinates(
          position.latitude,
          position.longitude,
        );
      } catch (e) {
        // Just log the error and continue without address
        print('Failed to get address: $e');
      }

      emit(LocationLoaded(position: position, address: address));
    } catch (e) {
      emit(const LocationError(message: 'Failed to get current location'));
    }
  }

  Future<void> _onStartLocationTracking(
    StartLocationTracking event,
    Emitter<LocationState> emit,
  ) async {
    try {
      // Cancel any existing subscription
      await _positionSubscription?.cancel();

      // Start a new subscription to the position stream
      _positionSubscription = locationService.getLocationStream().listen(
        (position) async {
          // Get address from coordinates
          String? address;
          try {
            address = await locationService.getAddressFromCoordinates(
              position.latitude,
              position.longitude,
            );
          } catch (e) {
            print('Failed to get address during tracking: $e');
          }

          emit(LocationLoaded(position: position, address: address));
        },
        onError: (error) {
          emit(LocationError(message: 'Location tracking error: $error'));
        },
      );
    } catch (e) {
      emit(LocationError(message: 'Failed to start location tracking: $e'));
    }
  }

  Future<void> _onStopLocationTracking(
    StopLocationTracking event,
    Emitter<LocationState> emit,
  ) async {
    await _positionSubscription?.cancel();
    _positionSubscription = null;
  }
}
