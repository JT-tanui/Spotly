import 'package:equatable/equatable.dart';
import 'event_category.dart';

class Event extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final double latitude;
  final double longitude;
  final String address;
  final String? imageUrl;
  final String createdBy;
  final DateTime createdAt;
  final List<EventCategory> categories;
  final int? maxAttendees;
  final double? price;
  final bool isPrivate;
  final String? contactInfo;

  const Event({
    required this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.latitude,
    required this.longitude,
    required this.address,
    this.imageUrl,
    required this.createdBy,
    required this.createdAt,
    required this.categories,
    this.maxAttendees,
    this.price,
    this.isPrivate = false,
    this.contactInfo,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        startTime,
        endTime,
        latitude,
        longitude,
        address,
        imageUrl,
        createdBy,
        createdAt,
        categories,
        maxAttendees,
        price,
        isPrivate,
        contactInfo,
      ];
}
