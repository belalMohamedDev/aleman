class CalculateShippingRequest {
  final String addressId;
  final int truckType;

  const CalculateShippingRequest({
    required this.addressId,
    required this.truckType,
  });

  Map<String, dynamic> toJson() => {
        'addressId': addressId,
        'truckType': truckType,
      };
}

class CalculateShippingResponse {
  final double shippingFee;
  final String? estimatedDelivery;
  final String? truckName;
  final double? maxCapacityTons;
  final bool isWeightExceeded;
  final String? warningMessage;

  const CalculateShippingResponse({
    required this.shippingFee,
    this.estimatedDelivery,
    this.truckName,
    this.maxCapacityTons,
    this.isWeightExceeded = false,
    this.warningMessage,
  });

  factory CalculateShippingResponse.fromJson(Map<String, dynamic> json) =>
      CalculateShippingResponse(
        shippingFee: (json['shippingFee'] as num?)?.toDouble() ?? 0.0,
        estimatedDelivery: json['estimatedDelivery'] as String?,
        truckName: json['truckName'] as String?,
        maxCapacityTons: (json['maxCapacityTons'] as num?)?.toDouble(),
        isWeightExceeded: json['isWeightExceeded'] as bool? ?? false,
        warningMessage: json['warningMessage'] as String?,
      );
}
