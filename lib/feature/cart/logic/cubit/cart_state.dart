import 'package:aleman/feature/cart/data/model/cart_response_model.dart';

enum CartStatus { initial, loading, success, error }

class CartState {
  final CartStatus status;
  final CartResponseModel? cart;
  final String? errorMessage;
  final String? successMessage;
  final int totalItemsCount;

  const CartState({
    this.status = CartStatus.initial,
    this.cart,
    this.errorMessage,
    this.successMessage,
    this.totalItemsCount = 0,
  });

  CartState copyWith({
    CartStatus? status,
    CartResponseModel? cart,
    String? errorMessage,
    String? successMessage,
    int? totalItemsCount,
  }) {
    return CartState(
      status: status ?? this.status,
      cart: cart ?? this.cart,
      errorMessage: errorMessage,
      successMessage: successMessage,
      totalItemsCount: totalItemsCount ?? this.totalItemsCount,
    );
  }
}
