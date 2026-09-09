// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_token_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterTokenRequestBody _$RegisterTokenRequestBodyFromJson(
  Map<String, dynamic> json,
) => RegisterTokenRequestBody(
  fcmToken: json['fcmToken'] as String,
  deviceType: json['deviceType'] as String,
  deviceId: json['deviceId'] as String?,
  appVersion: json['appVersion'] as String?,
);

Map<String, dynamic> _$RegisterTokenRequestBodyToJson(
  RegisterTokenRequestBody instance,
) => <String, dynamic>{
  'fcmToken': instance.fcmToken,
  'deviceType': instance.deviceType,
  'deviceId': instance.deviceId,
  'appVersion': instance.appVersion,
};
