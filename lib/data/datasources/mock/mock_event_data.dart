import 'package:spotly/data/models/event_model.dart';

/// Mock data for events to use during development and testing
class MockEventData {
  /// Get a list of mock events
  static List<EventModel> getMockEvents() {
    return [
      EventModel(
        id: '1',
        title: 'Music Festival',
        description: 'Annual music festival with top artists',
        imageUrl: 'https://picsum.photos/800/500?random=1',
        categories: ['Music', 'Festival'],
        location: 'Central Park',
        startDate: DateTime.now().add(const Duration(days: 7)),
        endDate: DateTime.now().add(const Duration(days: 7, hours: 6)),
        price: 49.99,
        maxAttendees: 1000,
        attendees: 750,
        latitude: 40.7829,
        longitude: -73.9654,
        organizer: 'City Events',
        rating: 4.5,
        reviewCount: 120,
        tags: ['music', 'festival', 'summer'],
        metadata: {
          'featured': true,
        },
      ),
      EventModel(
        id: '2',
        title: 'Food & Wine Festival',
        description: 'Taste food and wine from local restaurants',
        imageUrl: 'https://picsum.photos/800/500?random=2',
        categories: ['Food', 'Wine'],
        location: 'Downtown Square',
        startDate: DateTime.now().add(const Duration(days: 14)),
        endDate: DateTime.now().add(const Duration(days: 14, hours: 8)),
        price: 35.00,
        maxAttendees: 500,
        attendees: 320,
        latitude: 40.7128,
        longitude: -74.0060,
        organizer: 'Foodies Inc',
        rating: 4.8,
        reviewCount: 450,
        tags: ['food', 'wine', 'tasting'],
        metadata: {
          'featured': true,
        },
      ),
      EventModel(
        id: '3',
        title: 'Tech Conference',
        description: 'Learn about the latest technologies and trends',
        imageUrl: 'https://picsum.photos/800/500?random=3',
        categories: ['Technology', 'Conference'],
        location: 'Convention Center',
        startDate: DateTime.now().add(const Duration(days: 21)),
        endDate: DateTime.now().add(const Duration(days: 22)),
        price: 199.99,
        maxAttendees: 2000,
        attendees: 1500,
        latitude: 40.7128,
        longitude: -74.0060,
        organizer: 'TechEvents',
        rating: 4.2,
        reviewCount: 85,
        tags: ['tech', 'conference', 'networking'],
        metadata: {
          'featured': false,
        },
      ),
      EventModel(
        id: '4',
        title: 'Art Exhibition',
        description: 'Modern art exhibition featuring local artists',
        imageUrl: 'https://picsum.photos/800/500?random=4',
        categories: ['Arts', 'Exhibition'],
        location: 'City Gallery',
        startDate: DateTime.now().add(const Duration(days: 3)),
        endDate: DateTime.now().add(const Duration(days: 3, hours: 4)),
        price: 15.00,
        maxAttendees: 200,
        attendees: 75,
        latitude: 40.7128,
        longitude: -74.0060,
        organizer: 'Art Society',
        rating: 4.0,
        reviewCount: 45,
        tags: ['art', 'exhibition', 'local'],
        metadata: {
          'featured': true,
        },
      ),
      EventModel(
        id: '5',
        title: 'Sports Tournament',
        description: 'Local sports tournament with prizes',
        imageUrl: 'https://picsum.photos/800/500?random=5',
        categories: ['Sports', 'Tournament'],
        location: 'City Stadium',
        startDate: DateTime.now().add(const Duration(days: 10)),
        endDate: DateTime.now().add(const Duration(days: 10, hours: 6)),
        price: 25.00,
        maxAttendees: 1500,
        attendees: 900,
        latitude: 40.7128,
        longitude: -74.0060,
        organizer: 'Sports Association',
        rating: 4.6,
        reviewCount: 230,
        tags: ['sports', 'tournament', 'competition'],
        metadata: {
          'featured': false,
        },
      ),
      EventModel(
        id: '6',
        title: 'Comedy Night',
        description: 'Stand-up comedy with popular comedians',
        imageUrl: 'https://picsum.photos/800/500?random=6',
        categories: ['Entertainment', 'Comedy'],
        location: 'Comedy Club',
        startDate: DateTime.now().add(const Duration(days: 5)),
        endDate: DateTime.now().add(const Duration(days: 5, hours: 3)),
        price: 30.00,
        maxAttendees: 150,
        attendees: 120,
        latitude: 40.7128,
        longitude: -74.0060,
        organizer: 'Laughs Inc',
        rating: 4.7,
        reviewCount: 180,
        tags: ['comedy', 'entertainment', 'nightlife'],
        metadata: {
          'featured': true,
        },
      ),
      EventModel(
        id: '7',
        title: 'Charity Run',
        description: '5K run for charity fundraising',
        imageUrl: 'https://picsum.photos/800/500?random=7',
        categories: ['Sports', 'Charity'],
        location: 'City Park',
        startDate: DateTime.now().add(const Duration(days: 28)),
        endDate: DateTime.now().add(const Duration(days: 28, hours: 4)),
        price: 20.00,
        maxAttendees: 500,
        attendees: 350,
        latitude: 40.7128,
        longitude: -74.0060,
        organizer: 'Charity Foundation',
        rating: 4.9,
        reviewCount: 320,
        tags: ['charity', 'run', 'fitness'],
        metadata: {
          'featured': false,
        },
      ),
      EventModel(
        id: '8',
        title: 'Book Fair',
        description: 'Annual book fair with author signings',
        imageUrl: 'https://picsum.photos/800/500?random=8',
        categories: ['Education', 'Books'],
        location: 'Public Library',
        startDate: DateTime.now().add(const Duration(days: 18)),
        endDate: DateTime.now().add(const Duration(days: 20)),
        price: 5.00,
        maxAttendees: 1000,
        attendees: 600,
        latitude: 40.7128,
        longitude: -74.0060,
        organizer: 'Bookworms',
        rating: 4.4,
        reviewCount: 280,
        tags: ['books', 'education', 'authors'],
        metadata: {
          'featured': true,
        },
      ),
    ];
  }

  /// Get events marked as featured
  static List<EventModel> getFeaturedEvents() {
    return getMockEvents()
        .where((event) =>
            event.metadata != null && event.metadata!['featured'] == true)
        .toList();
  }

  /// Get upcoming events (soonest first)
  static List<EventModel> getUpcomingEvents() {
    final now = DateTime.now();
    final events =
        getMockEvents().where((event) => event.startDate.isAfter(now)).toList();

    events.sort((a, b) => a.startDate.compareTo(b.startDate));
    return events;
  }

  /// Get events by category
  static List<EventModel> getEventsByCategory(String category) {
    return getMockEvents()
        .where((event) => event.categories
            .any((c) => c.toLowerCase() == category.toLowerCase()))
        .toList();
  }
}
