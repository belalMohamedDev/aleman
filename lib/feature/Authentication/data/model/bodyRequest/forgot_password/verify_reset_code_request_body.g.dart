// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_reset_code_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyResetCodeRequestBody _$VerifyResetCodeRequestBodyFromJson(
  Map<String, dynamic> json,
) => VerifyResetCodeRequestBody(
  phoneNumber: json['phoneNumber'] as String,
  code: json['code'] as String,
);

Map<String, dynamic> _$VerifyResetCodeRequestBodyToJson(
  VerifyResetCodeRequestBody instance,
) => <String, dynamic>{
  'phoneNumber': instance.phoneNumber,
  'code': instance.code,
};
