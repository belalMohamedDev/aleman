import 'package:json_annotation/json_annotation.dart';
part 'auth_response.g.dart';

@JsonSerializable()
class AuthResponse {
  String? accessToken;
  String? refreshToken;
  String? role;

  AuthResponse({
    this.accessToken,
    this.refreshToken,
    this.role,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}
