class UploadReceiptResponse {
  final String? receiptUrl;
  final String? paymentReceiptUrl;
  final String? url;
  final String? message;

  const UploadReceiptResponse({
    this.receiptUrl,
    this.paymentReceiptUrl,
    this.url,
    this.message,
  });

  factory UploadReceiptResponse.fromJson(Map<String, dynamic> json) {
    return UploadReceiptResponse(
      receiptUrl: json['receiptUrl'] as String?,
      paymentReceiptUrl: json['paymentReceiptUrl'] as String?,
      url: json['url'] as String?,
      message: json['message'] as String?,
    );
  }

  /// Returns the first non-empty URL found in the response
  String get effectiveUrl =>
      receiptUrl?.isNotEmpty == true
          ? receiptUrl!
          : paymentReceiptUrl?.isNotEmpty == true
          ? paymentReceiptUrl!
          : url?.isNotEmpty == true
          ? url!
          : '';
}
