import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:spotly/presentation/pages/explore/explore_page.dart';
import 'package:spotly/presentation/pages/bookings/events_and_bookings_page.dart';
import 'package:spotly/presentation/pages/profile/profile_screen.dart';
import 'package:spotly/presentation/pages/map/map_page.dart';
import '../../../config/routes/app_router.dart';

class SpotlyHome extends StatefulWidget {
  final int initialTabIndex;

  const SpotlyHome({
    super.key,
    this.initialTabIndex = 0,
  });

  @override
  State<SpotlyHome> createState() => _SpotlyHomeState();
}

class _SpotlyHomeState extends State<SpotlyHome> with TickerProviderStateMixin {
  late int _currentIndex;
  bool _isTransitioning = false;
  late AnimationController _animationController;
  late Animation<double> _blurAnimation;
  late PageController _pageController;

  final List<Widget> _screens = [
    const ExplorePage(),
    const MapPage(),
    const EventsAndBookingsPage(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Use the initial tab index passed to the widget
    _currentIndex = widget.initialTabIndex;
    _pageController = PageController(initialPage: _currentIndex);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _blurAnimation = Tween<double>(begin: 0, end: 5).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        setState(() {
          _isTransitioning = false;
        });
      }
    });
  }

  @override
  void dispose() {
    if (_pageController.hasClients) {
      _pageController.dispose();
    }
    _animationController.dispose();
    super.dispose();
  }

  void _navigateToPage(int index) {
    // If it's the create button index (2), show the create content modal
    if (index == 2) {
      _showCreateContentModal();
      return;
    }

    // Adjust index to skip the create button
    int actualIndex = index > 2 ? index - 1 : index;

    if (_currentIndex == actualIndex) return;

    setState(() {
      _isTransitioning = true;
      _currentIndex = actualIndex;
    });

    HapticFeedback.lightImpact();
    _animationController.forward();

    if (_pageController.hasClients) {
      _pageController.animateToPage(
        actualIndex,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      setState(() {
        _isTransitioning = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor =
        isDark ? const Color(0xFF9B79FF) : const Color(0xFF6F3DFF);
    final createButtonColor =
        const Color(0xFFF55A5A); // Coral color for create button

    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),
          AnimatedBuilder(
            animation: _blurAnimation,
            builder: (context, child) {
              return Visibility(
                visible: _isTransitioning,
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: _blurAnimation.value,
                    sigmaY: _blurAnimation.value,
                  ),
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex < 2 ? _currentIndex : _currentIndex + 1,
        onDestinationSelected: _navigateToPage,
        animationDuration: const Duration(milliseconds: 500),
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        elevation: 8,
        shadowColor: theme.colorScheme.shadow.withOpacity(0.3),
        backgroundColor:
            isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF7F8FC),
        destinations: [
          // Explore
          _buildAnimatedDestination(
              Icons.explore_outlined, Icons.explore, 'Explore', 0),

          // Map
          _buildAnimatedDestination(Icons.map_outlined, Icons.map, 'Map', 1),

          // Create - Special center button
          NavigationDestination(
            icon: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: createButtonColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: createButtonColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 28,
              ),
            ),
            label: 'Create',
          ),

          // Events
          _buildAnimatedDestination(
              Icons.calendar_today_outlined, Icons.calendar_today, 'Events', 3),

          // Profile
          _buildAnimatedDestination(
              Icons.person_outline, Icons.person, 'Profile', 4),
        ],
      ),
    );
  }

  Widget _buildAnimatedDestination(
      IconData outlinedIcon, IconData filledIcon, String label, int index) {
    int adjustedCurrentIndex =
        _currentIndex < 2 ? _currentIndex : _currentIndex + 1;
    final isSelected = adjustedCurrentIndex == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor =
        isDark ? const Color(0xFF9B79FF) : const Color(0xFF6F3DFF);

    return NavigationDestination(
      icon: Icon(
        isSelected ? filledIcon : outlinedIcon,
        color: isSelected
            ? primaryColor
            : Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      selectedIcon: Icon(
        filledIcon,
        color: primaryColor,
      ),
      label: label,
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

  void _showCreateContentModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF1E1E1E)
          : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(24)), // 24dp as specified
      ),
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final textPrimaryColor =
            isDark ? const Color(0xFFF1F1F1) : const Color(0xFF212121);
        final textSecondaryColor =
            isDark ? const Color(0xFFBBBBBB) : const Color(0xFF666666);
        final primaryColor =
            isDark ? const Color(0xFFFF6E6E) : const Color(0xFFF55A5A); // Coral

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: textSecondaryColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Create',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textPrimaryColor,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'What would you like to share today?',
                style: TextStyle(
                  fontSize: 16,
                  color: textSecondaryColor,
                ),
              ),
              const SizedBox(height: 24),
              _buildContentOption(
                context,
                icon: Icons.event,
                iconColor: primaryColor,
                title: 'Post an Event',
                description: 'Share details about an upcoming event',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, AppRouter.addEvent);
                },
              ),
              _buildContentOption(
                context,
                icon: Icons.photo_camera,
                iconColor: primaryColor,
                title: 'Share a Photo or Video',
                description: 'Upload media from your device',
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to photo/video upload page
                },
              ),
              _buildContentOption(
                context,
                icon: Icons.star_rate,
                iconColor: primaryColor,
                title: 'Write a Review',
                description: 'Rate and review a place or event',
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to review writing page
                },
              ),
              _buildContentOption(
                context,
                icon: Icons.group,
                iconColor: primaryColor,
                title: 'Create a Meet-up / Invite',
                description: 'Organize an informal gathering',
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to meet-up creation page
                },
              ),
              _buildContentOption(
                context,
                icon: Icons.lightbulb,
                iconColor: primaryColor,
                title: 'Suggest a Hidden Gem',
                description: 'Recommend an undiscovered place',
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to hidden gem suggestion page
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContentOption(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor =
        isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF8F8F8);
    final textPrimaryColor =
        isDark ? const Color(0xFFF1F1F1) : const Color(0xFF212121);
    final textSecondaryColor =
        isDark ? const Color(0xFFBBBBBB) : const Color(0xFF666666);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: textSecondaryColor,
            ),
          ],
        ),
      ),
    );
  }
}

// Simple placeholder for the Map screen
class MapPlaceholder extends StatelessWidget {
  const MapPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // Map placeholder
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.map,
                  size: 100,
                  color: isDark
                      ? const Color(0xFF9B79FF)
                      : const Color(0xFF6F3DFF),
                ),
                const SizedBox(height: 20),
                Text(
                  'Map View',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          // Category chips at the top
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: const [
                  CategoryChip(label: 'All', isSelected: true),
                  CategoryChip(label: 'Food'),
                  CategoryChip(label: 'Events'),
                  CategoryChip(label: 'Nightlife'),
                  CategoryChip(label: 'Outdoors'),
                  CategoryChip(label: 'Shopping'),
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
                // Show filter modal
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  builder: (context) {
                    final isDark =
                        Theme.of(context).brightness == Brightness.dark;
                    return Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Map Filters',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontFamily: 'Sora',
                                ),
                          ),
                          const SizedBox(height: 16),
                          ListTile(
                            leading: const Icon(Icons.event),
                            title: const Text('Events',
                                style: TextStyle(fontFamily: 'Inter')),
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
                            title: const Text('Venues',
                                style: TextStyle(fontFamily: 'Inter')),
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
              },
              heroTag: 'map_filter_button',
              backgroundColor:
                  isDark ? const Color(0xFF9B79FF) : const Color(0xFF6F3DFF),
              child: const Icon(Icons.tune, color: Colors.white),
            ),
          ),

          // Location button
          Positioned(
            bottom: 20,
            right: 90, // Position it to the left of the filter button
            child: FloatingActionButton.small(
              onPressed: () {
                // Center on user location
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
}

// Simple category chip for the map
class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;

  const CategoryChip({
    super.key,
    required this.label,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          // Handle category selection
        },
        backgroundColor: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        selectedColor: isDark
            ? const Color(0xFF9B79FF).withOpacity(0.2)
            : const Color(0xFF6F3DFF).withOpacity(0.2),
        labelStyle: TextStyle(
          color: isSelected
              ? isDark
                  ? const Color(0xFF9B79FF)
                  : const Color(0xFF6F3DFF)
              : isDark
                  ? Colors.white70
                  : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected
                ? isDark
                    ? const Color(0xFF9B79FF)
                    : const Color(0xFF6F3DFF)
                : Colors.grey.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
    );
  }
}
