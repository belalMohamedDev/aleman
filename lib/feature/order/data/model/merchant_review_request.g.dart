// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_review_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MerchantReviewRequest _$MerchantReviewRequestFromJson(
  Map<String, dynamic> json,
) => MerchantReviewRequest(
  isApproved: json['isApproved'] as bool,
  rejectionReason: json['rejectionReason'] as String?,
);

Map<String, dynamic> _$MerchantReviewRequestToJson(
  MerchantReviewRequest instance,
) => <String, dynamic>{
  'isApproved': instance.isApproved,
  'rejectionReason': instance.rejectionReason,
};
