import 'package:aleman/core/network/apiResult/api_reuslt.dart';
import 'package:aleman/feature/home/data/mapper/banner_mapper.dart';
import 'package:aleman/feature/home/data/mapper/category_mapper.dart';

abstract class HomeRepository {
  Future<ApiResult<List<BannerEntity>>> getBannerRepo();
  Future<ApiResult<List<CategoryEntity>>> getCategoryRepo();
}
