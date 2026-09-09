import 'package:json_annotation/json_annotation.dart';

part 'register_token_request_body.g.dart';

@JsonSerializable()
class RegisterTokenRequestBody {
  final String fcmToken;
  final String deviceType;
  final String? deviceId;
  final String? appVersion;

  const RegisterTokenRequestBody({
    required this.fcmToken,
    required this.deviceType,
    this.deviceId,
    this.appVersion,
  });

  factory RegisterTokenRequestBody.fromJson(Map<String, dynamic> json) =>
      _$RegisterTokenRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterTokenRequestBodyToJson(this);
}
