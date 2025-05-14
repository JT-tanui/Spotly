import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';

import 'location_event.dart';
import 'location_state.dart';

// Simplified LocationBloc that doesn't rely on external services
class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc() : super(LocationInitial()) {
    on<RequestLocationPermission>(_onRequestLocationPermission);
    on<GetCurrentLocation>(_onGetCurrentLocation);
    on<StartLocationTracking>(_onStartLocationTracking);
    on<StopLocationTracking>(_onStopLocationTracking);
    on<SetManualLocation>(_onSetManualLocation);
  }

  Future<void> _onRequestLocationPermission(
    RequestLocationPermission event,
    Emitter<LocationState> emit,
  ) async {
    emit(LocationLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      emit(LocationPermissionGranted());
    } catch (e) {
      debugPrint('Error requesting location permission: $e');
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
      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(const LocationError(message: 'Location permissions are denied'));
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        emit(const LocationError(
            message:
                'Location permissions are permanently denied, we cannot request permissions.'));
        return;
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition();

      // In a real app, you might want to reverse geocode the position to get the address
      String address = await _getAddressFromCoordinates(
          position.latitude, position.longitude);

      emit(LocationLoaded(position: position, address: address));
    } catch (e) {
      debugPrint('Error getting current location: $e');

      // Fallback to Nairobi location
      final position = Position(
        latitude: -1.286389,
        longitude: 36.817223,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        altitudeAccuracy: 0,
        headingAccuracy: 0,
      );

      emit(LocationLoaded(position: position, address: 'Nairobi, Kenya'));
    }
  }

  // Helper method to get address from coordinates (simplified for demo)
  Future<String> _getAddressFromCoordinates(
      double latitude, double longitude) async {
    // In a real app, you would use a geocoding service
    // For now, let's return a Kenyan location based on proximity

    // Nairobi area
    if ((latitude > -1.4 && latitude < -1.0) &&
        (longitude > 36.7 && longitude < 37.0)) {
      return 'Nairobi, Kenya';
    }

    // Mombasa area
    if ((latitude > -4.1 && latitude < -3.9) &&
        (longitude > 39.6 && longitude < 39.8)) {
      return 'Mombasa, Kenya';
    }

    // Default to Nairobi
    return 'Nairobi, Kenya';
  }

  Future<void> _onStartLocationTracking(
    StartLocationTracking event,
    Emitter<LocationState> emit,
  ) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      // Use Nairobi coordinates for default
      final position = Position(
        latitude: -1.286389,
        longitude: 36.817223,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        altitudeAccuracy: 0,
        headingAccuracy: 0,
      );

      emit(LocationLoaded(position: position, address: 'Nairobi, Kenya'));
    } catch (e) {
      debugPrint('Error starting location tracking: $e');
      emit(LocationError(message: 'Failed to start location tracking: $e'));
    }
  }

  Future<void> _onStopLocationTracking(
    StopLocationTracking event,
    Emitter<LocationState> emit,
  ) async {
    // No-op in this simplified implementation
  }

  Future<void> _onSetManualLocation(
    SetManualLocation event,
    Emitter<LocationState> emit,
  ) async {
    emit(LocationLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final position = Position(
        latitude: event.latitude,
        longitude: event.longitude,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        altitudeAccuracy: 0,
        headingAccuracy: 0,
      );

      emit(LocationLoaded(position: position, address: event.address));
    } catch (e) {
      debugPrint('Error setting manual location: $e');
      emit(const LocationError(message: 'Failed to set manual location'));
    }
  }
}
