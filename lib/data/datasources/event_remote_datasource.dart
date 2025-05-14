import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/event.dart';
import '../models/event_model.dart';
import 'dart:math' as Math;

abstract class EventRemoteDataSource {
  Future<List<Event>> getEvents();
  Future<List<Event>> getMyEvents();
  Future<List<Event>> getFeaturedEvents();
  Future<List<Event>> getUpcomingEvents();
  Future<List<Event>> getEventsByCategory(String category);
  Future<List<Event>> searchEvents(String query);
  Future<Event> getEventById(String id);
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
  Future<void> joinEvent(String eventId);
  Future<void> leaveEvent(String eventId);
  Future<List<Event>> getNearbyEvents({
    required double latitude,
    required double longitude,
    required double radius,
  });
  Future<List<Event>> getRecommendedEvents();
  Future<List<Event>> getTrendingEvents();
  Future<List<Event>> getFriendsEvents();
  Future<List<Event>> getAllEvents();
}

class EventRemoteDataSourceImpl implements EventRemoteDataSource {
  final FirebaseFirestore _firestore;
  final String _currentUserId;

  EventRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
    required String currentUserId,
  })  : _firestore = firestore,
        _currentUserId = currentUserId;

  @override
  Future<List<Event>> getEvents() async {
    final snapshot = await _firestore.collection('events').get();
    return snapshot.docs.map((doc) => EventModel.fromJson(doc.data())).toList();
  }

  @override
  Future<List<Event>> getMyEvents() async {
    final snapshot = await _firestore
        .collection('events')
        .where('createdBy', isEqualTo: _currentUserId)
        .get();
    return snapshot.docs.map((doc) => EventModel.fromJson(doc.data())).toList();
  }

  @override
  Future<List<Event>> getFeaturedEvents() async {
    final snapshot = await _firestore
        .collection('events')
        .orderBy('rating', descending: true)
        .limit(5)
        .get();
    return snapshot.docs.map((doc) => EventModel.fromJson(doc.data())).toList();
  }

  @override
  Future<List<Event>> getUpcomingEvents() async {
    final now = DateTime.now();
    final snapshot = await _firestore
        .collection('events')
        .where('start_time', isGreaterThan: now)
        .orderBy('start_time')
        .limit(10)
        .get();
    return snapshot.docs.map((doc) => EventModel.fromJson(doc.data())).toList();
  }

  @override
  Future<List<Event>> getEventsByCategory(String category) async {
    final snapshot = await _firestore
        .collection('events')
        .where('categories', arrayContains: category)
        .get();
    return snapshot.docs.map((doc) => EventModel.fromJson(doc.data())).toList();
  }

  @override
  Future<List<Event>> searchEvents(String query) async {
    final snapshot = await _firestore.collection('events').get();
    final events =
        snapshot.docs.map((doc) => EventModel.fromJson(doc.data())).toList();
    return events.where((event) {
      final lowerQuery = query.toLowerCase();
      return event.title.toLowerCase().contains(lowerQuery) ||
          event.description.toLowerCase().contains(lowerQuery) ||
          event.location.toLowerCase().contains(lowerQuery) ||
          event.categories
              .any((category) => category.toLowerCase().contains(lowerQuery));
    }).toList();
  }

  @override
  Future<Event> getEventById(String id) async {
    final doc = await _firestore.collection('events').doc(id).get();
    if (!doc.exists) {
      throw Exception('Event not found');
    }
    return EventModel.fromJson(doc.data()!);
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
      organizer: _currentUserId,
      rating: 0.0,
      reviewCount: 0,
      tags: [],
      isPrivate: false,
    );

    await _firestore.collection('events').doc(event.id).set(event.toJson());
    return event;
  }

  @override
  Future<Event> updateEvent(Event event) async {
    await _firestore.collection('events').doc(event.id).update(event.toJson());
    return event;
  }

  @override
  Future<void> deleteEvent(String eventId) async {
    await _firestore.collection('events').doc(eventId).delete();
  }

  @override
  Future<void> joinEvent(String eventId) async {
    await _firestore.collection('events').doc(eventId).update({
      'current_attendees': FieldValue.increment(1),
      'attendees': FieldValue.arrayUnion([_currentUserId]),
    });
  }

  @override
  Future<void> leaveEvent(String eventId) async {
    await _firestore.collection('events').doc(eventId).update({
      'current_attendees': FieldValue.increment(-1),
      'attendees': FieldValue.arrayRemove([_currentUserId]),
    });
  }

  @override
  Future<List<Event>> getNearbyEvents({
    required double latitude,
    required double longitude,
    required double radius,
  }) async {
    try {
      // Use mock data instead of Firestore
      // Create mock Kenyan events
      return _createMockEvents(latitude, longitude);
    } catch (e) {
      print('Error getting nearby events: $e');
      return [];
    }
  }

  // Create mock events directly without using Firestore
  List<Event> _createMockEvents(double userLatitude, double userLongitude) {
    final random = Math.Random();
    final List<Event> events = [];

    // Kenyan locations
    final List<Map<String, dynamic>> kenyanLocations = [
      {'name': 'Nairobi', 'lat': -1.286389, 'lng': 36.817223},
      {'name': 'Mombasa', 'lat': -4.039620, 'lng': 39.668121},
      {'name': 'Kisumu', 'lat': -0.091702, 'lng': 34.767956},
      {'name': 'Nakuru', 'lat': -0.303099, 'lng': 36.080025},
      {'name': 'Eldoret', 'lat': 0.520000, 'lng': 35.270000},
      {'name': 'Karen', 'lat': -1.3260, 'lng': 36.7062},
      {'name': 'Kilimani', 'lat': -1.28731, 'lng': 36.77356},
      {'name': 'Westlands', 'lat': -1.2642, 'lng': 36.8039},
    ];

    // Event types
    final List<String> eventTypes = [
      'Music Festival',
      'Food Festival',
      'Cultural Exhibition',
      'Art Gallery',
      'Tech Meetup',
      'Farmers Market',
      'Jazz Night',
      'Poetry Slam',
      'Film Screening'
    ];

    // Images - using picsum for reliability
    final List<String> imageUrls = [
      'https://picsum.photos/800/600?random=1',
      'https://picsum.photos/800/600?random=2',
      'https://picsum.photos/800/600?random=3',
      'https://picsum.photos/800/600?random=4',
      'https://picsum.photos/800/600?random=5',
    ];

    // Create 10 Kenyan events
    for (int i = 0; i < 10; i++) {
      final location = kenyanLocations[random.nextInt(kenyanLocations.length)];
      final eventType = eventTypes[random.nextInt(eventTypes.length)];
      final category =
          eventType.split(' ')[0]; // First word of eventType as category
      final now = DateTime.now();
      final startDate = now.add(Duration(days: random.nextInt(30)));
      final endDate = startDate.add(Duration(hours: 2 + random.nextInt(6)));

      final event = EventModel(
        id: 'kenya-event-${DateTime.now().millisecondsSinceEpoch}-$i',
        title: '$eventType in ${location['name']}',
        description:
            'Experience the best of ${location['name']} with this amazing $eventType. Join us for an unforgettable time!',
        location: '${location['name']}, Kenya',
        startDate: startDate,
        endDate: endDate,
        imageUrl: imageUrls[random.nextInt(imageUrls.length)],
        categories: [category, 'Kenya', 'Featured'],
        price: (random.nextInt(2000) + 500).toDouble(),
        attendees: random.nextInt(300) + 50,
        latitude: location['lat'],
        longitude: location['lng'],
        organizer: 'Spotly Kenya',
        rating: 3.5 + random.nextDouble() * 1.5,
        reviewCount: random.nextInt(100) + 10,
        tags: [
          'kenya',
          'nairobi',
          eventType.toLowerCase().replaceAll(' ', '-')
        ],
        maxAttendees: random.nextInt(500) + 300,
        isPrivate: false,
      );

      events.add(event);
    }

    return events;
  }

  @override
  Future<List<Event>> getRecommendedEvents() async {
    final snapshot = await _firestore
        .collection('events')
        .orderBy('rating', descending: true)
        .limit(10)
        .get();
    return snapshot.docs.map((doc) => EventModel.fromJson(doc.data())).toList();
  }

  @override
  Future<List<Event>> getTrendingEvents() async {
    final snapshot = await _firestore
        .collection('events')
        .orderBy('current_attendees', descending: true)
        .limit(10)
        .get();
    return snapshot.docs.map((doc) => EventModel.fromJson(doc.data())).toList();
  }

  @override
  Future<List<Event>> getFriendsEvents() async {
    // TODO: Implement with actual friends list
    final snapshot = await _firestore
        .collection('events')
        .where('attendees', arrayContains: _currentUserId)
        .orderBy('start_time', descending: false)
        .limit(10)
        .get();
    return snapshot.docs.map((doc) => EventModel.fromJson(doc.data())).toList();
  }

  @override
  Future<List<Event>> getAllEvents() async {
    final snapshot = await _firestore.collection('events').get();
    return snapshot.docs.map((doc) => EventModel.fromJson(doc.data())).toList();
  }
}
