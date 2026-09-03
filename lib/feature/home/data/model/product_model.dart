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
  }
}
