import 'package:aleman/feature/home/data/model/product_model.dart';

class ProductEntity {
  final int id;
  final int categoryId;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final bool isActive;

  ProductEntity({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.isActive,
  });
}

extension ProductMapper on ProductModel? {
  ProductEntity toDomain() {
    return ProductEntity(
      id: this?.id ?? 0,
      categoryId: this?.categoryId ?? 0,
      name: this?.name ?? '',
      description: this?.description ?? '',
      price: this?.price ?? 0.0,
      imageUrl: this?.imageUrl ?? '',
      isActive: this?.isActive ?? false,
    );
  }
}
