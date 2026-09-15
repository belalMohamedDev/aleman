class CalculateShippingRequest {
  final String addressId;
  final int truckType;
  final double? totalWeightTons;

  const CalculateShippingRequest({
    required this.addressId,
    required this.truckType,
    this.totalWeightTons,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'addressId': addressId,
      'truckType': truckType,
    };
    if (totalWeightTons != null && totalWeightTons! > 0) {
      map['totalWeightTons'] = totalWeightTons;
    }
    return map;
  }
}

class ShippingPromotionInfo {
  final String? id;
  final String title;
  final double? discountPercentage;
  final double? discountValue;
  final DateTime? endDate;

  const ShippingPromotionInfo({
    this.id,
    required this.title,
    this.discountPercentage,
    this.discountValue,
    this.endDate,
  });

  factory ShippingPromotionInfo.fromJson(Map<String, dynamic> json) =>
      ShippingPromotionInfo(
        id: json['id'] as String?,
        title: json['title'] as String? ?? 'عرض ترويجي',
        discountPercentage: (json['discountPercentage'] as num?)?.toDouble(),
        discountValue: (json['discountValue'] as num?)?.toDouble(),
        endDate: json['endDateUtc'] != null
            ? DateTime.tryParse(json['endDateUtc'] as String)
            : null,
      );
}

class ShippingRecommendationModel {
  final int suggestedTruckType;
  final String suggestedTruckName;
  final int suggestedTruckCount;
  final double suggestedTotalFee;
  final double potentialSavings;
  final String message;

  const ShippingRecommendationModel({
    required this.suggestedTruckType,
    required this.suggestedTruckName,
    required this.suggestedTruckCount,
    required this.suggestedTotalFee,
    required this.potentialSavings,
    required this.message,
  });

  factory ShippingRecommendationModel.fromJson(Map<String, dynamic> json) =>
      ShippingRecommendationModel(
        suggestedTruckType: json['suggestedTruckType'] as int? ?? 1,
        suggestedTruckName: json['suggestedTruckName'] as String? ?? '',
        suggestedTruckCount: json['suggestedTruckCount'] as int? ?? 1,
        suggestedTotalFee: (json['suggestedTotalFee'] as num?)?.toDouble() ?? 0.0,
        potentialSavings: (json['potentialSavings'] as num?)?.toDouble() ?? 0.0,
        message: json['message'] as String? ?? '',
      );
}

class CalculateShippingResponse {
  final double shippingFee;
  final String? estimatedDelivery;
  final String? truckName;
  final double? maxCapacityTons;
  final bool isWeightExceeded;
  final String? warningMessage;

  // New fields for multi-truck and promotion calculation
  final int requiredTrucksCount;
  final double singleTruckBaseFee;
  final double singleTruckFeeAfterDiscount;
  final double totalOriginalShippingFee;
  final double totalDiscountAmount;
  final ShippingPromotionInfo? promotion;
  final ShippingRecommendationModel? recommendation;

  const CalculateShippingResponse({
    required this.shippingFee,
    this.estimatedDelivery,
    this.truckName,
    this.maxCapacityTons,
    this.isWeightExceeded = false,
    this.warningMessage,
    this.requiredTrucksCount = 1,
    this.singleTruckBaseFee = 0.0,
    this.singleTruckFeeAfterDiscount = 0.0,
    this.totalOriginalShippingFee = 0.0,
    this.totalDiscountAmount = 0.0,
    this.promotion,
    this.recommendation,
  });

  bool get hasPromotion =>
      promotion != null || totalDiscountAmount > 0;

  factory CalculateShippingResponse.fromJson(Map<String, dynamic> json) {
    final fee = (json['shippingFee'] as num?)?.toDouble() ??
        (json['finalShippingFee'] as num?)?.toDouble() ??
        0.0;
    final truckCount = (json['requiredTrucksCount'] as num?)?.toInt() ??
        (json['truckCount'] as num?)?.toInt() ??
        1;
    final singleBase = (json['singleTruckBaseFee'] as num?)?.toDouble() ??
        (fee > 0 && truckCount > 0 ? (fee / truckCount) : 0.0);
    final singleDiscounted =
        (json['singleTruckFeeAfterDiscount'] as num?)?.toDouble() ??
            (fee > 0 && truckCount > 0 ? (fee / truckCount) : 0.0);
    final origFee = (json['totalOriginalShippingFee'] as num?)?.toDouble() ??
        (singleBase * truckCount);
    final discountAmount =
        (json['totalDiscountAmount'] as num?)?.toDouble() ?? 0.0;

    return CalculateShippingResponse(
      shippingFee: fee,
      estimatedDelivery: json['estimatedDelivery'] as String?,
      truckName: json['truckName'] as String?,
      maxCapacityTons: (json['maxCapacityTons'] as num?)?.toDouble(),
      isWeightExceeded: json['isWeightExceeded'] as bool? ?? (truckCount > 1),
      warningMessage: json['warningMessage'] as String?,
      requiredTrucksCount: truckCount,
      singleTruckBaseFee: singleBase,
      singleTruckFeeAfterDiscount: singleDiscounted,
      totalOriginalShippingFee: origFee > 0 ? origFee : fee,
      totalDiscountAmount: discountAmount,
      promotion: json['promotion'] != null
          ? ShippingPromotionInfo.fromJson(json['promotion'] as Map<String, dynamic>)
          : null,
      recommendation: json['recommendation'] != null
          ? ShippingRecommendationModel.fromJson(
              json['recommendation'] as Map<String, dynamic>)
          : null,
    );
  }
}
