// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reset_password_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResetPasswordRequestBody _$ResetPasswordRequestBodyFromJson(
  Map<String, dynamic> json,
) => ResetPasswordRequestBody(
  phoneNumber: json['phoneNumber'] as String,
  code: json['code'] as String,
  newPassword: json['newPassword'] as String,
);

Map<String, dynamic> _$ResetPasswordRequestBodyToJson(
  ResetPasswordRequestBody instance,
) => <String, dynamic>{
  'phoneNumber': instance.phoneNumber,
  'code': instance.code,
  'newPassword': instance.newPassword,
};
