import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _mapController;
  final LatLng _defaultLocation =
      const LatLng(37.7749, -122.4194); // San Francisco
  final double _defaultZoom = 13.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _defaultLocation,
              zoom: _defaultZoom,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            compassEnabled: false,
            mapToolbarEnabled: false,
            onMapCreated: (controller) {
              _mapController = controller;
            },
          ),
          // Category chips
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildCategoryChip('All', isSelected: true),
                  _buildCategoryChip('Food'),
                  _buildCategoryChip('Events'),
                  _buildCategoryChip('Nightlife'),
                  _buildCategoryChip('Outdoors'),
                  _buildCategoryChip('Shopping'),
                ],
              ),
            ),
          ),
          // Filter button
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                _showFilterModal();
              },
              heroTag: 'map_filter_button',
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF9B79FF)
                  : const Color(0xFF6F3DFF),
              child: const Icon(Icons.tune, color: Colors.white),
            ),
          ),
          // Location button
          Positioned(
            bottom: 20,
            right: 90, // Position it to the left of the filter button
            child: FloatingActionButton.small(
              onPressed: () {
                // Would center on user location
              },
              heroTag: 'location_button',
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              child: const Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          // Handle category selection
        },
        backgroundColor: Colors.white,
        selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        labelStyle: TextStyle(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).textTheme.bodyMedium?.color,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
    );
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Map Filters',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontFamily: 'Sora',
                    ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.event),
                title:
                    const Text('Events', style: TextStyle(fontFamily: 'Inter')),
                trailing: Switch(
                  value: true,
                  activeColor: isDark
                      ? const Color(0xFF9B79FF)
                      : const Color(0xFF6F3DFF),
                  onChanged: (value) {
                    // Handle filter change
                  },
                ),
              ),
              ListTile(
                leading: const Icon(Icons.place),
                title:
                    const Text('Venues', style: TextStyle(fontFamily: 'Inter')),
                trailing: Switch(
                  value: true,
                  activeColor: isDark
                      ? const Color(0xFF9B79FF)
                      : const Color(0xFF6F3DFF),
                  onChanged: (value) {
                    // Handle filter change
                  },
                ),
              ),
              ListTile(
                leading: const Icon(Icons.group),
                title: const Text('Meet-ups',
                    style: TextStyle(fontFamily: 'Inter')),
                trailing: Switch(
                  value: false,
                  activeColor: isDark
                      ? const Color(0xFF9B79FF)
                      : const Color(0xFF6F3DFF),
                  onChanged: (value) {
                    // Handle filter change
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
