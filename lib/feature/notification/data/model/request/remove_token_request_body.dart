import 'package:json_annotation/json_annotation.dart';

part 'remove_token_request_body.g.dart';

@JsonSerializable()
class RemoveTokenRequestBody {
  final String fcmToken;

  const RemoveTokenRequestBody({
    required this.fcmToken,
  });

  factory RemoveTokenRequestBody.fromJson(Map<String, dynamic> json) =>
      _$RemoveTokenRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$RemoveTokenRequestBodyToJson(this);
}
