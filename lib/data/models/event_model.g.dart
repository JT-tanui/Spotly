// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EventModelAdapter extends TypeAdapter<EventModel> {
  @override
  final int typeId = 1;

  @override
  EventModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EventModel(
      id: fields[0] as String? ?? '',
      title: fields[1] as String? ?? '',
      description: fields[2] as String? ?? '',
      location: fields[3] as String? ?? '',
      startDate: fields[4] as DateTime? ?? DateTime.now(),
      endDate: fields[5] as DateTime? ?? DateTime.now(),
      imageUrl: fields[6] as String? ?? '',
      categories: (fields[7] as List?)?.cast<String>() ?? [],
      price: fields[8] as double? ?? 0.0,
      maxAttendees: fields[9] as int? ?? 0,
      attendees: fields[10] as int? ?? 0,
      latitude: fields[11] as double? ?? 0.0,
      longitude: fields[12] as double? ?? 0.0,
      organizer: fields[13] as String? ?? '',
      rating: fields[15] as double? ?? 0.0,
      reviewCount: fields[16] as int? ?? 0,
      tags: (fields[17] as List?)?.cast<String>() ?? [],
      address: fields[18] as String?,
      createdBy: fields[19] as String?,
      createdAt: fields[20] as DateTime?,
      updatedAt: fields[21] as DateTime?,
      isPrivate: fields[23] as bool? ?? false,
      contactInfo: fields[24] as String?,
      metadata: (fields[25] as Map?)?.cast<String, dynamic>(),
      category: fields[26] as String?,
      isVirtual: fields[27] as bool? ?? false,
      url: fields[28] as String?,
      venue: fields[29],
    );
  }

  @override
  void write(BinaryWriter writer, EventModel obj) {
    writer
      ..writeByte(29)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.location)
      ..writeByte(4)
      ..write(obj.startDate)
      ..writeByte(5)
      ..write(obj.endDate)
      ..writeByte(6)
      ..write(obj.imageUrl)
      ..writeByte(7)
      ..write(obj.categories)
      ..writeByte(8)
      ..write(obj.price)
      ..writeByte(9)
      ..write(obj.maxAttendees)
      ..writeByte(10)
      ..write(obj.attendees)
      ..writeByte(11)
      ..write(obj.latitude)
      ..writeByte(12)
      ..write(obj.longitude)
      ..writeByte(13)
      ..write(obj.organizer)
      ..writeByte(15)
      ..write(obj.rating)
      ..writeByte(16)
      ..write(obj.reviewCount)
      ..writeByte(17)
      ..write(obj.tags)
      ..writeByte(18)
      ..write(obj.address)
      ..writeByte(19)
      ..write(obj.createdBy)
      ..writeByte(20)
      ..write(obj.createdAt)
      ..writeByte(21)
      ..write(obj.updatedAt)
      ..writeByte(23)
      ..write(obj.isPrivate)
      ..writeByte(24)
      ..write(obj.contactInfo)
      ..writeByte(25)
      ..write(obj.metadata)
      ..writeByte(26)
      ..write(obj.category)
      ..writeByte(27)
      ..write(obj.isVirtual)
      ..writeByte(28)
      ..write(obj.url)
      ..writeByte(29)
      ..write(obj.venue);
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
