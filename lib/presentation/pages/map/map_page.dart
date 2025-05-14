import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../domain/entities/place.dart';
import '../../../domain/entities/event.dart';
import '../../blocs/places_bloc/places_bloc.dart';
import '../../blocs/event_bloc/event_bloc.dart';
import '../../blocs/event_bloc/event_event.dart';
import '../../blocs/event_bloc/event_state.dart';
import '../../blocs/location_bloc/location_bloc.dart';
import '../../blocs/location_bloc/location_event.dart';
import '../../blocs/location_bloc/location_state.dart';
import '../../blocs/shared_data_bloc/shared_data_bloc.dart';
import '../../widgets/unified_detail_bottom_sheet.dart';
import 'widgets/map_filter_bottom_sheet.dart';
import 'widgets/create_event_sheet.dart';
import '../../widgets/common/loading_indicator.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with AutomaticKeepAliveClientMixin {
  final Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};
  LatLng _currentPosition =
      const LatLng(-1.2921, 36.8219); // Default to Nairobi
  bool _isLoading = true;
  double _currentZoom = 14.0;
  String _locationName = "Loading...";
  bool _isFilterModalOpen = false;
  String _selectedCategory = "All";
  List<Event> _events = [];

  // Filter categories
  final List<String> _categories = [
    "All",
    "Music",
    "Food",
    "Art",
    "Sports",
    "Nightlife",
    "Tech",
  ];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Load events as soon as the widget is mounted
    _loadNearbyEvents();
  }

  Future<void> _getCurrentLocation() async {
    try {
      // First check location permission
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          setState(() {
            _isLoading = false;
            _locationName = "Location permission denied";
          });
          return;
        }
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });

      // Update location in LocationBloc
      context.read<LocationBloc>().add(SetManualLocation(
            address: "Current Location",
            latitude: position.latitude,
            longitude: position.longitude,
          ));

      // Center map on current position
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: _currentPosition,
          zoom: _currentZoom,
        ),
      ));

      // Fetch nearby events
      _loadNearbyEvents();
    } catch (e) {
      setState(() {
        _isLoading = false;
        _locationName = "Could not get location";
      });
    }
  }

  Future<void> _loadNearbyEvents() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Use EventBloc to get nearby events
      context.read<EventBloc>().add(GetNearbyEventsEvent(
            latitude: _currentPosition.latitude,
            longitude: _currentPosition.longitude,
            radius: 10.0,
          ));

      // Wait for the events to load
      await Future.delayed(const Duration(milliseconds: 500));

      // Check the state to get events
      final state = context.read<EventBloc>().state;
      if (state is EventLoaded) {
        setState(() {
          _events = state.events;
          _updateMarkers();
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _updateMarkers() {
    // Start with current location marker
    final Set<Marker> markers = {
      Marker(
        markerId: const MarkerId("current_location"),
        position: _currentPosition,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: const InfoWindow(
          title: "Your Location",
        ),
      ),
    };

    // Add event markers
    for (final event in _getFilteredEvents()) {
      markers.add(
        Marker(
          markerId: MarkerId(event.id),
          position: LatLng(event.latitude, event.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
          infoWindow: InfoWindow(
            title: event.title,
            snippet: event.description.length > 50
                ? "${event.description.substring(0, 50)}..."
                : event.description,
            onTap: () {
              _showEventDetails(event);
            },
          ),
          onTap: () {
            // This makes the info window appear
          },
        ),
      );
    }

    setState(() {
      _markers = markers;
    });
  }

  List<Event> _getFilteredEvents() {
    if (_selectedCategory == "All") {
      return _events;
    }

    return _events
        .where((event) => event.categories.any((category) =>
            category.toLowerCase() == _selectedCategory.toLowerCase()))
        .toList();
  }

  void _showEventDetails(Event event) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                // Handle bar
                Container(
                  margin: const EdgeInsets.only(top: 8, bottom: 16),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),

                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      // Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          event.imageUrl,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            height: 200,
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(Icons.image,
                                  size: 64, color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Title
                      Text(
                        event.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Categories
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: event.categories
                            .map((category) => Chip(
                                  label: Text(category),
                                  backgroundColor: Colors.deepPurple[50],
                                  labelStyle:
                                      TextStyle(color: Colors.deepPurple[700]),
                                ))
                            .toList(),
                      ),
                      const SizedBox(height: 16),

                      // Details section
                      _buildInfoRow(
                          Icons.calendar_today, _formatDate(event.startDate)),
                      _buildInfoRow(Icons.access_time,
                          _formatTime(event.startDate, event.endDate)),
                      _buildInfoRow(Icons.location_on, event.location),
                      _buildInfoRow(
                          Icons.people, "${event.attendees} attending"),
                      _buildInfoRow(Icons.attach_money,
                          "KSh ${event.price.toStringAsFixed(0)}"),
                      const SizedBox(height: 16),

                      // Description
                      const Text(
                        "About this event",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        event.description,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[800],
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(
                          height: 100), // Extra space for the bottom button
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.deepPurple),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];

    final dayOfWeek = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday"
    ];

    return "${dayOfWeek[date.weekday - 1]}, ${date.day} ${months[date.month - 1]} ${date.year}";
  }

  String _formatTime(DateTime start, DateTime end) {
    String formatTimeOfDay(DateTime date) {
      final hour = date.hour > 12 ? date.hour - 12 : date.hour;
      final period = date.hour >= 12 ? "PM" : "AM";
      return "$hour:${date.minute.toString().padLeft(2, '0')} $period";
    }

    return "${formatTimeOfDay(start)} - ${formatTimeOfDay(end)}";
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Filter Events",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Category filters
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _categories.map((category) {
                    return FilterChip(
                      label: Text(category),
                      selected: _selectedCategory == category,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: 20),

                // Apply button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Apply filters
                      this.setState(() {
                        _updateMarkers();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Apply Filters"),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required by AutomaticKeepAliveClientMixin

    return Scaffold(
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: _currentPosition,
              zoom: _currentZoom,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            compassEnabled: true,
            zoomControlsEnabled: false,
            onCameraMove: (position) {
              _currentZoom = position.zoom;
            },
            onCameraIdle: () {
              // Could load more events when camera stops moving
            },
          ),

          // Search bar
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            right: 16,
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Search events',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                      onTap: () {
                        // Navigate to search page
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.tune),
                    onPressed: _showFilterModal,
                  ),
                ],
              ),
            ),
          ),

          // My location button
          Positioned(
            right: 16,
            bottom: 120,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.white,
              onPressed: _getCurrentLocation,
              child: const Icon(
                Icons.my_location,
                color: Colors.black87,
              ),
            ),
          ),

          // Loading indicator
          if (_isLoading)
            const Center(
              child: LoadingIndicator(),
            ),
        ],
      ),

      // Event count at the bottom
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: () {
              // Navigate to list view of events
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              "View ${_getFilteredEvents().length} Events in List",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
