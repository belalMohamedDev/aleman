class VerifyLoginOtpRequestBody {
  final String phoneNumber;
  final String code;

  const VerifyLoginOtpRequestBody({
    required this.phoneNumber,
    required this.code,
  });

  Map<String, dynamic> toJson() => {
    'phoneNumber': phoneNumber,
    'code': code,
  };

  factory VerifyLoginOtpRequestBody.fromJson(Map<String, dynamic> json) =>
      VerifyLoginOtpRequestBody(
        phoneNumber: json['phoneNumber'] as String,
        code: json['code'] as String,
      );
}
