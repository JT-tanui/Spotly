import 'package:flutter/material.dart';

class LocationSelector extends StatefulWidget {
  final String initialLocation;
  final Function(String) onLocationChanged;

  const LocationSelector({
    super.key,
    required this.initialLocation,
    required this.onLocationChanged,
  });

  @override
  State<LocationSelector> createState() => _LocationSelectorState();
}

class _LocationSelectorState extends State<LocationSelector> {
  late String _currentLocation;

  @override
  void initState() {
    super.initState();
    _currentLocation = widget.initialLocation;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor =
        isDark ? const Color(0xFF9B79FF) : const Color(0xFF6F3DFF);

    return GestureDetector(
      onTap: _showLocationSelector,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: primaryColor.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "📍",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(width: 8),
            Text(
              _currentLocation,
              style: TextStyle(
                fontFamily: 'Sora',
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 18,
              color: primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  void _showLocationSelector() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildLocationSheet(),
    );
  }

  Widget _buildLocationSheet() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor =
        isDark ? const Color(0xFF9B79FF) : const Color(0xFF6F3DFF);

    // Example list of locations
    final locations = [
      "Nairobi, Westlands",
      "Nairobi, Karen",
      "Nairobi, Kilimani",
      "Mombasa, Nyali",
      "Kisumu, CBD",
      "Nakuru, Town Center",
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Select Location",
                style: TextStyle(
                  fontFamily: 'Sora',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.my_location),
                color: primaryColor,
                onPressed: () {
                  // Get current location (would use geolocation in real app)
                  setState(() {
                    _currentLocation = "Nairobi, Westlands"; // Example
                  });
                  widget.onLocationChanged(_currentLocation);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              hintText: "Search locations",
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: isDark ? Colors.black12 : Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              hintStyle: TextStyle(
                fontFamily: 'Inter',
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: locations.length,
              itemBuilder: (context, index) {
                final location = locations[index];
                final isSelected = location == _currentLocation;

                return ListTile(
                  leading: Icon(
                    Icons.location_on_outlined,
                    color: isSelected ? primaryColor : null,
                  ),
                  title: Text(
                    location,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: isSelected
                          ? primaryColor
                          : (isDark ? Colors.white : Colors.black87),
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(Icons.check, color: primaryColor)
                      : null,
                  onTap: () {
                    setState(() {
                      _currentLocation = location;
                    });
                    widget.onLocationChanged(location);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
