import 'package:equatable/equatable.dart';

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
      ];
}
