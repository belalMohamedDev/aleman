import 'package:aleman/feature/home/data/model/category_model.dart';

class CategoryEntity {
  final int id;
  final String name;
  final String imageUrl;
  final bool isActive;
  final String createdAt;

  CategoryEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.isActive,
    required this.createdAt,
  });
}

extension CategoryMapper on CategoryModel? {
  CategoryEntity toDomain() {
    return CategoryEntity(
      id: this?.id ?? 0,
      name: this?.name ?? '',
      imageUrl: this?.imageUrl ?? '',
      isActive: this?.isActive ?? false,
      createdAt: this?.createdAt ?? '',
    );
  }
}
