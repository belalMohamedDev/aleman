import 'package:aleman/feature/home/data/model/package_model.dart';

class ProductModel {
  int? id;
  int? categoryId;
  String? sapProductId;
  String? name;
  String? description;
  double? price;
  String? imageUrl;
  bool? isActive;
  String? createdAt;

  // New properties
  double? weightPerSackKg;
  double? pricePerTon;
  double? proteinPercentage;
  int? growthStage;
  int? feedForm;
  String? ingredients;
  String? additives;
  List<PackageModel>? packages;

  ProductModel({
    this.id,
    this.categoryId,
    this.sapProductId,
    this.name,
    this.description,
    this.price,
    this.imageUrl,
    this.isActive,
    this.createdAt,
    this.weightPerSackKg,
    this.pricePerTon,
    this.proteinPercentage,
    this.growthStage,
    this.feedForm,
    this.ingredients,
    this.additives,
    this.packages,
  });

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['categoryId'];
    sapProductId = json['sapProductId'];
    name = json['name'];
    description = json['description'];
    imageUrl = json['imageUrl'];
    isActive = json['isActive'];
    createdAt = json['createdAt'];

    proteinPercentage = json['proteinPercentage']?.toDouble();
    growthStage = json['growthStage'];
    feedForm = json['feedForm'];
    ingredients = json['ingredients'];
    additives = json['additives'];

    if (json['packages'] != null) {
      packages = (json['packages'] as List)
          .map((e) => PackageModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      packages = [];
    }

    // Default fallback from packages if top-level fields are absent
    final firstPkg = (packages != null && packages!.isNotEmpty) ? packages!.first : null;
    price = json['price']?.toDouble() ?? firstPkg?.price;
    pricePerTon = json['pricePerTon']?.toDouble() ?? firstPkg?.pricePerTon;
    weightPerSackKg = json['weightPerSackKg']?.toDouble() ?? firstPkg?.weightKg;
  }
}
