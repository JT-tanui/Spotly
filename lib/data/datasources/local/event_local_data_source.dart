import 'package:hive/hive.dart';
import '../../../core/errors/exceptions.dart';
import '../../models/event_model.dart';
import '../mock/mock_event_data.dart';

abstract class EventLocalDataSource {
  Future<List<EventModel>> getFeaturedEvents();
  Future<List<EventModel>> getUpcomingEvents();
  Future<List<EventModel>> getEventsByCategory(String category);
  Future<List<EventModel>> searchEvents(String query);
  Future<EventModel> getEventById(String id);
  Future<EventModel> createEvent({
    required String title,
    required String description,
    required String location,
    required DateTime startDate,
    required DateTime endDate,
    required String imageUrl,
    required List<String> categories,
    required double price,
    required int maxAttendees,
  });
  Future<EventModel> updateEvent(EventModel event);
  Future<void> deleteEvent(String id);
  Future<List<EventModel>> getAllEvents();
}

class EventLocalDataSourceImpl implements EventLocalDataSource {
  final Box<EventModel> eventsBox;
  final bool useMockData;

  EventLocalDataSourceImpl({
    required this.eventsBox,
    this.useMockData =
        true, // Use mock data by default until real data is available
  });

  @override
  Future<List<EventModel>> getFeaturedEvents() async {
    try {
      if (useMockData) {
        return MockEventData.getFeaturedEvents();
      }

      // For demonstration, consider the top 5 events as featured
      final allEvents = eventsBox.values.toList();
      // Sort by rating
      allEvents.sort((a, b) => b.rating.compareTo(a.rating));
      // Return top 5 or fewer if less are available
      return allEvents.take(5).toList();
    } catch (e) {
      throw CacheException(
          message: 'Failed to get featured events: ${e.toString()}');
    }
  }

  @override
  Future<List<EventModel>> getUpcomingEvents() async {
    try {
      if (useMockData) {
        return MockEventData.getUpcomingEvents();
      }

      final now = DateTime.now();
      // Filter events that are in the future
      final upcomingEvents = eventsBox.values
          .where((event) => event.startDate.isAfter(now))
          .toList();
      // Sort by start time (earliest first)
      upcomingEvents.sort((a, b) => a.startDate.compareTo(b.startDate));
      return upcomingEvents;
    } catch (e) {
      throw CacheException(
          message: 'Failed to get upcoming events: ${e.toString()}');
    }
  }

  @override
  Future<List<EventModel>> getEventsByCategory(String category) async {
    try {
      if (useMockData) {
        return MockEventData.getEventsByCategory(category);
      }

      return eventsBox.values
          .where((event) => event.categories
              .any((c) => c.toLowerCase() == category.toLowerCase()))
          .toList();
    } catch (e) {
      throw CacheException(
          message: 'Failed to get events by category: ${e.toString()}');
    }
  }

  @override
  Future<List<EventModel>> searchEvents(String query) async {
    try {
      if (useMockData) {
        final lowercaseQuery = query.toLowerCase();
        return MockEventData.getMockEvents()
            .where((event) =>
                event.title.toLowerCase().contains(lowercaseQuery) ||
                event.description.toLowerCase().contains(lowercaseQuery) ||
                event.location.toLowerCase().contains(lowercaseQuery) ||
                event.categories.any((category) =>
                    category.toLowerCase().contains(lowercaseQuery)) ||
                event.tags
                    .any((tag) => tag.toLowerCase().contains(lowercaseQuery)))
            .toList();
      }

      final lowercaseQuery = query.toLowerCase();
      return eventsBox.values
          .where((event) =>
              event.title.toLowerCase().contains(lowercaseQuery) ||
              event.description.toLowerCase().contains(lowercaseQuery) ||
              event.location.toLowerCase().contains(lowercaseQuery) ||
              event.categories.any((category) =>
                  category.toLowerCase().contains(lowercaseQuery)) ||
              event.tags
                  .any((tag) => tag.toLowerCase().contains(lowercaseQuery)))
          .toList();
    } catch (e) {
      throw CacheException(message: 'Failed to search events: ${e.toString()}');
    }
  }

  @override
  Future<EventModel> getEventById(String id) async {
    try {
      if (useMockData) {
        final event = MockEventData.getMockEvents().firstWhere(
          (event) => event.id == id,
          orElse: () =>
              throw CacheException(message: 'Event not found with ID: $id'),
        );
        return event;
      }

      final event = eventsBox.values.firstWhere(
        (event) => event.id == id,
        orElse: () =>
            throw CacheException(message: 'Event not found with ID: $id'),
      );
      return event;
    } catch (e) {
      throw CacheException(
          message: 'Failed to get event by ID: ${e.toString()}');
    }
  }

  @override
  Future<EventModel> createEvent({
    required String title,
    required String description,
    required String location,
    required DateTime startDate,
    required DateTime endDate,
    required String imageUrl,
    required List<String> categories,
    required double price,
    required int maxAttendees,
  }) async {
    try {
      if (useMockData) {
        // Just pretend we saved it - return a mock event
        return EventModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
          description: description,
          location: location,
          startDate: startDate,
          endDate: endDate,
          imageUrl: imageUrl,
          categories: categories,
          price: price,
          maxAttendees: maxAttendees,
          attendees: 0,
          latitude: 0.0,
          longitude: 0.0,
          organizer: 'Mock Organizer',
          rating: 0.0,
          reviewCount: 0,
          tags: [],
          isPrivate: false,
        );
      }

      final event = EventModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        description: description,
        location: location,
        startDate: startDate,
        endDate: endDate,
        imageUrl: imageUrl,
        categories: categories,
        price: price,
        maxAttendees: maxAttendees,
        attendees: 0,
        latitude: 0.0,
        longitude: 0.0,
        organizer: 'Local Organizer',
        rating: 0.0,
        reviewCount: 0,
        tags: [],
        isPrivate: false,
      );

      await eventsBox.put(event.id, event);
      return event;
    } catch (e) {
      throw CacheException(message: 'Failed to create event: ${e.toString()}');
    }
  }

  @override
  Future<EventModel> updateEvent(EventModel event) async {
    try {
      if (useMockData) {
        // Just pretend we updated it - return the same event
        return event;
      }

      if (!eventsBox.containsKey(event.id)) {
        throw CacheException(message: 'Event not found with ID: ${event.id}');
      }
      await eventsBox.put(event.id, event);
      return event;
    } catch (e) {
      throw CacheException(message: 'Failed to update event: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteEvent(String id) async {
    try {
      if (useMockData) {
        // Just pretend we deleted it
        return;
      }

      if (!eventsBox.containsKey(id)) {
        throw CacheException(message: 'Event not found with ID: $id');
      }
      await eventsBox.delete(id);
    } catch (e) {
      throw CacheException(message: 'Failed to delete event: ${e.toString()}');
    }
  }

  @override
  Future<List<EventModel>> getAllEvents() async {
    try {
      if (useMockData) {
        return MockEventData.getMockEvents();
      }

      return eventsBox.values.toList();
    } catch (e) {
      throw CacheException(
          message: 'Failed to get all events: ${e.toString()}');
    }
  }
}
