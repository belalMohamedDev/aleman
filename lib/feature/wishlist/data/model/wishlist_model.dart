import 'package:aleman/feature/home/data/model/package_model.dart';

class WishlistToggleResponse {
  final bool isWishlisted;
  final String? message;

  WishlistToggleResponse({required this.isWishlisted, this.message});

  factory WishlistToggleResponse.fromJson(Map<String, dynamic> json) {
    return WishlistToggleResponse(
      isWishlisted:
          json['isWishlisted'] as bool? ?? json['isAdded'] as bool? ?? false,
      message: json['message'] as String?,
    );
  }
}

class WishlistItemModel {
  final int id;
  final int productId;
  final String productName;
  final String? productDescription;
  final String? productImageUrl;
  final int? categoryId;
  final String? categoryName;
  final double price;
  final double? minPrice;
  final double? maxPrice;
  final double? proteinPercentage;
  final double? weightPerSackKg;
  final double? pricePerTon;
  final bool isFeatured;
  final bool isActive;
  final List<PackageModel> packages;
  final String? createdAt;

  WishlistItemModel({
    required this.id,
    required this.productId,
    required this.productName,
    this.productDescription,
    this.productImageUrl,
    this.categoryId,
    this.categoryName,
    required this.price,
    this.minPrice,
    this.maxPrice,
    this.proteinPercentage,
    this.weightPerSackKg,
    this.pricePerTon,
    this.isFeatured = false,
    this.isActive = true,
    this.packages = const [],
    this.createdAt,
  });

  factory WishlistItemModel.fromJson(Map<String, dynamic> json) {
    final productJson = json['product'] is Map<String, dynamic>
        ? json['product'] as Map<String, dynamic>
        : null;

    List<PackageModel> pkgs = [];
    final rawPackages = json['packages'] ?? productJson?['packages'];
    if (rawPackages is List) {
      pkgs = rawPackages
          .map((item) => PackageModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    final firstPkg = pkgs.isNotEmpty ? pkgs.first : null;

    final parsedPrice =
        (json['price'] as num?)?.toDouble() ??
        (json['minPrice'] as num?)?.toDouble() ??
        (productJson?['price'] as num?)?.toDouble() ??
        (productJson?['minPrice'] as num?)?.toDouble() ??
        firstPkg?.price ??
        0.0;

    return WishlistItemModel(
      id: json['id'] as int? ?? 0,
      productId:
          json['productId'] as int? ??
          productJson?['id'] as int? ??
          (json['id'] as int? ?? 0),
      productName:
          json['productName'] as String? ??
          json['name'] as String? ??
          productJson?['name'] as String? ??
          productJson?['productName'] as String? ??
          '',
      productDescription:
          json['productDescription'] as String? ??
          json['description'] as String? ??
          json['shortDescription'] as String? ??
          json['details'] as String? ??
          productJson?['description'] as String? ??
          productJson?['productDescription'] as String? ??
          productJson?['shortDescription'] as String? ??
          productJson?['details'] as String?,
      productImageUrl:
          json['productImageUrl'] as String? ??
          json['imageUrl'] as String? ??
          productJson?['imageUrl'] as String? ??
          productJson?['productImageUrl'] as String?,
      categoryId:
          json['categoryId'] as int? ?? productJson?['categoryId'] as int?,
      categoryName:
          json['categoryName'] as String? ??
          productJson?['categoryName'] as String?,
      price: parsedPrice,
      minPrice:
          (json['minPrice'] as num?)?.toDouble() ??
          (productJson?['minPrice'] as num?)?.toDouble() ??
          firstPkg?.price,
      maxPrice:
          (json['maxPrice'] as num?)?.toDouble() ??
          (productJson?['maxPrice'] as num?)?.toDouble(),
      proteinPercentage:
          (json['proteinPercentage'] as num?)?.toDouble() ??
          (productJson?['proteinPercentage'] as num?)?.toDouble(),
      weightPerSackKg:
          (json['weightPerSackKg'] as num?)?.toDouble() ??
          (productJson?['weightPerSackKg'] as num?)?.toDouble() ??
          firstPkg?.weightKg,
      pricePerTon:
          (json['pricePerTon'] as num?)?.toDouble() ??
          (productJson?['pricePerTon'] as num?)?.toDouble() ??
          firstPkg?.pricePerTon,
      isFeatured:
          json['isFeatured'] as bool? ??
          productJson?['isFeatured'] as bool? ??
          false,
      isActive:
          json['isActive'] as bool? ??
          productJson?['isActive'] as bool? ??
          true,
      packages: pkgs,
      createdAt: json['createdAt'] as String?,
    );
  }
}
