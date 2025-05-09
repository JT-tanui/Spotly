import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../config/app_config.dart';
import '../../domain/entities/place.dart';
import '../../domain/entities/event.dart';
import '../blocs/places_bloc/places_bloc.dart';
import '../blocs/event_bloc/event_bloc.dart';

class MapScreen extends StatefulWidget {
  final bool showEvents;

  const MapScreen({super.key, this.showEvents = false});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    return widget.showEvents ? _buildEventsMap() : _buildPlacesMap();
  }

  Widget _buildPlacesMap() {
    return BlocConsumer<PlacesBloc, PlacesState>(
      listener: (context, state) {
        if (state is PlacesLoaded) {
          _updatePlacesMarkers(state.places);
        }
      },
      builder: (context, state) {
        if (state is PlacesLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return _buildMap();
      },
    );
  }

  Widget _buildEventsMap() {
    return BlocConsumer<EventBloc, EventState>(
      listener: (context, state) {
        if (state is EventsLoaded) {
          _updateEventMarkers(state.events);
        }
      },
      builder: (context, state) {
        if (state is EventsLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return _buildMap();
      },
    );
  }

  Widget _buildMap() {
    return GoogleMap(
      initialCameraPosition: const CameraPosition(
        target: LatLng(0, 0), // Will be updated when location is obtained
        zoom: AppConfig.defaultMapZoom,
      ),
      onMapCreated: (controller) {
        _mapController = controller;
      },
      markers: _markers,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      zoomControlsEnabled: true,
      mapToolbarEnabled: false,
    );
  }

  void _updatePlacesMarkers(List<Place> places) {
    setState(() {
      _markers = places.map((place) {
        return Marker(
          markerId: MarkerId(place.id),
          position: LatLng(place.latitude, place.longitude),
          infoWindow: InfoWindow(
            title: place.name,
            snippet: place.address,
          ),
        );
      }).toSet();
    });
  }

  void _updateEventMarkers(List<Event> events) {
    setState(() {
      _markers = events.map((event) {
        return Marker(
          markerId: MarkerId(event.id),
          position: LatLng(event.latitude, event.longitude),
          infoWindow: InfoWindow(
            title: event.title,
            snippet: event.description,
          ),
        );
      }).toSet();
    });
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
