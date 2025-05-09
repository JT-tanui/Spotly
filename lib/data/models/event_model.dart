import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import '../../domain/entities/event.dart';
import '../../domain/entities/event_category.dart';
import 'event_category_model.dart';

part 'event_model.g.dart';

@HiveType(typeId: 0)
class EventModel extends Event {
  const EventModel({
    required super.id,
    required super.title,
    required super.description,
    required super.startTime,
    required super.endTime,
    required super.latitude,
    required super.longitude,
    required super.address,
    super.imageUrl,
    required super.createdBy,
    required super.createdAt,
    required super.categories,
    super.maxAttendees,
    super.price,
    super.isPrivate = false,
    super.contactInfo,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    final categoriesList = (json['categories'] as List<dynamic>?) ?? [];
    final categories = categoriesList.map((category) {
      if (category is Map<String, dynamic>) {
        return EventCategoryModel.fromJson(category);
      }
      throw FormatException('Invalid category format in JSON');
    }).toList();

    return EventModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      startTime: DateTime.parse(json['start_time'] as String),
      endTime: DateTime.parse(json['end_time'] as String),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'] as String,
      imageUrl: json['image_url'] as String?,
      createdBy: json['created_by'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      categories: categories,
      maxAttendees: json['max_attendees'] as int?,
      price: json['price'] != null ? (json['price'] as num).toDouble() : null,
      isPrivate: json['is_private'] as bool? ?? false,
      contactInfo: json['contact_info'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'image_url': imageUrl,
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
      'categories': categories.map((category) {
        if (category is EventCategoryModel) {
          return category.toJson();
        }
        return EventCategoryModel.fromEntity(category).toJson();
      }).toList(),
      'max_attendees': maxAttendees,
      'price': price,
      'is_private': isPrivate,
      'contact_info': contactInfo,
    };
  }

  factory EventModel.fromEntity(Event event) {
    return EventModel(
      id: event.id,
      title: event.title,
      description: event.description,
      startTime: event.startTime,
      endTime: event.endTime,
      latitude: event.latitude,
      longitude: event.longitude,
      address: event.address,
      imageUrl: event.imageUrl,
      createdBy: event.createdBy,
      createdAt: event.createdAt,
      categories: event.categories.map((category) {
        if (category is EventCategoryModel) {
          return category;
        }
        return EventCategoryModel.fromEntity(category);
      }).toList(),
      maxAttendees: event.maxAttendees,
      price: event.price,
      isPrivate: event.isPrivate,
      contactInfo: event.contactInfo,
    );
  }
}
