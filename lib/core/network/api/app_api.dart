import 'package:aleman/core/network/api_constant/api_constant.dart';
import 'package:aleman/feature/Authentication/data/model/authResponse/auth_response.dart';
import 'package:aleman/feature/Authentication/data/model/authResponse/message_response.dart';
import 'package:aleman/feature/Authentication/data/model/bodyRequest/forgot_password/forgot_password_request_body.dart';
import 'package:aleman/feature/Authentication/data/model/bodyRequest/forgot_password/reset_password_request_body.dart';
import 'package:aleman/feature/Authentication/data/model/bodyRequest/forgot_password/verify_reset_code_request_body.dart';
import 'package:aleman/feature/Authentication/data/model/bodyRequest/login/login_body_request.dart';
import 'package:aleman/feature/Authentication/data/model/bodyRequest/logout/logout_body_request.dart';
import 'package:aleman/feature/home/data/model/banner_model.dart';
import 'package:aleman/feature/home/data/model/category_model.dart';
import 'package:aleman/feature/home/data/model/product_model.dart';
import 'package:aleman/feature/cart/data/model/add_to_cart_request_body.dart';
import 'package:aleman/feature/cart/data/model/cart_count_response.dart';
import 'package:aleman/feature/cart/data/model/cart_response_model.dart';
import 'package:aleman/feature/cart/data/model/update_cart_item_request_body.dart';
import 'package:aleman/feature/profile/data/model/user_profile_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'package:aleman/feature/notification/data/model/request/register_token_request_body.dart';
import 'package:aleman/feature/notification/data/model/request/remove_token_request_body.dart';
import 'package:aleman/feature/notification/data/model/response/notifications_list_response.dart';
import 'package:aleman/feature/notification/data/model/response/unread_count_response.dart';
import 'package:aleman/feature/vehicle/data/model/user_vehicle_model.dart';
import 'package:aleman/feature/vehicle/data/model/create_vehicle_request.dart';
import 'package:aleman/feature/address/data/model/user_address_model.dart';
import 'package:aleman/feature/address/data/model/create_address_request.dart';
import 'package:aleman/feature/order/data/model/calculate_shipping_model.dart';
import 'package:aleman/feature/order/data/model/create_order_request.dart';
import 'package:aleman/feature/order/data/model/order_response_model.dart';
import 'package:aleman/feature/order/data/model/small_merchants_orders_response.dart';

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

  @POST(ApiConstants.logout)
  Future<MessageResponse> logoutService(
    @Body() LogoutRequestBody body,
  );

  @POST(ApiConstants.cartItems)
  Future<CartResponseModel> addToCartService(
    @Body() AddToCartRequestBody body,
  );

  @GET(ApiConstants.userProfile)
  Future<UserProfileModel> getUserProfileService();

  @GET(ApiConstants.cartCount)
  Future<CartCountResponse> getCartCountService();

  @GET(ApiConstants.getCart)
  Future<CartResponseModel> getCartService();

  @DELETE(ApiConstants.getCart)
  Future<dynamic> clearCartService();

  @PUT('${ApiConstants.cartItems}/{itemId}')
  Future<CartResponseModel> updateCartItemService(
    @Path('itemId') int itemId,
    @Body() UpdateCartItemRequestBody body,
  );

  @DELETE('${ApiConstants.cartItems}/{itemId}')
  Future<dynamic> deleteCartItemService(
    @Path('itemId') int itemId,
  );

  @POST(ApiConstants.registerToken)
  Future<MessageResponse> registerDeviceToken(
    @Body() RegisterTokenRequestBody body,
  );

  @POST(ApiConstants.removeToken)
  Future<MessageResponse> removeDeviceToken(
    @Body() RemoveTokenRequestBody body,
  );

  @GET(ApiConstants.notifications)
  Future<NotificationsListResponse> getNotifications(
    @Query('page') int page,
    @Query('limit') int limit,
  );

  @GET(ApiConstants.notificationsUnreadCount)
  Future<UnreadCountResponse> getUnreadNotificationsCount();

  @PATCH('${ApiConstants.notifications}/{id}/read')
  Future<MessageResponse> markNotificationAsRead(
    @Path('id') int id,
  );

  @POST(ApiConstants.markAllNotificationsRead)
  Future<MessageResponse> markAllNotificationsAsRead();

  // ----------------------------------------------------
  // User Vehicles
  // ----------------------------------------------------
  @GET(ApiConstants.userVehicles)
  Future<dynamic> getVehicles();

  @POST(ApiConstants.userVehicles)
  Future<UserVehicleModel> createVehicle(
    @Body() CreateVehicleRequest request,
  );

  @PUT('${ApiConstants.userVehicles}/{id}')
  Future<UserVehicleModel> updateVehicle(
    @Path('id') String id,
    @Body() CreateVehicleRequest request,
  );

  @DELETE('${ApiConstants.userVehicles}/{id}')
  Future<dynamic> deleteVehicle(
    @Path('id') String id,
  );

  @PATCH('${ApiConstants.userVehicles}/{id}/set-default')
  Future<dynamic> setDefaultVehicle(
    @Path('id') String id,
  );

  // ----------------------------------------------------
  // User Addresses
  // ----------------------------------------------------
  @GET(ApiConstants.userAddresses)
  Future<dynamic> getAddresses();

  @POST(ApiConstants.userAddresses)
  Future<UserAddressModel> createAddress(
    @Body() CreateAddressRequest request,
  );

  @DELETE('${ApiConstants.userAddresses}/{id}')
  Future<dynamic> deleteAddress(
    @Path('id') String id,
  );

  // ----------------------------------------------------
  // Orders
  // ----------------------------------------------------
  @POST(ApiConstants.calculateShipping)
  Future<CalculateShippingResponse> calculateShipping(
    @Body() CalculateShippingRequest request,
  );

  @POST(ApiConstants.orders)
  Future<OrderResponseModel> createOrder(
    @Body() CreateOrderRequest request,
  );

  @GET(ApiConstants.orders)
  Future<dynamic> getMyOrders(
    @Query('status') int? status,
  );

  @GET('${ApiConstants.orders}/{orderId}')
  Future<dynamic> getOrderDetails(
    @Path('orderId') String orderId,
  );

  @POST('${ApiConstants.orders}/{orderId}/cancel')
  Future<dynamic> cancelOrder(
    @Path('orderId') String orderId,
  );

  @GET(ApiConstants.smallMerchantsOrders)
  Future<SmallMerchantsOrdersResponse> getSmallMerchantsOrders(
    @Query('page') int page,
    @Query('pageSize') int pageSize,
  );
}
