import 'package:aleman/core/network/api/app_api.dart';
import 'package:aleman/core/network/apiResult/api_reuslt.dart';
import 'package:aleman/core/network/error_handler/api_error_handler.dart';
import 'package:aleman/feature/cart/data/model/add_to_cart_request_body.dart';
import 'package:aleman/feature/cart/data/model/cart_count_response.dart';
import 'package:aleman/feature/cart/data/model/cart_response_model.dart';
import 'package:aleman/feature/cart/data/model/update_cart_item_request_body.dart';
import 'package:aleman/feature/cart/data/repository/cart_repo.dart';

class CartRepositoryImplement implements CartRepository {
  CartRepositoryImplement(this._apiService);

  final AppServiceClient _apiService;

  @override
  Future<ApiResult<CartResponseModel>> addToCart(AddToCartRequestBody body) async {
    try {
      final response = await _apiService.addToCartService(body);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<CartCountResponse>> getCartCount() async {
    try {
      final response = await _apiService.getCartCountService();
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<CartResponseModel>> getCart() async {
    try {
      final response = await _apiService.getCartService();
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<dynamic>> clearCart() async {
    try {
      final response = await _apiService.clearCartService();
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<CartResponseModel>> updateCartItem(
    int itemId,
    UpdateCartItemRequestBody body,
  ) async {
    try {
      final response = await _apiService.updateCartItemService(itemId, body);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<dynamic>> deleteCartItem(int itemId) async {
    try {
      final response = await _apiService.deleteCartItemService(itemId);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
