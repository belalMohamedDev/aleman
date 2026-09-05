import 'package:aleman/core/network/api/app_api.dart';
import 'package:aleman/core/network/apiResult/api_reuslt.dart';
import 'package:aleman/core/network/error_handler/api_error_handler.dart';
import 'package:aleman/feature/Authentication/data/mapper/auth_mapper.dart';
import 'package:aleman/feature/Authentication/data/model/bodyRequest/forgot_password/forgot_password_request_body.dart';
import 'package:aleman/feature/Authentication/data/model/bodyRequest/forgot_password/reset_password_request_body.dart';
import 'package:aleman/feature/Authentication/data/model/bodyRequest/forgot_password/verify_reset_code_request_body.dart';
import 'package:aleman/feature/Authentication/data/model/bodyRequest/login/login_body_request.dart';
import 'package:aleman/feature/Authentication/data/model/bodyRequest/logout/logout_body_request.dart';
import 'package:aleman/feature/Authentication/data/repository/authentication_repository.dart';

class AuthenticationRepositoryImplement implements AuthenticationRepository {
  AuthenticationRepositoryImplement(this._apiService);

  final AppServiceClient _apiService;

  @override
  Future<ApiResult<AuthEntity>> login(LoginRequestBody loginRequestBody) async {
    try {
      final response = await _apiService.loginService(loginRequestBody);
      return ApiResult.success(response.toDomain());
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<String>> forgotPassword(
    ForgotPasswordRequestBody forgotPasswordRequestBody,
  ) async {
    try {
      final response = await _apiService.forgotPasswordService(
        forgotPasswordRequestBody,
      );
      return ApiResult.success(
        response.message ?? 'تم إرسال كود التحقق في رسالة نصية بنجاح',
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<String>> verifyResetCode(
    VerifyResetCodeRequestBody verifyResetCodeRequestBody,
  ) async {
    try {
      final response = await _apiService.verifyResetCodeService(
        verifyResetCodeRequestBody,
      );
      return ApiResult.success(response.message ?? 'كود التحقق صحيح');
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<String>> resetPassword(
    ResetPasswordRequestBody resetPasswordRequestBody,
  ) async {
    try {
      final response = await _apiService.resetPasswordService(
        resetPasswordRequestBody,
      );
      return ApiResult.success(
        response.message ?? 'تم إعادة تعيين كلمة المرور بنجاح',
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<String>> logout(LogoutRequestBody logoutRequestBody) async {
    try {
      final response = await _apiService.logoutService(logoutRequestBody);
      return ApiResult.success(
        response.message ?? 'تم تسجيل الخروج بنجاح',
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
