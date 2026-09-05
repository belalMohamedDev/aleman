import 'package:json_annotation/json_annotation.dart';

part 'logout_body_request.g.dart';

@JsonSerializable()
class LogoutRequestBody {
  final String refreshToken;

  LogoutRequestBody({required this.refreshToken});

  factory LogoutRequestBody.fromJson(Map<String, dynamic> json) =>
      _$LogoutRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$LogoutRequestBodyToJson(this);
}
