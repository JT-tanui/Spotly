import 'package:flutter/material.dart';

import '../../../domain/entities/event.dart';

class SavedEventsScreen extends StatefulWidget {
  const SavedEventsScreen({super.key});

  @override
  _SavedEventsScreenState createState() => _SavedEventsScreenState();
}

class _SavedEventsScreenState extends State<SavedEventsScreen> {
  bool _isLoading = false;
  List<Event> _savedEvents = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadSavedEvents();
  }

  Future<void> _loadSavedEvents() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // In a real implementation, this would use a repository
      // For now, we'll use mock data
      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        _savedEvents = [
          Event(
            id: '3',
            title: 'Music Festival',
            description: 'Annual music festival featuring local bands',
            location: 'City Park',
            startDate: DateTime.now().add(const Duration(days: 15)),
            endDate: DateTime.now().add(const Duration(days: 16)),
            imageUrl: 'https://picsum.photos/seed/event3/300/200',
            categories: ['Music'],
            price: 79.99,
            maxAttendees: 5000,
            attendees: 2150,
            latitude: 0.0,
            longitude: 0.0,
            organizer: 'Temporary',
            rating: 0.0,
            reviewCount: 0,
            tags: [],
          ),
          Event(
            id: '4',
            title: 'Food & Wine Expo',
            description: 'Sample the best local cuisine and wines',
            location: 'Convention Center',
            startDate: DateTime.now().add(const Duration(days: 20)),
            endDate: DateTime.now().add(const Duration(days: 20, hours: 8)),
            imageUrl: 'https://picsum.photos/seed/event4/300/200',
            categories: ['Food & Drink'],
            price: 35.0,
            maxAttendees: 1000,
            attendees: 750,
            latitude: 0.0,
            longitude: 0.0,
            organizer: 'Temporary',
            rating: 0.0,
            reviewCount: 0,
            tags: [],
          ),
        ];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Events'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error: $_error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadSavedEvents,
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    if (_savedEvents.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.bookmark_border, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'You haven\'t saved any events yet',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to events discovery screen
                Navigator.pop(context);
              },
              icon: const Icon(Icons.search),
              label: const Text('Discover Events'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadSavedEvents,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _savedEvents.length,
        itemBuilder: (context, index) {
          final event = _savedEvents[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            clipBehavior: Clip.antiAlias,
            elevation: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event image
                Image.network(
                  event.imageUrl,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 150,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child:
                          const Icon(Icons.image, size: 50, color: Colors.grey),
                    );
                  },
                ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Event title
                      Text(
                        event.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Event date and time
                      Row(
                        children: [
                          const Icon(Icons.calendar_today,
                              size: 16, color: Colors.blue),
                          const SizedBox(width: 8),
                          Text(
                            _formatDate(event.startDate),
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // Event location
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              size: 16, color: Colors.blue),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              event.location,
                              style: TextStyle(color: Colors.grey[700]),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Action buttons
                ButtonBar(
                  alignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        // View event details
                      },
                      icon: const Icon(Icons.visibility),
                      label: const Text('View Details'),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _savedEvents.removeWhere((e) => e.id == event.id);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Event removed from saved')),
                        );
                      },
                      icon: const Icon(Icons.bookmark, color: Colors.blue),
                      tooltip: 'Remove from saved',
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
