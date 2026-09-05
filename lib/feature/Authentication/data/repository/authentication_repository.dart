import 'package:aleman/core/network/apiResult/api_reuslt.dart';
import 'package:aleman/feature/Authentication/data/mapper/auth_mapper.dart';
import 'package:aleman/feature/Authentication/data/model/bodyRequest/forgot_password/forgot_password_request_body.dart';
import 'package:aleman/feature/Authentication/data/model/bodyRequest/forgot_password/reset_password_request_body.dart';
import 'package:aleman/feature/Authentication/data/model/bodyRequest/forgot_password/verify_reset_code_request_body.dart';
import 'package:aleman/feature/Authentication/data/model/bodyRequest/login/login_body_request.dart';

abstract class AuthenticationRepository {
  Future<ApiResult<AuthEntity>> login(LoginRequestBody loginRequestBody);

  Future<ApiResult<String>> forgotPassword(
    ForgotPasswordRequestBody forgotPasswordRequestBody,
  );

  Future<ApiResult<String>> verifyResetCode(
    VerifyResetCodeRequestBody verifyResetCodeRequestBody,
  );

  Future<ApiResult<String>> resetPassword(
    ResetPasswordRequestBody resetPasswordRequestBody,
  );
}
