import 'package:aleman/feature/home/data/model/package_model.dart';
import 'package:aleman/feature/home/data/model/product_model.dart';

class PackageEntity {
  final int id;
  final int productId;
  final double weightKg;
  final double price;
  final double pricePerTon;
  final bool isActive;

  PackageEntity({
    required this.id,
    required this.productId,
    required this.weightKg,
    required this.price,
    required this.pricePerTon,
    required this.isActive,
  });
}

class ProductEntity {
  final int id;
  final int categoryId;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final bool isActive;
  final double weightPerSackKg;
  final double pricePerTon;
  final double proteinPercentage;
  final int growthStage;
  final int feedForm;
  final String ingredients;
  final String additives;
  final List<PackageEntity> packages;

  ProductEntity({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.isActive,
    required this.weightPerSackKg,
    required this.pricePerTon,
    required this.proteinPercentage,
    required this.growthStage,
    required this.feedForm,
    required this.ingredients,
    required this.additives,
    this.packages = const [],
  });
}

extension PackageMapper on PackageModel? {
  PackageEntity toDomain() {
    return PackageEntity(
      id: this?.id ?? 0,
      productId: this?.productId ?? 0,
      weightKg: this?.weightKg ?? 0.0,
      price: this?.price ?? 0.0,
      pricePerTon: this?.pricePerTon ?? 0.0,
      isActive: this?.isActive ?? false,
    );
  }
}

extension ProductMapper on ProductModel? {
  ProductEntity toDomain() {
    final packageEntities = (this?.packages ?? [])
        .map((p) => p.toDomain())
        .toList();

    final defaultPkg =
        packageEntities.isNotEmpty ? packageEntities.first : null;

    return ProductEntity(
      id: this?.id ?? 0,
      categoryId: this?.categoryId ?? 0,
      name: this?.name ?? '',
      description: this?.description ?? '',
      price: this?.price ?? defaultPkg?.price ?? 0.0,
      imageUrl: this?.imageUrl ?? '',
      isActive: this?.isActive ?? false,
      weightPerSackKg: this?.weightPerSackKg ?? defaultPkg?.weightKg ?? 0.0,
      pricePerTon: this?.pricePerTon ?? defaultPkg?.pricePerTon ?? 0.0,
      proteinPercentage: this?.proteinPercentage ?? 0.0,
      growthStage: this?.growthStage ?? 0,
      feedForm: this?.feedForm ?? 0,
      ingredients: this?.ingredients ?? '',
      additives: this?.additives ?? '',
      packages: packageEntities,
    );
  }
}
