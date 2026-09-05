import 'package:aleman/feature/home/data/model/product_model.dart';

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
      weightPerSackKg: this?.weightPerSackKg ?? 0.0,
      pricePerTon: this?.pricePerTon ?? 0.0,
      proteinPercentage: this?.proteinPercentage ?? 0.0,
      growthStage: this?.growthStage ?? 0,
      feedForm: this?.feedForm ?? 0,
      ingredients: this?.ingredients ?? '',
      additives: this?.additives ?? '',
    );
  }
}
