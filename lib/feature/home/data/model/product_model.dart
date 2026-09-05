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
  });

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['categoryId'];
    sapProductId = json['sapProductId'];
    name = json['name'];
    description = json['description'];
    price = json['price']?.toDouble();
    imageUrl = json['imageUrl'];
    isActive = json['isActive'];
    createdAt = json['createdAt'];
    
    // Parse new properties
    weightPerSackKg = json['weightPerSackKg']?.toDouble();
    pricePerTon = json['pricePerTon']?.toDouble();
    proteinPercentage = json['proteinPercentage']?.toDouble();
    growthStage = json['growthStage'];
    feedForm = json['feedForm'];
    ingredients = json['ingredients'];
    additives = json['additives'];
  }
}

