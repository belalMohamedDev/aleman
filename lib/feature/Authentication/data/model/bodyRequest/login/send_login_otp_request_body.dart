class SendLoginOtpRequestBody {
  final String phoneNumber;

  const SendLoginOtpRequestBody({required this.phoneNumber});

  Map<String, dynamic> toJson() => {
    'phoneNumber': phoneNumber,
  };

  factory SendLoginOtpRequestBody.fromJson(Map<String, dynamic> json) =>
      SendLoginOtpRequestBody(
        phoneNumber: json['phoneNumber'] as String,
      );
}
