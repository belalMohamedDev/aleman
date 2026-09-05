class PackageModel {
  int? id;
  int? productId;
  double? weightKg;
  double? price;
  double? pricePerTon;
  bool? isActive;

  PackageModel({
    this.id,
    this.productId,
    this.weightKg,
    this.price,
    this.pricePerTon,
    this.isActive,
  });

  PackageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['productId'];
    weightKg = json['weightKg']?.toDouble();
    price = json['price']?.toDouble();
    pricePerTon = json['pricePerTon']?.toDouble();
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'weightKg': weightKg,
      'price': price,
      'pricePerTon': pricePerTon,
      'isActive': isActive,
    };
  }
}
