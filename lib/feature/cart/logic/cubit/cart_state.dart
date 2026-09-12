import 'package:aleman/feature/cart/data/model/cart_response_model.dart';

enum CartStatus { initial, loading, success, error }

class CartState {
  final CartStatus status;
  final CartResponseModel? cart;
  final String? errorMessage;
  final String? successMessage;
  final int totalItemsCount;
  final bool isDeleting;

  const CartState({
    this.status = CartStatus.initial,
    this.cart,
    this.errorMessage,
    this.successMessage,
    this.totalItemsCount = 0,
    this.isDeleting = false,
  });

  CartState copyWith({
    CartStatus? status,
    CartResponseModel? cart,
    String? errorMessage,
    String? successMessage,
    int? totalItemsCount,
    bool? isDeleting,
  }) {
    return CartState(
      status: status ?? this.status,
      cart: cart ?? this.cart,
      errorMessage: errorMessage,
      successMessage: successMessage,
      totalItemsCount: totalItemsCount ?? this.totalItemsCount,
      isDeleting: isDeleting ?? this.isDeleting,
    );
  }
}
