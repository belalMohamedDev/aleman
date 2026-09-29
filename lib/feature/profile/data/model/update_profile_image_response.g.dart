// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_profile_image_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateProfileImageResponse _$UpdateProfileImageResponseFromJson(
  Map<String, dynamic> json,
) => UpdateProfileImageResponse(
  message: json['message'] as String,
  profileImageUrl: json['profileImageUrl'] as String?,
);

Map<String, dynamic> _$UpdateProfileImageResponseToJson(
  UpdateProfileImageResponse instance,
) => <String, dynamic>{
  'message': instance.message,
  'profileImageUrl': instance.profileImageUrl,
};
