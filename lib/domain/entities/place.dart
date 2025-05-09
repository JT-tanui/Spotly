import 'package:equatable/equatable.dart';

class Place extends Equatable {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String? photoReference;
  final double? rating;
  final List<String> types;

  const Place({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.photoReference,
    this.rating,
    required this.types,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    address,
    latitude,
    longitude,
    photoReference,
    rating,
    types,
  ];
}
