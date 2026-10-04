import 'package:aleman/feature/home/data/model/banner_model.dart';
import 'package:aleman/feature/home/data/model/category_model.dart';
import 'package:aleman/feature/home/data/model/product_model.dart';

class HomeResponseModel {
  List<BannersModel>? banners;
  List<CategoryModel>? categories;
  List<ProductModel>? featuredProducts;
  List<ProductModel>? bestSellers;

  HomeResponseModel({
    this.banners,
    this.categories,
    this.featuredProducts,
    this.bestSellers,
  });

  factory HomeResponseModel.fromJson(Map<String, dynamic> json) {
    return HomeResponseModel(
      banners: json['banners'] != null
          ? (json['banners'] as List)
              .map((e) => BannersModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
      categories: json['categories'] != null
          ? (json['categories'] as List)
              .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
      featuredProducts: json['featuredProducts'] != null
          ? (json['featuredProducts'] as List)
              .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
      bestSellers: json['bestSellers'] != null
          ? (json['bestSellers'] as List)
              .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
    );
  }
}
