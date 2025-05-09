import 'package:hive/hive.dart';
import '../../../core/errors/exceptions.dart';
import '../../models/event_model.dart';

abstract class EventLocalDataSource {
  Future<List<EventModel>> getUserEvents();
  Future<EventModel> createEvent(EventModel event);
  Future<void> deleteEvent(String eventId);
  Future<EventModel> updateEvent(EventModel event);
}

class EventLocalDataSourceImpl implements EventLocalDataSource {
  final Box<EventModel> eventsBox;

  EventLocalDataSourceImpl({required this.eventsBox});

  @override
  Future<List<EventModel>> getUserEvents() async {
    try {
      return eventsBox.values.toList();
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<EventModel> createEvent(EventModel event) async {
    try {
      await eventsBox.put(event.id, event);
      return event;
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> deleteEvent(String eventId) async {
    try {
      await eventsBox.delete(eventId);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<EventModel> updateEvent(EventModel event) async {
    try {
      await eventsBox.put(event.id, event);
      return event;
    } catch (e) {
      throw CacheException();
    }
  }
}
