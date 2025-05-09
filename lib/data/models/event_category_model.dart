import 'package:equatable/equatable.dart';
import '../../domain/entities/event_category.dart';

class EventCategoryModel extends EventCategory {
  const EventCategoryModel({
    required super.id,
    required super.name,
    required super.icon,
    required super.color,
  });

  factory EventCategoryModel.fromJson(Map<String, dynamic> json) {
    return EventCategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
      color: json['color'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'color': color,
    };
  }

  factory EventCategoryModel.fromEntity(EventCategory category) {
    return EventCategoryModel(
      id: category.id,
      name: category.name,
      icon: category.icon,
      color: category.color,
    );
  }
}
