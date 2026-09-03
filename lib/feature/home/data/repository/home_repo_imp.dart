import 'package:aleman/core/network/api/app_api.dart';
import 'package:aleman/core/network/apiResult/api_reuslt.dart';
import 'package:aleman/core/network/error_handler/api_error_handler.dart';
import 'package:aleman/feature/home/data/mapper/banner_mapper.dart';
import 'package:aleman/feature/home/data/mapper/category_mapper.dart';
import 'package:aleman/feature/home/data/mapper/product_mapper.dart';
import 'package:aleman/feature/home/data/repository/home_repo.dart';

class HomeRepositoryImplement implements HomeRepository {
  HomeRepositoryImplement(this._apiService);

  final AppServiceClient _apiService;

  @override
  Future<ApiResult<List<BannerEntity>>> getBannerRepo() async {
    try {
      final response = await _apiService.getBannersService();

      final List<BannerEntity> banners = response
          .map((bannerModel) => bannerModel.toDomain())
          .toList();

      return ApiResult.success(banners);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<List<CategoryEntity>>> getCategoryRepo() async {
    try {
      final response = await _apiService.getCategoriesService();

      final List<CategoryEntity> categories = response
          .map((categoryModel) => categoryModel.toDomain())
          .toList();

      return ApiResult.success(categories);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<List<ProductEntity>>> getProductRepo() async {
    try {
      final response = await _apiService.getProductsService();

      final List<ProductEntity> products = response
          .map((productModel) => productModel.toDomain())
          .toList();

      return ApiResult.success(products);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
