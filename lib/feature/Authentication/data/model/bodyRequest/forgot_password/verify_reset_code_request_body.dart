import 'package:json_annotation/json_annotation.dart';

part 'verify_reset_code_request_body.g.dart';

@JsonSerializable()
class VerifyResetCodeRequestBody {
  final String phoneNumber;
  final String code;

  VerifyResetCodeRequestBody({
    required this.phoneNumber,
    required this.code,
  });

  factory VerifyResetCodeRequestBody.fromJson(Map<String, dynamic> json) =>
      _$VerifyResetCodeRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyResetCodeRequestBodyToJson(this);
}
