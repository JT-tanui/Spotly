// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EventModelAdapter extends TypeAdapter<EventModel> {
  @override
  final int typeId = 0;

  @override
  EventModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EventModel(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      startTime: fields[3] as DateTime,
      endTime: fields[4] as DateTime,
      latitude: fields[5] as double,
      longitude: fields[6] as double,
      address: fields[7] as String,
      imageUrl: fields[8] as String?,
      createdBy: fields[9] as String,
      createdAt: fields[10] as DateTime,
      categories: (fields[11] as List).cast<EventCategoryModel>(),
      maxAttendees: fields[12] as int?,
      price: fields[13] as double?,
      isPrivate: fields[14] as bool,
      contactInfo: fields[15] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, EventModel obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.startTime)
      ..writeByte(4)
      ..write(obj.endTime)
      ..writeByte(5)
      ..write(obj.latitude)
      ..writeByte(6)
      ..write(obj.longitude)
      ..writeByte(7)
      ..write(obj.address)
      ..writeByte(8)
      ..write(obj.imageUrl)
      ..writeByte(9)
      ..write(obj.createdBy)
      ..writeByte(10)
      ..write(obj.createdAt)
      ..writeByte(11)
      ..write(obj.categories)
      ..writeByte(12)
      ..write(obj.maxAttendees)
      ..writeByte(13)
      ..write(obj.price)
      ..writeByte(14)
      ..write(obj.isPrivate)
      ..writeByte(15)
      ..write(obj.contactInfo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventModel _$EventModelFromJson(Map<String, dynamic> json) => EventModel(
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
      categories: (json['categories'] as List<dynamic>)
          .map((e) => EventCategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      maxAttendees: json['max_attendees'] as int?,
      price: (json['price'] as num?)?.toDouble(),
      isPrivate: json['is_private'] as bool? ?? false,
      contactInfo: json['contact_info'] as String?,
    );

Map<String, dynamic> _$EventModelToJson(EventModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'start_time': instance.startTime.toIso8601String(),
      'end_time': instance.endTime.toIso8601String(),
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'address': instance.address,
      'image_url': instance.imageUrl,
      'created_by': instance.createdBy,
      'created_at': instance.createdAt.toIso8601String(),
      'categories': instance.categories.map((e) => e.toJson()).toList(),
      'max_attendees': instance.maxAttendees,
      'price': instance.price,
      'is_private': instance.isPrivate,
      'contact_info': instance.contactInfo,
    };
