import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Events',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'My Events'),
            Tab(text: 'Saved'),
          ],
          indicatorSize: TabBarIndicatorSize.label,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildUpcomingEvents(),
          _buildMyEvents(),
          _buildSavedEvents(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add event screen
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildUpcomingEvents() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 120, bottom: 16),
      itemCount: 10,
      itemBuilder: (context, index) {
        return _buildEventCard(index, 'Upcoming Event');
      },
    );
  }

  Widget _buildMyEvents() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 120, bottom: 16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return _buildEventCard(index, 'My Event');
      },
    );
  }

  Widget _buildSavedEvents() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 120, bottom: 16),
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
}
