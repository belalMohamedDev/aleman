import 'package:aleman/core/network/api_constant/api_constant.dart';
import 'package:aleman/feature/home/data/model/banner_model.dart';
import 'package:aleman/feature/home/data/model/category_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'app_api.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class AppServiceClient {
  factory AppServiceClient(Dio dio, {String baseUrl}) = _AppServiceClient;

  @GET(ApiConstants.banner)
  Future<List<BannersModel>> getBannersService();

  @GET(ApiConstants.category)
  Future<List<CategoryModel>> getCategoriesService();
}
