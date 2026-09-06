class AddToCartRequestBody {
  final int productId;
  final int productPackageId;
  final double packageWeightKg;
  final int quantity;

  const AddToCartRequestBody({
    required this.productId,
    required this.productPackageId,
    required this.packageWeightKg,
    required this.quantity,
  });

  factory AddToCartRequestBody.fromJson(Map<String, dynamic> json) =>
      AddToCartRequestBody(
        productId: (json['productId'] as num?)?.toInt() ?? 0,
        productPackageId: (json['productPackageId'] as num?)?.toInt() ?? 0,
        packageWeightKg: (json['packageWeightKg'] as num?)?.toDouble() ?? 0.0,
        quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'productPackageId': productPackageId,
        'packageWeightKg': packageWeightKg,
        'quantity': quantity,
      };
}
