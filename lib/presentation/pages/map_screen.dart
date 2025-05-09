import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../config/app_config.dart';
import '../../domain/entities/place.dart';
import '../../domain/entities/event.dart';
import '../blocs/places_bloc/places_bloc.dart';
import '../blocs/event_bloc/event_bloc.dart';
import '../blocs/event_bloc/event_state.dart';
import '../blocs/location_bloc/location_bloc.dart';

class MapScreen extends StatefulWidget {
  final bool showEvents;

  const MapScreen({super.key, this.showEvents = false});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  bool _isMapCreated = false;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  void _initializeLocation() {
    context.read<LocationBloc>()
      ..add(RequestLocationPermission())
      ..add(GetCurrentLocation())
      ..add(StartLocationTracking());
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
    setState(() {
      _isMapCreated = true;
    });

    // Set map style
    final mapStyle = await DefaultAssetBundle.of(context)
        .loadString('assets/map_styles/dark.json');
    controller.setMapStyle(mapStyle);
  }

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
        if (state is EventLoaded) {
          _updateEventMarkers(state.events);
        }
      },
      builder: (context, state) {
        if (state is EventLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return _buildMap();
      },
    );
  }

  Widget _buildMap() {
    return BlocBuilder<LocationBloc, LocationState>(
      builder: (context, state) {
        if (state is LocationLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is LocationLoaded) {
          return Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    state.position.latitude,
                    state.position.longitude,
                  ),
                  zoom: AppConfig.defaultMapZoom,
                ),
                onMapCreated: _onMapCreated,
                markers: _markers,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                zoomControlsEnabled: true,
                mapToolbarEnabled: false,
                compassEnabled: true,
                mapType: MapType.normal,
              ),
              if (!_isMapCreated)
                const Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          );
        } else if (state is LocationError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.location_off,
                  size: 48,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => _initializeLocation(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  void _updatePlacesMarkers(List<Place> places) {
    if (!mounted) return;
    setState(() {
      _markers = places.map((place) {
        return Marker(
          markerId: MarkerId(place.id),
          position: LatLng(place.latitude, place.longitude),
          infoWindow: InfoWindow(
            title: place.name,
            snippet: place.address,
          ),
          onTap: () {
            // TODO: Show place details
          },
        );
      }).toSet();
    });
  }

  void _updateEventMarkers(List<Event> events) {
    if (!mounted) return;
    setState(() {
      _markers = events.map((event) {
        return Marker(
          markerId: MarkerId(event.id),
          position: LatLng(event.latitude, event.longitude),
          infoWindow: InfoWindow(
            title: event.title,
            snippet: event.description,
          ),
          onTap: () {
            // TODO: Navigate to event details
          },
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
