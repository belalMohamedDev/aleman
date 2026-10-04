import 'package:aleman/feature/home/data/mapper/banner_mapper.dart';
import 'package:aleman/feature/home/data/mapper/category_mapper.dart';
import 'package:aleman/feature/home/data/mapper/product_mapper.dart';
import 'package:aleman/feature/home/data/model/home_response_model.dart';

class HomeEntity {
  final List<BannerEntity> banners;
  final List<CategoryEntity> categories;
  final List<ProductEntity> featuredProducts;
  final List<ProductEntity> bestSellers;

  HomeEntity({
    required this.banners,
    required this.categories,
    required this.featuredProducts,
    required this.bestSellers,
  });
}

extension HomeResponseModelMapper on HomeResponseModel? {
  HomeEntity toDomain() {
    return HomeEntity(
      banners: (this?.banners ?? []).map((b) => b.toDomain()).toList(),
      categories: (this?.categories ?? []).map((c) => c.toDomain()).toList(),
      featuredProducts:
          (this?.featuredProducts ?? []).map((p) => p.toDomain()).toList(),
      bestSellers: (this?.bestSellers ?? []).map((p) => p.toDomain()).toList(),
    );
  }
}
