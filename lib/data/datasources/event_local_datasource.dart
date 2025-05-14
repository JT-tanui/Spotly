import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/event.dart';
import '../models/event_model.dart';

abstract class EventLocalDataSource {
  Future<void> cacheEvents(List<Event> events);
  Future<List<Event>> getCachedEvents();
  Future<void> cacheMyEvents(List<Event> events);
  Future<List<Event>> getCachedMyEvents();
  Future<List<Event>> getFeaturedEvents();
  Future<List<Event>> getUpcomingEvents();
  Future<List<Event>> getEventsByCategory(String category);
  Future<List<Event>> searchEvents(String query);
  Future<Event> getEventById(String id);
  Future<List<Event>> getAllEvents();
  Future<Event> createEvent({
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
  Future<Event> updateEvent(Event event);
  Future<void> deleteEvent(String eventId);
}

class EventLocalDataSourceImpl implements EventLocalDataSource {
  final Box<dynamic> _eventBox;
  final SharedPreferences _sharedPreferences;

  // Keys for storing in the box or shared preferences
  static const String _cachedEventsKey = 'CACHED_EVENTS';
  static const String _cachedMyEventsKey = 'CACHED_MY_EVENTS';

  EventLocalDataSourceImpl({
    required Box<dynamic> eventBox,
    required SharedPreferences sharedPreferences,
  })  : _eventBox = eventBox,
        _sharedPreferences = sharedPreferences;

  @override
  Future<void> cacheEvents(List<Event> events) async {
    try {
      // Try to use Hive box
      await _eventBox.put(_cachedEventsKey, events);
    } catch (e) {
      // Fallback to SharedPreferences if Hive fails
      final eventsJson = events.map((event) => _eventToJson(event)).toList();
      await _sharedPreferences.setString(
        _cachedEventsKey,
        json.encode(eventsJson),
      );
    }
  }

  @override
  Future<List<Event>> getCachedEvents() async {
    try {
      // Try to get from Hive box
      final events = _eventBox.get(_cachedEventsKey);
      if (events != null) {
        return events as List<Event>;
      }
    } catch (e) {
      // Fallback to SharedPreferences
      final jsonString = _sharedPreferences.getString(_cachedEventsKey);
      if (jsonString != null) {
        final List<dynamic> decodedJson = json.decode(jsonString);
        return decodedJson.map((e) => _eventFromJson(e)).toList();
      }
    }
    // Return empty list if no cached data is found
    return [];
  }

  @override
  Future<void> cacheMyEvents(List<Event> events) async {
    try {
      // Try to use Hive box
      await _eventBox.put(_cachedMyEventsKey, events);
    } catch (e) {
      // Fallback to SharedPreferences if Hive fails
      final eventsJson = events.map((event) => _eventToJson(event)).toList();
      await _sharedPreferences.setString(
        _cachedMyEventsKey,
        json.encode(eventsJson),
      );
    }
  }

  @override
  Future<List<Event>> getCachedMyEvents() async {
    try {
      // Try to get from Hive box
      final events = _eventBox.get(_cachedMyEventsKey);
      if (events != null) {
        return events as List<Event>;
      }
    } catch (e) {
      // Fallback to SharedPreferences
      final jsonString = _sharedPreferences.getString(_cachedMyEventsKey);
      if (jsonString != null) {
        final List<dynamic> decodedJson = json.decode(jsonString);
        return decodedJson.map((e) => _eventFromJson(e)).toList();
      }
    }
    // Return empty list if no cached data is found
    return [];
  }

  @override
  Future<List<Event>> getFeaturedEvents() async {
    // For now, return a subset of cached events as featured
    final events = await getCachedEvents();
    return events.take(5).toList();
  }

  @override
  Future<List<Event>> getUpcomingEvents() async {
    // Get cached events and filter for upcoming ones (start time is in the future)
    final events = await getCachedEvents();
    final now = DateTime.now();
    return events.where((event) => event.startDate.isAfter(now)).toList();
  }

  @override
  Future<List<Event>> getEventsByCategory(String category) async {
    // Get cached events and filter by category
    final events = await getCachedEvents();
    return events
        .where((event) => event.categories.contains(category))
        .toList();
  }

  @override
  Future<List<Event>> searchEvents(String query) async {
    // Get cached events and filter by query text
    final events = await getCachedEvents();
    final lowerQuery = query.toLowerCase();
    return events.where((event) {
      return event.title.toLowerCase().contains(lowerQuery) ||
          event.description.toLowerCase().contains(lowerQuery) ||
          event.location.toLowerCase().contains(lowerQuery) ||
          event.categories
              .any((category) => category.toLowerCase().contains(lowerQuery));
    }).toList();
  }

  @override
  Future<Event> getEventById(String id) async {
    // Get cached events and find by ID
    final events = await getCachedEvents();
    final event = events.firstWhere(
      (event) => event.id == id,
      orElse: () => throw Exception('Event not found'),
    );
    return event;
  }

  @override
  Future<List<Event>> getAllEvents() async {
    // Simply return all cached events
    return getCachedEvents();
  }

  @override
  Future<Event> createEvent({
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

      final events = await getCachedEvents();
      events.add(event);
      await cacheEvents(events);
      return event;
    } catch (e) {
      throw Exception('Failed to create event: $e');
    }
  }

  @override
  Future<Event> updateEvent(Event event) async {
    try {
      final events = await getCachedEvents();
      final index = events.indexWhere((e) => e.id == event.id);
      if (index != -1) {
        events[index] = event;
        await cacheEvents(events);
        return event;
      }
      throw Exception('Event not found');
    } catch (e) {
      throw Exception('Failed to update event: $e');
    }
  }

  @override
  Future<void> deleteEvent(String eventId) async {
    try {
      final events = await getCachedEvents();
      events.removeWhere((event) => event.id == eventId);
      await cacheEvents(events);
    } catch (e) {
      throw Exception('Failed to delete event: $e');
    }
  }

  // Helper methods for JSON conversion (for SharedPreferences)
  Map<String, dynamic> _eventToJson(Event event) {
    return {
      'id': event.id,
      'title': event.title,
      'description': event.description,
      'location': event.location,
      'startDate': event.startDate.toIso8601String(),
      'endDate': event.endDate.toIso8601String(),
      'imageUrl': event.imageUrl,
      'categories': event.categories,
      'price': event.price,
      'maxAttendees': event.maxAttendees,
      'attendees': event.attendees,
      'latitude': event.latitude,
      'longitude': event.longitude,
      'organizer': event.organizer,
      'rating': event.rating,
      'reviewCount': event.reviewCount,
      'tags': event.tags,
      'address': event.address,
      'createdBy': event.createdBy,
      'createdAt': event.createdAt?.toIso8601String(),
      'updatedAt': event.updatedAt?.toIso8601String(),
      'isPrivate': event.isPrivate,
      'contactInfo': event.contactInfo,
      'metadata': event.metadata,
    };
  }

  Event _eventFromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      location: json['location'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      imageUrl: json['imageUrl'],
      categories: (json['categories'] as List<dynamic>).cast<String>(),
      price: json['price'].toDouble(),
      maxAttendees: json['maxAttendees'],
      attendees: json['attendees'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      organizer: json['organizer'],
      rating: json['rating'].toDouble(),
      reviewCount: json['reviewCount'],
      tags: (json['tags'] as List<dynamic>).cast<String>(),
      address: json['address'],
      createdBy: json['createdBy'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      isPrivate: json['isPrivate'] ?? false,
      contactInfo: json['contactInfo'],
      metadata: json['metadata'],
    );
  }
}
