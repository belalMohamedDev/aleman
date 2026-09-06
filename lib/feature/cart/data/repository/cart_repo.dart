import 'package:aleman/core/network/apiResult/api_reuslt.dart';
import 'package:aleman/feature/cart/data/model/add_to_cart_request_body.dart';
import 'package:aleman/feature/cart/data/model/cart_count_response.dart';
import 'package:aleman/feature/cart/data/model/cart_response_model.dart';
import 'package:aleman/feature/cart/data/model/update_cart_item_request_body.dart';

abstract class CartRepository {
  Future<ApiResult<CartResponseModel>> addToCart(AddToCartRequestBody body);
  Future<ApiResult<CartCountResponse>> getCartCount();
  Future<ApiResult<CartResponseModel>> getCart();
  Future<ApiResult<dynamic>> clearCart();
  Future<ApiResult<CartResponseModel>> updateCartItem(int itemId, UpdateCartItemRequestBody body);
  Future<ApiResult<dynamic>> deleteCartItem(int itemId);
}
