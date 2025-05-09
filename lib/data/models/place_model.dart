import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/place.dart';

part 'place_model.g.dart';

@JsonSerializable()
class PlaceModel extends Place {
  const PlaceModel({
    required String id,
    required String name,
    required String address,
    required double latitude,
    required double longitude,
    String? photoReference,
    double? rating,
    required List<String> types,
  }) : super(
          id: id,
          name: name,
          address: address,
          latitude: latitude,
          longitude: longitude,
          photoReference: photoReference,
          rating: rating,
          types: types,
        );

  factory PlaceModel.fromJson(Map<String, dynamic> json) =>
      _$PlaceModelFromJson(json);

  Map<String, dynamic> toJson() => _$PlaceModelToJson(this);
}
