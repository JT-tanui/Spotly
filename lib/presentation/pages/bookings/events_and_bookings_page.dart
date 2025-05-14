import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventsAndBookingsPage extends StatefulWidget {
  const EventsAndBookingsPage({super.key});

  @override
  State<EventsAndBookingsPage> createState() => _EventsAndBookingsPageState();
}

class _EventsAndBookingsPageState extends State<EventsAndBookingsPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late TabController _eventsTabController;
  int _mainTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _eventsTabController = TabController(length: 3, vsync: this);

    _tabController.addListener(() {
      setState(() {
        _mainTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _eventsTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Column(
        children: [
          // Main tab bar to switch between Events and Bookings
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Events'),
              Tab(text: 'Bookings'),
            ],
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),

          // Content based on main tab selection
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Events Tab Content
                Column(
                  children: [
                    // Events sub-tabs
                    TabBar(
                      controller: _eventsTabController,
                      tabs: const [
                        Tab(text: 'Upcoming'),
                        Tab(text: 'My Events'),
                        Tab(text: 'Saved'),
                      ],
                      indicatorSize: TabBarIndicatorSize.label,
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),

                    // Events sub-tab content
                    Expanded(
                      child: TabBarView(
                        controller: _eventsTabController,
                        children: [
                          _buildUpcomingEvents(),
                          _buildMyEvents(),
                          _buildSavedEvents(),
                        ],
                      ),
                    ),
                  ],
                ),

                // Bookings Tab Content
                _buildBookingsContent(context),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _mainTabIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                // Navigate to add event screen
              },
              heroTag: 'events_bookings_fab',
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _buildUpcomingEvents() {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: 10,
      itemBuilder: (context, index) {
        return _buildEventCard(index, 'Upcoming Event');
      },
    );
  }

  Widget _buildMyEvents() {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return _buildEventCard(index, 'My Event');
      },
    );
  }

  Widget _buildSavedEvents() {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: 7,
      itemBuilder: (context, index) {
        return _buildEventCard(index, 'Saved Event');
      },
    );
  }

  Widget _buildEventCard(int index, String prefix) {
    // Mock date - today + index days
    final date = DateTime.now().add(Duration(days: index + 1));
    final formattedDate = DateFormat('E, d MMM').format(date);
    final formattedTime = DateFormat('h:mm a').format(date);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event image
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              'https://picsum.photos/seed/${index + 200}/600/400',
              fit: BoxFit.cover,
            ),
          ),
          // Event details
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$prefix ${index + 1}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'This is a description for $prefix ${index + 1}. Join us for an amazing experience!',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      'Location ${index + 1}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      formattedDate,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.access_time, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      formattedTime,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        // View details
                      },
                      child: const Text('Details'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        // Register or RSVP
                      },
                      child: const Text('Register'),
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

  Widget _buildBookingsContent(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Bookings',
                  style: TextStyle(
                    fontFamily: 'Sora',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? const Color(0xFFFAFAFA)
                        : const Color(0xFF111111),
                  ),
                ),
                const SizedBox(height: 16),
                _buildBookingsEmptyState(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBookingsEmptyState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 64,
            color: isDark ? const Color(0xFF9B79FF) : const Color(0xFF6F3DFF),
          ),
          const SizedBox(height: 16),
          Text(
            'No Bookings Yet',
            style: TextStyle(
              fontFamily: 'Sora',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? const Color(0xFFFAFAFA) : const Color(0xFF111111),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your upcoming bookings will appear here',
            style: TextStyle(
              fontFamily: 'Inter',
              color: isDark ? const Color(0xFFB3B3B3) : const Color(0xFF555555),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Switch to Events tab
              _tabController.animateTo(0);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isDark ? const Color(0xFF9B79FF) : const Color(0xFF6F3DFF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Explore Events',
              style: TextStyle(
                fontFamily: 'Sora',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
