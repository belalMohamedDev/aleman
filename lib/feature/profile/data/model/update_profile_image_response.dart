import 'package:json_annotation/json_annotation.dart';

part 'update_profile_image_response.g.dart';

@JsonSerializable()
class UpdateProfileImageResponse {
  final String message;
  final String? profileImageUrl;

  const UpdateProfileImageResponse({
    required this.message,
    this.profileImageUrl,
  });

  factory UpdateProfileImageResponse.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileImageResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateProfileImageResponseToJson(this);
}
