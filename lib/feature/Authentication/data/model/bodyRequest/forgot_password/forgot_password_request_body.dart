import 'package:json_annotation/json_annotation.dart';

part 'forgot_password_request_body.g.dart';

@JsonSerializable()
class ForgotPasswordRequestBody {
  final String phoneNumber;

  ForgotPasswordRequestBody({required this.phoneNumber});

  factory ForgotPasswordRequestBody.fromJson(Map<String, dynamic> json) =>
      _$ForgotPasswordRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$ForgotPasswordRequestBodyToJson(this);
}
