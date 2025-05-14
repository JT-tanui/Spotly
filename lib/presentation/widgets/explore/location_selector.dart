import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotly/presentation/blocs/location_bloc/location_bloc.dart';
import 'package:spotly/presentation/blocs/location_bloc/location_event.dart';
import 'package:spotly/presentation/blocs/location_bloc/location_state.dart';

class LocationSelector extends StatelessWidget {
  const LocationSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryAccent =
        isDark ? const Color(0xFFFF7F7F) : const Color(0xFFFF6B6B);

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => const LocationSelectorModal(),
        );
        HapticFeedback.selectionClick();
      },
      child: BlocBuilder<LocationBloc, LocationState>(
        builder: (context, state) {
          String locationText = 'Select location';
          bool isLoading = false;

          if (state is LocationLoading) {
            isLoading = true;
            locationText = 'Getting location...';
          } else if (state is LocationLoaded) {
            locationText = state.address ?? 'Current Location';
          } else if (state is LocationError) {
            locationText = 'Location unavailable';
          }

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isDark ? Colors.black26 : Colors.white70,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
              border: Border.all(
                color: primaryAccent.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isLoading)
                  SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(primaryAccent),
                    ),
                  )
                else
                  Icon(
                    Icons.location_on,
                    size: 14,
                    color: primaryAccent,
                  ),
                const SizedBox(width: 4),
                Text(
                  locationText,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
                const SizedBox(width: 2),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 14,
                  color: Theme.of(context).iconTheme.color?.withOpacity(0.7),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class LocationSelectorModal extends StatefulWidget {
  const LocationSelectorModal({super.key});

  @override
  State<LocationSelectorModal> createState() => _LocationSelectorModalState();
}

class _LocationSelectorModalState extends State<LocationSelectorModal> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, dynamic>> _recentLocations = [
    {'name': 'San Francisco', 'neighborhood': 'California', 'isRecent': true},
    {
      'name': 'Mission District',
      'neighborhood': 'San Francisco',
      'isRecent': true
    },
    {'name': 'SoMa', 'neighborhood': 'San Francisco', 'isRecent': true},
    {'name': 'Nob Hill', 'neighborhood': 'San Francisco', 'isRecent': true},
  ];

  final List<Map<String, dynamic>> _nearbyLocations = [
    {'name': 'Oakland', 'neighborhood': 'California', 'distance': '12 mi'},
    {'name': 'Berkeley', 'neighborhood': 'California', 'distance': '15 mi'},
    {'name': 'Palo Alto', 'neighborhood': 'California', 'distance': '30 mi'},
    {'name': 'San Jose', 'neighborhood': 'California', 'distance': '50 mi'},
    {'name': 'Sausalito', 'neighborhood': 'California', 'distance': '10 mi'},
  ];

  bool _isSearchFocused = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Style variables
    final backgroundColor = isDark ? const Color(0xFF121212) : Colors.white;
    final surfaceColor =
        isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF9F9F9);
    final primaryAccent =
        isDark ? const Color(0xFFFF7F7F) : const Color(0xFFFF6B6B);
    final textPrimary =
        isDark ? const Color(0xFFF1F1F1) : const Color(0xFF212121);
    final textSecondary =
        isDark ? const Color(0xFFB5B5B5) : const Color(0xFF6B6B6B);

    return Container(
      height: size.height * 0.7,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle and header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            width: double.infinity,
            child: Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[700] : Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Set Location',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close,
                    size: 20,
                    color: textSecondary,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

          // Search field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Focus(
                onFocusChange: (hasFocus) {
                  setState(() {
                    _isSearchFocused = hasFocus;
                  });
                },
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search for a city or neighborhood',
                    hintStyle: TextStyle(
                      color: textSecondary,
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: _isSearchFocused ? primaryAccent : textSecondary,
                      size: 20,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
          ),

          // Current location option
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Text(
              'Current Location',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: BlocBuilder<LocationBloc, LocationState>(
              builder: (context, state) {
                return GestureDetector(
                  onTap: () {
                    final locationBloc = context.read<LocationBloc>();
                    locationBloc.add(GetCurrentLocation());
                    Navigator.pop(context);
                    HapticFeedback.mediumImpact();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: primaryAccent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: primaryAccent.withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: primaryAccent.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.my_location,
                            color: primaryAccent,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Use my current location',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: textPrimary,
                                ),
                              ),
                              if (state is LocationLoaded &&
                                  state.address != null)
                                Text(
                                  state.address!,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: textSecondary,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: textSecondary,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Recent locations
          if (_recentLocations.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
              child: Text(
                'Recent Locations',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _recentLocations.length,
                itemBuilder: (context, index) {
                  final location = _recentLocations[index];
                  return _buildLocationTile(
                    location: location['name'],
                    subtitle: location['neighborhood'],
                    icon: Icons.history,
                    onTap: () {
                      context.read<LocationBloc>().add(
                            SetManualLocation(
                              address:
                                  '${location['name']}, ${location['neighborhood']}',
                              latitude: 37.7749, // Mock coordinates
                              longitude: -122.4194,
                            ),
                          );
                      Navigator.pop(context);
                    },
                    iconColor: textSecondary,
                    textColor: textPrimary,
                    subtitleColor: textSecondary,
                  );
                },
              ),
            ),
          ],

          // Nearby locations
          if (_recentLocations.isEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
              child: Text(
                'Nearby Locations',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _nearbyLocations.length,
                itemBuilder: (context, index) {
                  final location = _nearbyLocations[index];
                  return _buildLocationTile(
                    location: location['name'],
                    subtitle: location['neighborhood'],
                    trailingText: location['distance'],
                    icon: Icons.location_on,
                    onTap: () {
                      context.read<LocationBloc>().add(
                            SetManualLocation(
                              address:
                                  '${location['name']}, ${location['neighborhood']}',
                              latitude: 37.7749, // Mock coordinates
                              longitude: -122.4194,
                            ),
                          );
                      Navigator.pop(context);
                    },
                    iconColor: primaryAccent,
                    textColor: textPrimary,
                    subtitleColor: textSecondary,
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLocationTile({
    required String location,
    required String subtitle,
    String? trailingText,
    required IconData icon,
    required VoidCallback onTap,
    required Color iconColor,
    required Color textColor,
    required Color subtitleColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: iconColor,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    location,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: subtitleColor,
                    ),
                  ),
                ],
              ),
            ),
            if (trailingText != null)
              Text(
                trailingText,
                style: TextStyle(
                  fontSize: 13,
                  color: subtitleColor,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
