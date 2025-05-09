import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';
import '../../domain/entities/event.dart';

part 'event_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 0)
class EventModel extends Event {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final DateTime startTime;

  @HiveField(4)
  final DateTime endTime;

  @HiveField(5)
  final double latitude;

  @HiveField(6)
  final double longitude;

  @HiveField(7)
  final String address;

  @HiveField(8)
  final String? imageUrl;

  @HiveField(9)
  final String createdBy;

  @HiveField(10)
  final DateTime createdAt;

  const EventModel({
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
  }) : super(
          id: id,
          title: title,
          description: description,
          startTime: startTime,
          endTime: endTime,
          latitude: latitude,
          longitude: longitude,
          address: address,
          imageUrl: imageUrl,
          createdBy: createdBy,
          createdAt: createdAt,
        );

  factory EventModel.fromJson(Map<String, dynamic> json) =>
      _$EventModelFromJson(json);

  Map<String, dynamic> toJson() => _$EventModelToJson(this);
}
