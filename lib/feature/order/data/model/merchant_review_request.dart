import 'package:json_annotation/json_annotation.dart';

part 'merchant_review_request.g.dart';

@JsonSerializable()
class MerchantReviewRequest {
  final bool isApproved;
  final String? rejectionReason;

  const MerchantReviewRequest({
    required this.isApproved,
    this.rejectionReason,
  });

  factory MerchantReviewRequest.fromJson(Map<String, dynamic> json) =>
      _$MerchantReviewRequestFromJson(json);

  Map<String, dynamic> toJson() => _$MerchantReviewRequestToJson(this);
}
