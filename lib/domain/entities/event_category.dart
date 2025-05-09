import 'package:equatable/equatable.dart';

class EventCategory extends Equatable {
  final String id;
  final String name;
  final String icon;
  final String color;

  const EventCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'color': color,
    };
  }

  @override
  List<Object> get props => [id, name, icon, color];
}
