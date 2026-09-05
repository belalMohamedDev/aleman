import 'package:aleman/core/network/api_constant/api_constant.dart';
import 'package:aleman/feature/Authentication/data/model/authResponse/auth_response.dart';
import 'package:aleman/feature/Authentication/data/model/authResponse/message_response.dart';
import 'package:aleman/feature/Authentication/data/model/bodyRequest/forgot_password/forgot_password_request_body.dart';
import 'package:aleman/feature/Authentication/data/model/bodyRequest/forgot_password/reset_password_request_body.dart';
import 'package:aleman/feature/Authentication/data/model/bodyRequest/forgot_password/verify_reset_code_request_body.dart';
import 'package:aleman/feature/Authentication/data/model/bodyRequest/login/login_body_request.dart';
import 'package:aleman/feature/home/data/model/banner_model.dart';
import 'package:aleman/feature/home/data/model/category_model.dart';
import 'package:aleman/feature/home/data/model/product_model.dart';
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

  @GET(ApiConstants.product)
  Future<List<ProductModel>> getProductsService();

  @POST(ApiConstants.login)
  Future<AuthResponse> loginService(@Body() LoginRequestBody body);

  @POST(ApiConstants.forgotPassword)
  Future<MessageResponse> forgotPasswordService(
    @Body() ForgotPasswordRequestBody body,
  );

  @POST(ApiConstants.verifyResetCode)
  Future<MessageResponse> verifyResetCodeService(
    @Body() VerifyResetCodeRequestBody body,
  );

  @POST(ApiConstants.resetPassword)
  Future<MessageResponse> resetPasswordService(
    @Body() ResetPasswordRequestBody body,
  );
}
