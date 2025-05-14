import 'package:flutter/material.dart';

class MapFilterBottomSheet extends StatefulWidget {
  final bool showEvents;
  final bool showPlaces;
  final Function(bool showEvents, bool showPlaces) onFilterChanged;

  const MapFilterBottomSheet({
    super.key,
    required this.showEvents,
    required this.showPlaces,
    required this.onFilterChanged,
  });

  @override
  State<MapFilterBottomSheet> createState() => _MapFilterBottomSheetState();
}

class _MapFilterBottomSheetState extends State<MapFilterBottomSheet> {
  late bool _showEvents;
  late bool _showPlaces;
  String _selectedRadius = '5km';

  // Filter options
  final List<String> _categoryOptions = [
    'All',
    'Food',
    'Events',
    'Nightlife',
    'Outdoors',
    'Shopping',
  ];

  final List<String> _radiusOptions = [
    '1km',
    '2km',
    '5km',
    '10km',
    '20km',
  ];

  final Map<String, bool> _categorySelections = {
    'All': true,
    'Food': true,
    'Events': true,
    'Nightlife': true,
    'Outdoors': true,
    'Shopping': true,
  };

  @override
  void initState() {
    super.initState();
    _showEvents = widget.showEvents;
    _showPlaces = widget.showPlaces;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor =
        isDark ? const Color(0xFF9B79FF) : const Color(0xFF6F3DFF);

    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: 16,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Map Filters',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontFamily: 'Sora',
                      fontWeight: FontWeight.bold,
                    ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _showEvents = true;
                    _showPlaces = true;
                    _selectedRadius = '5km';
                    for (var key in _categorySelections.keys) {
                      _categorySelections[key] = true;
                    }
                  });
                },
                child: Text(
                  'Reset',
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          const Divider(),

          // Show/Hide Sections
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  // Display Options Section
                  const Text(
                    'Display Options',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Sora',
                    ),
                  ),
                  const SizedBox(height: 12),

                  _buildSwitchTile(
                    icon: Icons.event,
                    title: 'Events',
                    subtitle: 'Show user-created events on the map',
                    value: _showEvents,
                    onChanged: (value) {
                      setState(() {
                        _showEvents = value;
                      });
                    },
                    primaryColor: primaryColor,
                  ),

                  _buildSwitchTile(
                    icon: Icons.place,
                    title: 'Places',
                    subtitle: 'Show venues and places of interest',
                    value: _showPlaces,
                    onChanged: (value) {
                      setState(() {
                        _showPlaces = value;
                      });
                    },
                    primaryColor: primaryColor,
                  ),

                  const SizedBox(height: 24),

                  // Categories Section
                  const Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Sora',
                    ),
                  ),
                  const SizedBox(height: 12),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _categoryOptions.map((category) {
                      return FilterChip(
                        label: Text(category),
                        selected: _categorySelections[category] ?? false,
                        onSelected: (selected) {
                          setState(() {
                            _categorySelections[category] = selected;
                          });
                        },
                        backgroundColor: Colors.white,
                        selectedColor: primaryColor.withOpacity(0.2),
                        checkmarkColor: primaryColor,
                        labelStyle: TextStyle(
                          color: _categorySelections[category] ?? false
                              ? primaryColor
                              : Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: _categorySelections[category] ?? false
                                ? primaryColor
                                : Colors.grey.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),

                  // Search Radius Section
                  const Text(
                    'Search Radius',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Sora',
                    ),
                  ),
                  const SizedBox(height: 12),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _radiusOptions.map((radius) {
                      return ChoiceChip(
                        label: Text(radius),
                        selected: _selectedRadius == radius,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedRadius = radius;
                            });
                          }
                        },
                        backgroundColor: Colors.white,
                        selectedColor: primaryColor.withOpacity(0.2),
                        labelStyle: TextStyle(
                          color: _selectedRadius == radius
                              ? primaryColor
                              : Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: _selectedRadius == radius
                                ? primaryColor
                                : Colors.grey.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          const Divider(),

          // Apply Button
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  widget.onFilterChanged(_showEvents, _showPlaces);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Apply Filters',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Sora',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color primaryColor,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: primaryColor),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          color: Colors.grey[600],
        ),
      ),
      trailing: Switch(
        value: value,
        activeColor: primaryColor,
        onChanged: onChanged,
      ),
    );
  }
}
