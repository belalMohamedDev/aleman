class CartResponseModel {
  final int id;
  final List<CartItemModel> items;
  final int totalItemsCount;
  final double totalWeightKg;
  final double totalWeightTons;
  final double totalPrice;

  const CartResponseModel({
    required this.id,
    required this.items,
    required this.totalItemsCount,
    required this.totalWeightKg,
    required this.totalWeightTons,
    required this.totalPrice,
  });

  factory CartResponseModel.fromJson(Map<String, dynamic> json) =>
      CartResponseModel(
        id: (json['id'] as num?)?.toInt() ?? 0,
        items: (json['items'] as List<dynamic>?)
                ?.map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
        totalItemsCount: (json['totalItemsCount'] as num?)?.toInt() ?? 0,
        totalWeightKg: (json['totalWeightKg'] as num?)?.toDouble() ?? 0.0,
        totalWeightTons: (json['totalWeightTons'] as num?)?.toDouble() ?? 0.0,
        totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'items': items.map((e) => e.toJson()).toList(),
        'totalItemsCount': totalItemsCount,
        'totalWeightKg': totalWeightKg,
        'totalWeightTons': totalWeightTons,
        'totalPrice': totalPrice,
      };
}

class CartItemModel {
  final int id;
  final int productId;
  final String productName;
  final String? productImageUrl;
  final int productPackageId;
  final double packageWeightKg;
  final String? packageSize;
  final double unitPrice;
  final double pricePerTon;
  final int quantity;
  final double subtotal;
  final double totalWeightKg;

  const CartItemModel({
    required this.id,
    required this.productId,
    required this.productName,
    this.productImageUrl,
    required this.productPackageId,
    required this.packageWeightKg,
    this.packageSize,
    required this.unitPrice,
    required this.pricePerTon,
    required this.quantity,
    required this.subtotal,
    required this.totalWeightKg,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) => CartItemModel(
        id: (json['id'] as num?)?.toInt() ?? 0,
        productId: (json['productId'] as num?)?.toInt() ?? 0,
        productName: json['productName'] as String? ?? '',
        productImageUrl: json['productImageUrl'] as String?,
        productPackageId: (json['productPackageId'] as num?)?.toInt() ?? 0,
        packageWeightKg:
            (json['packageWeightKg'] as num?)?.toDouble() ?? 0.0,
        packageSize: json['packageSize'] as String?,
        unitPrice: (json['unitPrice'] as num?)?.toDouble() ?? 0.0,
        pricePerTon: (json['pricePerTon'] as num?)?.toDouble() ?? 0.0,
        quantity: (json['quantity'] as num?)?.toInt() ?? 0,
        subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
        totalWeightKg: (json['totalWeightKg'] as num?)?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'productId': productId,
        'productName': productName,
        'productImageUrl': productImageUrl,
        'productPackageId': productPackageId,
        'packageWeightKg': packageWeightKg,
        'packageSize': packageSize,
        'unitPrice': unitPrice,
        'pricePerTon': pricePerTon,
        'quantity': quantity,
        'subtotal': subtotal,
        'totalWeightKg': totalWeightKg,
      };
}
