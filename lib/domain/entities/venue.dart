import 'package:equatable/equatable.dart';

class Venue extends Equatable {
  final String id;
  final String name;
  final String description;
  final String address;
  final String imageUrl;
  final double latitude;
  final double longitude;
  final String? phone;
  final String? website;
  final List<String> categories;
  final double rating;
  final int reviewCount;
  final Map<String, dynamic>? openingHours;
  final bool isVerified;
  final bool isClaimed;
  final bool isSaved;

  const Venue({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
    this.phone,
    this.website,
    this.categories = const [],
    this.rating = 0,
    this.reviewCount = 0,
    this.openingHours,
    this.isVerified = false,
    this.isClaimed = false,
    this.isSaved = false,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        address,
        imageUrl,
        latitude,
        longitude,
        phone,
        website,
        categories,
        rating,
        reviewCount,
        openingHours,
        isVerified,
        isClaimed,
        isSaved,
      ];

  // Get primary category
  String? get primaryCategory =>
      categories.isNotEmpty ? categories.first : null;

  // For serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'address': address,
      'imageUrl': imageUrl,
      'latitude': latitude,
      'longitude': longitude,
      'phone': phone,
      'website': website,
      'categories': categories,
      'rating': rating,
      'reviewCount': reviewCount,
      'openingHours': openingHours,
      'isVerified': isVerified,
      'isClaimed': isClaimed,
      'isSaved': isSaved,
    };
  }

  // Clone venue with changes
  Venue copyWith({
    String? id,
    String? name,
    String? description,
    String? address,
    String? imageUrl,
    double? latitude,
    double? longitude,
    String? phone,
    String? website,
    List<String>? categories,
    double? rating,
    int? reviewCount,
    Map<String, dynamic>? openingHours,
    bool? isVerified,
    bool? isClaimed,
    bool? isSaved,
  }) {
    return Venue(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      address: address ?? this.address,
      imageUrl: imageUrl ?? this.imageUrl,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      phone: phone ?? this.phone,
      website: website ?? this.website,
      categories: categories ?? this.categories,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      openingHours: openingHours ?? this.openingHours,
      isVerified: isVerified ?? this.isVerified,
      isClaimed: isClaimed ?? this.isClaimed,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}
