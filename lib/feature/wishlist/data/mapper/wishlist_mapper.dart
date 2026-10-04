import 'package:aleman/feature/home/data/mapper/product_mapper.dart';
import 'package:aleman/feature/wishlist/data/model/wishlist_model.dart';

class WishlistItemEntity {
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
  final List<PackageEntity> packages;
  final String? createdAt;

  WishlistItemEntity({
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

  /// Convert WishlistItemEntity to ProductEntity for bottom sheets & carts
  ProductEntity toProductEntity() {
    return ProductEntity(
      id: productId,
      categoryId: categoryId ?? 0,
      name: productName,
      description: productDescription ?? '',
      price: price,
      imageUrl: productImageUrl ?? '',
      isActive: isActive,
      isFeatured: isFeatured,
      weightPerSackKg: weightPerSackKg ?? 0.0,
      pricePerTon: pricePerTon ?? 0.0,
      proteinPercentage: proteinPercentage ?? 0.0,
      growthStage: 0,
      feedForm: 0,
      ingredients: '',
      additives: '',
      packages: packages,
    );
  }
}

extension WishlistMapper on WishlistItemModel? {
  WishlistItemEntity toEntity() {
    return WishlistItemEntity(
      id: this?.id ?? 0,
      productId: this?.productId ?? 0,
      productName: this?.productName ?? '',
      productDescription: this?.productDescription,
      productImageUrl: this?.productImageUrl,
      categoryId: this?.categoryId,
      categoryName: this?.categoryName,
      price: this?.price ?? 0.0,
      minPrice: this?.minPrice,
      maxPrice: this?.maxPrice,
      proteinPercentage: this?.proteinPercentage,
      weightPerSackKg: this?.weightPerSackKg,
      pricePerTon: this?.pricePerTon,
      isFeatured: this?.isFeatured ?? false,
      isActive: this?.isActive ?? true,
      packages: this?.packages.map((p) => p.toDomain()).toList() ?? [],
      createdAt: this?.createdAt,
    );
  }
}
