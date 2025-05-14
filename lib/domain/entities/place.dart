import 'package:equatable/equatable.dart';

class Place extends Equatable {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String category;
  final String address;
  final double rating;
  final double latitude;
  final double longitude;
  final List<String> photos;
  final String? photoReference;
  final List<String>? types;
  final Map<String, dynamic>? metadata;

  const Place({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.address,
    required this.rating,
    required this.latitude,
    required this.longitude,
    this.photos = const [],
    this.photoReference,
    this.types,
    this.metadata,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        imageUrl,
        category,
        address,
        rating,
        latitude,
        longitude,
        photos,
        photoReference,
        types,
        metadata,
      ];
}
