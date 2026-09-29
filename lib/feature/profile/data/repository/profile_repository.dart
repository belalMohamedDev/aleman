import 'dart:io';

import 'package:aleman/core/network/api/app_api.dart';
import 'package:aleman/core/network/apiResult/api_reuslt.dart';
import 'package:aleman/core/network/error_handler/api_error_handler.dart';
import 'package:aleman/feature/Authentication/data/model/authResponse/message_response.dart';
import 'package:aleman/feature/profile/data/model/change_password_request_body.dart';
import 'package:aleman/feature/profile/data/model/update_profile_image_response.dart';
import 'package:aleman/feature/profile/data/model/user_profile_model.dart';

abstract class ProfileRepository {
  Future<ApiResult<UserProfileModel>> getUserProfile();
  Future<ApiResult<MessageResponse>> changePassword(
    ChangePasswordRequestBody body,
  );
  Future<ApiResult<UpdateProfileImageResponse>> updateProfileImage(File file);
  Future<ApiResult<MessageResponse>> removeProfileImage();
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

  @override
  Future<ApiResult<MessageResponse>> changePassword(
    ChangePasswordRequestBody body,
  ) async {
    try {
      final response = await _apiService.changePasswordService(body);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<UpdateProfileImageResponse>> updateProfileImage(
    File file,
  ) async {
    try {
      final response = await _apiService.updateProfileImageService(file);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<MessageResponse>> removeProfileImage() async {
    try {
      final response = await _apiService.removeProfileImageService();
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
