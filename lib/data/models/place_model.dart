import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/place.dart';

part 'place_model.g.dart';

@JsonSerializable()
class PlaceModel extends Place {
  const PlaceModel({
    required String id,
    required String name,
    required String description,
    required String imageUrl,
    required String category,
    required String address,
    required double rating,
    required double latitude,
    required double longitude,
    List<String> photos = const [],
    String? photoReference,
    List<String>? types,
    Map<String, dynamic>? metadata,
  }) : super(
          id: id,
          name: name,
          description: description,
          imageUrl: imageUrl,
          category: category,
          address: address,
          rating: rating,
          latitude: latitude,
          longitude: longitude,
          photos: photos,
          photoReference: photoReference,
          types: types,
          metadata: metadata,
        );

  factory PlaceModel.fromJson(Map<String, dynamic> json) =>
      _$PlaceModelFromJson(json);

  Map<String, dynamic> toJson() => _$PlaceModelToJson(this);
}
