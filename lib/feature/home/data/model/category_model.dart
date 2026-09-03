class CategoryModel {
  int? id;
  String? name;
  String? imageUrl;
  bool? isActive;
  String? createdAt;

  CategoryModel({
    this.id,
    this.name,
    this.imageUrl,
    this.isActive,
    this.createdAt,
  });

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    imageUrl = json['imageUrl'];
    isActive = json['isActive'];
    createdAt = json['createdAt'];
  }
}
