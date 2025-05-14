import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spotly/domain/entities/event.dart';
import 'package:spotly/domain/usecases/get_featured_events.dart';
import 'package:spotly/domain/usecases/get_upcoming_events.dart';
import 'package:spotly/presentation/blocs/explore_bloc/explore_module.dart';
import 'package:spotly/presentation/blocs/location_bloc/location_bloc.dart';
import 'package:spotly/presentation/blocs/location_bloc/location_event.dart';
import 'package:spotly/presentation/blocs/location_bloc/location_state.dart';
import 'package:spotly/presentation/blocs/shared_data_bloc/shared_data_bloc.dart';
import 'package:spotly/presentation/pages/explore/search_page.dart';
import 'package:spotly/presentation/widgets/explore/category_chips.dart';
import 'package:spotly/presentation/widgets/explore/event_card.dart';
import 'package:spotly/presentation/widgets/explore/horizontal_list_card.dart';
import 'package:spotly/presentation/widgets/explore/location_selector.dart';
import 'package:spotly/presentation/widgets/explore/location_badge.dart';
import 'package:spotly/presentation/widgets/explore/section_header.dart';
import 'package:spotly/presentation/widgets/common/pull_to_refresh.dart';
import 'package:spotly/presentation/widgets/common/loading_indicator.dart';
import 'package:spotly/presentation/widgets/explore/search_bar.dart';
import 'package:geolocator/geolocator.dart';

// Add this custom explore event for nearby events
class GetNearbyExploreEvents extends ExploreEvent {
  final double latitude;
  final double longitude;
  final double radius;

  const GetNearbyExploreEvents({
    required this.latitude,
    required this.longitude,
    this.radius = 10.0,
  });

  @override
  List<Object?> get props => [latitude, longitude, radius];
}

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  // Animation controller for loading effects
  late AnimationController _animationController;
  late final ScrollController _scrollController;
  bool _isMapExpanded = false;
  final List<String> _filters = [
    '❤️ For You',
    '🎫 Events',
    '🍽️ Restaurants',
    '🌆 Hidden Gems',
    '👥 Social Meetups',
    '🎭 Nightlife',
    '🏙️ Attractions',
  ];
  String _selectedFilter = '❤️ For You';
  bool _showBackToTopButton = false;
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  String _userLocation = 'Loading location...';
  LatLng _currentPosition =
      const LatLng(-1.2921, 36.8219); // Default to Nairobi
  bool _locationPermissionGranted = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Request location and load explore data
    _requestLocationPermission();

    // Initialize BLoC here instead of initState to ensure context is available
    final exploreState = context.read<ExploreBloc>().state;
    if (exploreState is ExploreInitial) {
      context.read<ExploreBloc>().add(const LoadExploreData());
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    // Initialize scroll controller for infinite scrolling and "back to top" button
    _scrollController.addListener(_scrollListener);
  }

  // Request location permission and get current location
  Future<void> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      _locationPermissionGranted = true;
      _getCurrentLocation();
    } else {
      setState(() {
        _userLocation = 'Location permission denied';
      });
    }
  }

  // Get current location
  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Update position and trigger reverse geocoding
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });

      // Notify location BLoC about position change
      context.read<LocationBloc>().add(SetManualLocation(
            address: "Current Location",
            latitude: position.latitude,
            longitude: position.longitude,
          ));

      // Update map if controller is available
      _updateMapLocation();

      // Update user location string from current position
      final locationState = context.read<LocationBloc>().state;
      if (locationState is LocationLoaded) {
        setState(() {
          _userLocation = locationState.address ?? 'Current Location';
        });
      }

      // Fetch nearby events
      _fetchNearbyEventsFromFirebase(_currentPosition);
    } catch (e) {
      setState(() {
        _userLocation = 'Could not get location';
      });
    }
  }

  // Update map with current location
  void _updateMapLocation() {
    if (_mapController != null && _locationPermissionGranted) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _currentPosition,
            zoom: 14,
          ),
        ),
      );

      // Update markers
      setState(() {
        _markers = {
          Marker(
            markerId: const MarkerId('currentLocation'),
            position: _currentPosition,
            infoWindow: const InfoWindow(title: 'Your Location'),
          ),
        };
      });
    }
  }

  // Open location picker dialog
  void _openLocationPicker() async {
    final result = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Location'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.my_location),
                title: const Text('Use current location'),
                onTap: () {
                  Navigator.pop(context, 'current');
                },
              ),
              ListTile(
                leading: const Icon(Icons.location_on),
                title: const Text('Nairobi'),
                onTap: () {
                  Navigator.pop(context, 'nairobi');
                },
              ),
              ListTile(
                leading: const Icon(Icons.location_on),
                title: const Text('Nakuru'),
                onTap: () {
                  Navigator.pop(context, 'nakuru');
                },
              ),
              ListTile(
                leading: const Icon(Icons.location_on),
                title: const Text('Mombasa'),
                onTap: () {
                  Navigator.pop(context, 'mombasa');
                },
              ),
            ],
          ),
        ),
      ),
    );

    if (result != null) {
      LatLng newPosition;
      String locationName;

      switch (result) {
        case 'current':
          _getCurrentLocation();
          return;
        case 'nairobi':
          newPosition = const LatLng(-1.2921, 36.8219);
          locationName = 'Nairobi';
          break;
        case 'nakuru':
          newPosition = const LatLng(-0.3031, 36.0800);
          locationName = 'Nakuru';
          break;
        case 'mombasa':
          newPosition = const LatLng(-4.0435, 39.6682);
          locationName = 'Mombasa';
          break;
        default:
          return;
      }

      setState(() {
        _currentPosition = newPosition;
        _userLocation = locationName;
      });

      // Update map if controller is available
      _updateMapLocation();

      // Update location in the LocationBloc
      context.read<LocationBloc>().add(SetManualLocation(
            address: locationName,
            latitude: newPosition.latitude,
            longitude: newPosition.longitude,
          ));

      // Reload explore data with new location
      context.read<ExploreBloc>().add(const LoadExploreData());

      // Fetch nearby events from Firebase
      _fetchNearbyEventsFromFirebase(newPosition);
    }
  }

  // New method to fetch nearby events from Firebase
  Future<void> _fetchNearbyEventsFromFirebase(LatLng position) async {
    try {
      // Add loading state
      setState(() {
        _markers = {
          Marker(
            markerId: const MarkerId('currentLocation'),
            position: position,
            infoWindow: const InfoWindow(title: 'Your Location'),
          ),
        };
      });

      // Get nearby events using EventBloc
      context.read<ExploreBloc>().add(LoadTrendingNearby(
            latitude: position.latitude,
            longitude: position.longitude,
            radiusInKm: 10.0, // 10km radius
          ));

      // Wait for events to load
      await Future.delayed(const Duration(milliseconds: 500));

      // Listen for response and update markers
      final state = context.read<ExploreBloc>().state;
      if (state is ExploreLoaded) {
        // Add markers for each event
        final eventMarkers = state.nearbyEvents.map((event) {
          return Marker(
            markerId: MarkerId(event.id),
            position: LatLng(event.latitude, event.longitude),
            infoWindow: InfoWindow(
              title: event.title,
              snippet: event.description
                  .substring(0, math.min(50, event.description.length)),
              onTap: () {
                // Navigate to event details
                // Navigator.pushNamed(context, '/event-details', arguments: event.id);
              },
            ),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
          );
        }).toSet();

        setState(() {
          _markers = {
            ..._markers,
            ...eventMarkers,
          };
        });
      }
    } catch (e) {
      print('Error fetching nearby events: $e');
    }
  }

  void _scrollListener() {
    // Show "back to top" button when scrolled down
    if (_scrollController.offset >= 500 && !_showBackToTopButton) {
      setState(() {
        _showBackToTopButton = true;
      });
    } else if (_scrollController.offset < 500 && _showBackToTopButton) {
      setState(() {
        _showBackToTopButton = false;
      });
    }

    // Check if we reached the bottom for infinite scrolling
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Prevent multiple triggers by adding a small offset check
      final state = context.read<ExploreBloc>().state;
      if (state is ExploreLoaded && !state.isLoadingMore && state.hasMoreData) {
        context.read<ExploreBloc>().add(const LoadMoreExploreData());
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  // Method to scroll back to top
  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  // Pull events from map data in SharedDataBloc
  void _updateFromMapData() {
    final sharedState = context.read<SharedDataBloc>().state;

    // Check if there are events in the shared state
    if (sharedState.events.isNotEmpty) {
      // Simply update the explore bloc with events from map
      context.read<ExploreBloc>().add(UpdateExploreWithMapData(
            events: sharedState.events,
            places: sharedState.places,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Color system as specified in the guide
    final backgroundColor = isDark ? const Color(0xFF121212) : Colors.white;
    final surfaceColor =
        isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF9F9F9);
    final primaryAccent =
        isDark ? const Color(0xFFFF7F7F) : const Color(0xFFFF6B6B); // Coral Red
    final secondaryAccent =
        isDark ? const Color(0xFF8A80FF) : const Color(0xFF6C63FF); // Indigo
    final textPrimary =
        isDark ? const Color(0xFFF1F1F1) : const Color(0xFF212121);
    final textSecondary =
        isDark ? const Color(0xFFB5B5B5) : const Color(0xFF6B6B6B);

    return BlocBuilder<ExploreBloc, ExploreState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: backgroundColor,
          body: SafeArea(
            child: RefreshIndicator(
              color: primaryAccent,
              onRefresh: () async {
                context.read<ExploreBloc>().add(const RefreshExploreData());
                await Future.delayed(const Duration(seconds: 1));
              },
              child: CustomScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // 1. App Bar with Location and Search Icon
                  SliverAppBar(
                    backgroundColor: backgroundColor,
                    floating: true,
                    elevation: 0,
                    titleSpacing: 0,
                    toolbarHeight: 70,
                    title: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: _openLocationPicker,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: surfaceColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: primaryAccent,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        _userLocation,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: textPrimary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_drop_down,
                                      color: textSecondary,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.search,
                              color: textPrimary,
                              size: 26,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SearchPage()),
                              );
                              HapticFeedback.selectionClick();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 2. Quick Filters
                  SliverToBoxAdapter(
                    child:
                        _buildFilters(primaryAccent, surfaceColor, textPrimary),
                  ),

                  if (state is ExploreLoading)
                    SliverFillRemaining(
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(primaryAccent),
                        ),
                      ),
                    )
                  else if (state is ExploreLoaded)
                    ..._buildExploreContent(
                      state,
                      surfaceColor,
                      primaryAccent,
                      secondaryAccent,
                      textPrimary,
                      textSecondary,
                    )
                  else if (state is ExploreError)
                    SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: primaryAccent,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Oops! Something went wrong',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: textPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              state.message,
                              style: TextStyle(
                                fontSize: 14,
                                color: textSecondary,
                              ),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: () {
                                context
                                    .read<ExploreBloc>()
                                    .add(const LoadExploreData());
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryAccent,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                              ),
                              child: const Text('Try Again'),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          floatingActionButton: _showBackToTopButton
              ? FloatingActionButton(
                  mini: true,
                  backgroundColor: primaryAccent,
                  onPressed: _scrollToTop,
                  child: const Icon(Icons.keyboard_arrow_up),
                )
              : null,
        );
      },
    );
  }

  List<Widget> _buildExploreContent(
    ExploreLoaded state,
    Color surfaceColor,
    Color primaryAccent,
    Color secondaryAccent,
    Color textPrimary,
    Color textSecondary,
  ) {
    return [
      // 3. Promoted Event (Optional Ad Space)
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: _buildPromotedEvent(
              surfaceColor, primaryAccent, textPrimary, textSecondary),
        ),
      ),

      // 4. Personalized "For You" Carousel
      SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'For You',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textPrimary,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'See All',
                      style: TextStyle(
                        color: primaryAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 280,
              child: ListView.builder(
                padding: const EdgeInsets.only(left: 16),
                scrollDirection: Axis.horizontal,
                itemCount: state.recommendedEvents.length,
                itemBuilder: (context, index) {
                  return EventCard(
                    event: state.recommendedEvents[index],
                    width: 220,
                    margin: const EdgeInsets.only(right: 16, bottom: 8),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // 5. Map Preview (Collapsible)
      SliverToBoxAdapter(
        child: _buildCollapsibleMap(
          surfaceColor,
          primaryAccent,
          secondaryAccent,
          textPrimary,
          textSecondary,
        ),
      ),

      // 6. Trending Nearby Section
      SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '🔥 Trending Nearby',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textPrimary,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'See All',
                      style: TextStyle(
                        color: primaryAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 280,
              child: state.isLoadingTrending
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(primaryAccent),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(left: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: state.trendingEvents.length,
                      itemBuilder: (context, index) {
                        return EventCard(
                          event: state.trendingEvents[index],
                          width: 220,
                          margin: const EdgeInsets.only(right: 16, bottom: 8),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),

      // "What's Hot Near You" module
      if (state.hotEvents.isNotEmpty) ...[
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 24, 16, 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  primaryAccent.withOpacity(0.8),
                  secondaryAccent.withOpacity(0.8),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.local_fire_department,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      "What's Hot Near You",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 180,
                  child: state.isLoadingHot
                      ? const Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.hotEvents.length,
                          itemBuilder: (context, index) {
                            final event = state.hotEvents[index];
                            return Container(
                              width: 160,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      topRight: Radius.circular(16),
                                    ),
                                    child: Image.network(
                                      event.imageUrl,
                                      height: 100,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          event.title,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: textPrimary,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_on,
                                              size: 12,
                                              color: primaryAccent,
                                            ),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                event.location,
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: textSecondary,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ],

      // 7. Smart Suggestions - "Because You Liked..."
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Text(
            'Because You Liked Food Festivals...',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textPrimary,
            ),
          ),
        ),
      ),

      // 8. Endless scroll feed (grid layout)
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index < state.nearbyEvents.length) {
                return _buildSuggestionCard(
                  state.nearbyEvents[index],
                  surfaceColor,
                  primaryAccent,
                  secondaryAccent,
                  textPrimary,
                  textSecondary,
                );
              } else {
                // This is a loading indicator at the end of the grid
                return const SizedBox();
              }
            },
            childCount: state.nearbyEvents.length,
          ),
        ),
      ),

      // Loading indicator for infinite scrolling
      if (state.isLoadingMore)
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(bottom: 32.0),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),

      // End of results message
      if (!state.hasMoreData && state.nearbyEvents.isNotEmpty)
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 32.0),
            child: Center(
              child: Text(
                "You've reached the end",
                style: TextStyle(
                  color: textSecondary,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
    ];
  }

  Widget _buildPromotedEvent(Color surfaceColor, Color primaryAccent,
      Color textPrimary, Color textSecondary) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.network(
                'https://source.unsplash.com/random/800x400/?concert',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 20,
            top: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: primaryAccent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'PROMOTED',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Summer Music Festival',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: Colors.white,
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'This Weekend',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Golden Gate Park',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollapsibleMap(
    Color surfaceColor,
    Color primaryAccent,
    Color secondaryAccent,
    Color textPrimary,
    Color textSecondary,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _isMapExpanded ? 280 : 80,
      margin: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Real map instead of placeholder image
            Positioned.fill(
              child: _isMapExpanded
                  ? GoogleMap(
                      onMapCreated: (controller) {
                        _mapController = controller;
                        _updateMapLocation();
                      },
                      initialCameraPosition: CameraPosition(
                        target: _currentPosition,
                        zoom: 14,
                      ),
                      markers: _markers,
                      zoomControlsEnabled: false,
                      myLocationEnabled: _locationPermissionGranted,
                      myLocationButtonEnabled: false,
                      compassEnabled: false,
                      onTap: (latLng) {
                        // Navigate to full map page when tapped
                        // Navigator.pushNamed(context, '/map', arguments: _markers);
                      },
                      onCameraMove: (position) {
                        // Update location if moved significantly
                        final distance = Geolocator.distanceBetween(
                          _currentPosition.latitude,
                          _currentPosition.longitude,
                          position.target.latitude,
                          position.target.longitude,
                        );

                        // If moved more than 5km
                        if (distance > 5000) {
                          _fetchNearbyEventsFromFirebase(position.target);
                        }
                      },
                    )
                  : Container(color: surfaceColor),
            ),

            // Map placeholder - show when not expanded
            if (!_isMapExpanded)
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.map,
                      color: secondaryAccent,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Tap to explore nearby events',
                      style: TextStyle(
                        color: textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

            // Map controls - show when expanded
            if (_isMapExpanded)
              Positioned(
                right: 12,
                bottom: 12,
                child: Column(
                  children: [
                    FloatingActionButton.small(
                      heroTag: 'explore_map_location',
                      backgroundColor: Colors.white,
                      onPressed: _getCurrentLocation,
                      child: const Icon(
                        Icons.my_location,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    FloatingActionButton.small(
                      heroTag: 'explore_map_filter',
                      backgroundColor: secondaryAccent,
                      onPressed: () {
                        // Show filter options for events on map
                        showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          builder: (context) => Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Filter Events',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    'All Events',
                                    'Music',
                                    'Food',
                                    'Art',
                                    'Sports',
                                    'Technology',
                                  ].map((filter) {
                                    return FilterChip(
                                      label: Text(filter),
                                      selected: filter == 'All Events',
                                      onSelected: (selected) {
                                        // Apply filter
                                        Navigator.pop(context);
                                      },
                                      backgroundColor: surfaceColor,
                                      selectedColor:
                                          primaryAccent.withOpacity(0.2),
                                      checkmarkColor: primaryAccent,
                                    );
                                  }).toList(),
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryAccent,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                    ),
                                    child: const Text('Apply Filters'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.tune,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

            // Event preview card when map is expanded
            if (_isMapExpanded &&
                context.read<ExploreBloc>().state is ExploreLoaded)
              Positioned(
                left: 12,
                right: 60,
                bottom: 12,
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                        ),
                        child: Image.network(
                          (context.read<ExploreBloc>().state as ExploreLoaded)
                                  .nearbyEvents
                                  .isNotEmpty
                              ? (context.read<ExploreBloc>().state
                                      as ExploreLoaded)
                                  .nearbyEvents[0]
                                  .imageUrl
                              : 'https://via.placeholder.com/80',
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            width: 80,
                            height: 80,
                            color: Colors.grey[300],
                            child: const Icon(Icons.image, color: Colors.grey),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                (context.read<ExploreBloc>().state
                                            as ExploreLoaded)
                                        .nearbyEvents
                                        .isNotEmpty
                                    ? (context.read<ExploreBloc>().state
                                            as ExploreLoaded)
                                        .nearbyEvents[0]
                                        .title
                                    : 'Nearby Events',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                (context.read<ExploreBloc>().state
                                            as ExploreLoaded)
                                        .nearbyEvents
                                        .isNotEmpty
                                    ? (context.read<ExploreBloc>().state
                                            as ExploreLoaded)
                                        .nearbyEvents[0]
                                        .location
                                    : 'View on map',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Tap to explore',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: primaryAccent,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Tappable overlay for expanding/collapsing
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _isMapExpanded = !_isMapExpanded;
                      if (_isMapExpanded) {
                        _fetchNearbyEventsFromFirebase(_currentPosition);
                      }
                    });
                    HapticFeedback.lightImpact();
                  },
                ),
              ),
            ),

            // Expand/collapse indicator
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: Icon(
                  _isMapExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: textPrimary,
                ),
                onPressed: () {
                  setState(() {
                    _isMapExpanded = !_isMapExpanded;
                    if (_isMapExpanded) {
                      _fetchNearbyEventsFromFirebase(_currentPosition);
                    }
                  });
                  HapticFeedback.lightImpact();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionCard(
    dynamic event,
    Color surfaceColor,
    Color primaryAccent,
    Color secondaryAccent,
    Color textPrimary,
    Color textSecondary,
  ) {
    // Alternating card style based on event ID hashcode
    final isEven = event.id.hashCode % 2 == 0;
    final cardAccent = isEven ? primaryAccent : secondaryAccent;

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                child: Image.network(
                  event.imageUrl,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 120,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.image_not_supported, size: 40),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.favorite_border,
                      size: 16,
                      color: cardAccent,
                    ),
                    onPressed: () {
                      HapticFeedback.lightImpact();
                    },
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Based on your interests',
                    style: TextStyle(
                      fontSize: 12,
                      color: cardAccent,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 12,
                        color: textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          _formatDateTime(event.startDate),
                          style: TextStyle(
                            fontSize: 12,
                            color: textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 12,
                        color: textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          event.location,
                          style: TextStyle(
                            fontSize: 12,
                            color: textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    width: double.infinity,
                    height: 28,
                    decoration: BoxDecoration(
                      color: cardAccent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 14,
                            color: cardAccent,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Interested',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: cardAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(
    dynamic event,
    Color surfaceColor,
    Color accentColor,
    Color textPrimary,
    Color textSecondary, {
    bool isSecondaryStyle = false,
  }) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 16, bottom: 8),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                child: Image.network(
                  event.imageUrl,
                  height: 130,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 130,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.image_not_supported, size: 40),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        event.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      isSecondaryStyle
                          ? Icons.bookmark_border
                          : Icons.favorite_border,
                      size: 18,
                      color: accentColor,
                    ),
                    onPressed: () {
                      HapticFeedback.lightImpact();
                    },
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          _formatDateTime(event.startDate),
                          style: TextStyle(
                            fontSize: 12,
                            color: textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          event.location,
                          style: TextStyle(
                            fontSize: 12,
                            color: textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      _buildActionButton(
                        icon:
                            isSecondaryStyle ? Icons.check_circle : Icons.event,
                        label: isSecondaryStyle ? 'Visit' : 'RSVP',
                        color: accentColor,
                      ),
                      const SizedBox(width: 8),
                      _buildActionButton(
                        icon: isSecondaryStyle ? Icons.directions : Icons.share,
                        label: isSecondaryStyle ? 'Directions' : 'Share',
                        color: textSecondary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    // Get difference from now
    final now = DateTime.now();
    final difference = dateTime.difference(now);

    if (difference.inDays == 0) {
      return 'Today, ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Tomorrow, ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 7) {
      final weekdays = [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday'
      ];
      return '${weekdays[dateTime.weekday - 1]}, ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else {
      return '${dateTime.day}/${dateTime.month}, ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        height: 32,
        decoration: BoxDecoration(
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              HapticFeedback.lightImpact();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: color,
                ),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilters(
      Color primaryAccent, Color surfaceColor, Color textPrimary) {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(top: 8),
      child: BlocBuilder<ExploreBloc, ExploreState>(
        builder: (context, state) {
          String selectedFilter = _selectedFilter;

          if (state is ExploreLoaded && state.selectedCategory != null) {
            selectedFilter = state.selectedCategory!;
          }

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _filters.length,
            itemBuilder: (context, index) {
              final filter = _filters[index];
              final isSelected = filter == selectedFilter;

              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: ChoiceChip(
                  label: Text(filter),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedFilter = filter;
                      });

                      // Dispatch filter event to BLoC
                      context
                          .read<ExploreBloc>()
                          .add(FilterByCategory(filter) as ExploreEvent);

                      HapticFeedback.lightImpact();
                    }
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isSelected ? primaryAccent : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  selectedColor: primaryAccent.withOpacity(0.15),
                  backgroundColor: surfaceColor,
                  labelStyle: TextStyle(
                    color: isSelected ? primaryAccent : textPrimary,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 14,
                  ),
                  labelPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
