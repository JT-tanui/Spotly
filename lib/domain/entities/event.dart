import 'package:equatable/equatable.dart';
import 'venue.dart';

class Event extends Equatable {
  final String id;
  final String title;
  final String description;
  final String location;
  final String imageUrl;
  final String? category;
  final DateTime startDate;
  final DateTime endDate;
  final double latitude;
  final double longitude;
  final bool isSaved;
  final double price;
  final String? organizer;
  final int attendees;
  final Venue? venue;
  final List<String> categories;
  final List<String> tags;
  final bool isVirtual;
  final String? url;
  final double rating;
  final int reviewCount;
  final String? address;
  final String? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? maxAttendees;
  final bool isPrivate;
  final String? contactInfo;
  final Map<String, dynamic>? metadata;

  const Event({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.imageUrl,
    this.category,
    required this.startDate,
    required this.endDate,
    required this.latitude,
    required this.longitude,
    this.isSaved = false,
    this.price = 0,
    this.organizer,
    this.attendees = 0,
    this.venue,
    this.categories = const [],
    this.tags = const [],
    this.isVirtual = false,
    this.url,
    this.rating = 0,
    this.reviewCount = 0,
    this.address,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.maxAttendees,
    this.isPrivate = false,
    this.contactInfo,
    this.metadata,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        location,
        imageUrl,
        category,
        startDate,
        endDate,
        latitude,
        longitude,
        isSaved,
        price,
        organizer,
        attendees,
        venue,
        categories,
        tags,
        isVirtual,
        url,
        rating,
        reviewCount,
        address,
        createdBy,
        createdAt,
        updatedAt,
        maxAttendees,
        isPrivate,
        contactInfo,
        metadata,
      ];

  // Utility getters
  String get formattedDate {
    final day = startDate.day.toString().padLeft(2, '0');
    final month = startDate.month.toString().padLeft(2, '0');
    final year = startDate.year.toString();
    return "$day/$month/$year";
  }

  String get formattedTime {
    final hour = startDate.hour.toString().padLeft(2, '0');
    final minute = startDate.minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }

  // For serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'location': location,
      'imageUrl': imageUrl,
      'category': category,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'isSaved': isSaved,
      'price': price,
      'organizer': organizer,
      'attendees': attendees,
      'venue': venue,
      'categories': categories,
      'tags': tags,
      'isVirtual': isVirtual,
      'url': url,
      'rating': rating,
      'reviewCount': reviewCount,
      'address': address,
      'createdBy': createdBy,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'maxAttendees': maxAttendees,
      'isPrivate': isPrivate,
      'contactInfo': contactInfo,
      'metadata': metadata,
    };
  }

  // Clone event with changes
  Event copyWith({
    String? id,
    String? title,
    String? description,
    String? location,
    String? imageUrl,
    String? category,
    DateTime? startDate,
    DateTime? endDate,
    double? latitude,
    double? longitude,
    bool? isSaved,
    double? price,
    String? organizer,
    int? attendees,
    Venue? venue,
    List<String>? categories,
    List<String>? tags,
    bool? isVirtual,
    String? url,
    double? rating,
    int? reviewCount,
    String? address,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? maxAttendees,
    bool? isPrivate,
    String? contactInfo,
    Map<String, dynamic>? metadata,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isSaved: isSaved ?? this.isSaved,
      price: price ?? this.price,
      organizer: organizer ?? this.organizer,
      attendees: attendees ?? this.attendees,
      venue: venue ?? this.venue,
      categories: categories ?? this.categories,
      tags: tags ?? this.tags,
      isVirtual: isVirtual ?? this.isVirtual,
      url: url ?? this.url,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      address: address ?? this.address,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      maxAttendees: maxAttendees ?? this.maxAttendees,
      isPrivate: isPrivate ?? this.isPrivate,
      contactInfo: contactInfo ?? this.contactInfo,
      metadata: metadata ?? this.metadata,
    );
  }
}
