import 'package:spotly/core/errors/exceptions.dart';
import 'package:spotly/data/models/event_model.dart';

abstract class EventRemoteDataSource {
  Future<List<EventModel>> getFeaturedEvents({int? page, int? pageSize});
  Future<List<EventModel>> getUpcomingEvents({int? page, int? pageSize});
  Future<List<EventModel>> getEventsByCategory(String category,
      {int? page, int? pageSize});
  Future<List<EventModel>> searchEvents(String query,
      {int? page, int? pageSize});
  Future<EventModel> getEventById(String id);
  Future<EventModel> createEvent({
    required String title,
    required String description,
    required String location,
    required DateTime startTime,
    required DateTime endTime,
    required String imageUrl,
    required List<String> categories,
    required double price,
    required int capacity,
  });
  Future<EventModel> updateEvent(EventModel event);
  Future<void> deleteEvent(String id);
  Future<List<EventModel>> getAllEvents({int? page, int? pageSize});
}

class EventRemoteDataSourceImpl implements EventRemoteDataSource {
  // TODO: Add HTTP client and base URL
  // final http.Client client;
  // final String baseUrl;

  // EventRemoteDataSourceImpl({
  //   required this.client,
  //   required this.baseUrl,
  // });

  @override
  Future<List<EventModel>> getFeaturedEvents({int? page, int? pageSize}) async {
    try {
      // TODO: Implement API call
      throw UnimplementedError('API not implemented yet');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<EventModel>> getUpcomingEvents({int? page, int? pageSize}) async {
    try {
      // TODO: Implement API call
      throw UnimplementedError('API not implemented yet');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<EventModel>> getEventsByCategory(String category,
      {int? page, int? pageSize}) async {
    try {
      // TODO: Implement API call
      throw UnimplementedError('API not implemented yet');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<EventModel>> searchEvents(String query,
      {int? page, int? pageSize}) async {
    try {
      // TODO: Implement API call
      throw UnimplementedError('API not implemented yet');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<EventModel> getEventById(String id) async {
    try {
      // TODO: Implement API call
      throw UnimplementedError('API not implemented yet');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<EventModel> createEvent({
    required String title,
    required String description,
    required String location,
    required DateTime startTime,
    required DateTime endTime,
    required String imageUrl,
    required List<String> categories,
    required double price,
    required int capacity,
  }) async {
    try {
      // TODO: Implement API call
      throw UnimplementedError('API not implemented yet');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<EventModel> updateEvent(EventModel event) async {
    try {
      // TODO: Implement API call
      throw UnimplementedError('API not implemented yet');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> deleteEvent(String id) async {
    try {
      // TODO: Implement API call
      throw UnimplementedError('API not implemented yet');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<EventModel>> getAllEvents({int? page, int? pageSize}) async {
    try {
      // TODO: Implement API call
      throw UnimplementedError('API not implemented yet');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
