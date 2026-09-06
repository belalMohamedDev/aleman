import 'package:aleman/core/network/api/app_api.dart';
import 'package:aleman/core/network/error_handler/api_error_handler.dart';
import 'package:aleman/core/network/apiResult/api_reuslt.dart';
import 'package:aleman/feature/profile/data/model/user_profile_model.dart';

abstract class ProfileRepository {
  Future<ApiResult<UserProfileModel>> getUserProfile();
}

class ProfileRepositoryImpl implements ProfileRepository {
  final AppServiceClient _apiService;

  ProfileRepositoryImpl(this._apiService);

  @override
  Future<ApiResult<UserProfileModel>> getUserProfile() async {
    try {
      final response = await _apiService.getUserProfileService();
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
