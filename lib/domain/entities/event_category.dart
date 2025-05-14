import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

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

  @override
  List<Object?> get props => [id, name, icon, color];

  Color get colorValue {
    try {
      return Color(int.parse(color, radix: 16) | 0xFF000000);
    } catch (e) {
      return Colors.grey;
    }
  }

  IconData get iconData {
    switch (icon) {
      case 'music_note':
        return Icons.music_note;
      case 'code':
        return Icons.code;
      case 'business':
        return Icons.business;
      case 'restaurant':
        return Icons.restaurant;
      case 'sports_soccer':
        return Icons.sports_soccer;
      case 'palette':
        return Icons.palette;
      case 'school':
        return Icons.school;
      case 'fitness_center':
        return Icons.fitness_center;
      case 'volunteer_activism':
        return Icons.volunteer_activism;
      case 'celebration':
        return Icons.celebration;
      case 'local_bar':
        return Icons.local_bar;
      case 'movie':
        return Icons.movie;
      case 'nature':
        return Icons.nature;
      case 'family_restroom':
        return Icons.family_restroom;
      default:
        return Icons.event;
    }
  }

  // Factory method to create a category from a map
  factory EventCategory.fromJson(Map<String, dynamic> json) {
    return EventCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
      color: json['color'] as String,
    );
  }

  // Method to convert category to a map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'color': color,
    };
  }

  // List of predefined categories
  static List<EventCategory> predefinedCategories = [
    const EventCategory(
      id: '1',
      name: 'Music',
      icon: 'music_note',
      color: '9C27B0',
    ),
    const EventCategory(
      id: '2',
      name: 'Technology',
      icon: 'code',
      color: '2196F3',
    ),
    const EventCategory(
      id: '3',
      name: 'Business',
      icon: 'business',
      color: '607D8B',
    ),
    const EventCategory(
      id: '4',
      name: 'Food',
      icon: 'restaurant',
      color: 'FF9800',
    ),
    const EventCategory(
      id: '5',
      name: 'Sports',
      icon: 'sports_soccer',
      color: '4CAF50',
    ),
    const EventCategory(
      id: '6',
      name: 'Art',
      icon: 'palette',
      color: 'E91E63',
    ),
    const EventCategory(
      id: '7',
      name: 'Education',
      icon: 'school',
      color: '3F51B5',
    ),
    const EventCategory(
      id: '8',
      name: 'Health',
      icon: 'fitness_center',
      color: '009688',
    ),
    const EventCategory(
      id: '9',
      name: 'Charity',
      icon: 'volunteer_activism',
      color: 'F44336',
    ),
    const EventCategory(
      id: '10',
      name: 'Party',
      icon: 'celebration',
      color: 'FFC107',
    ),
    const EventCategory(
      id: '11',
      name: 'Nightlife',
      icon: 'local_bar',
      color: '795548',
    ),
    const EventCategory(
      id: '12',
      name: 'Entertainment',
      icon: 'movie',
      color: 'FF5722',
    ),
    const EventCategory(
      id: '13',
      name: 'Outdoor',
      icon: 'nature',
      color: '8BC34A',
    ),
    const EventCategory(
      id: '14',
      name: 'Family',
      icon: 'family_restroom',
      color: '00BCD4',
    ),
    const EventCategory(
      id: '15',
      name: 'Other',
      icon: 'event',
      color: '9E9E9E',
    ),
  ];

  // Method to find a category by name
  static EventCategory findByName(String name) {
    return predefinedCategories.firstWhere(
      (category) => category.name == name,
      orElse: () => predefinedCategories.last, // Return 'Other' if not found
    );
  }
}
