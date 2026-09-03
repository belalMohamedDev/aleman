import 'package:aleman/core/network/api/app_api.dart';
import 'package:aleman/core/network/apiResult/api_reuslt.dart';
import 'package:aleman/core/network/error_handler/api_error_handler.dart';
import 'package:aleman/feature/home/data/mapper/banner_mapper.dart';
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
}
