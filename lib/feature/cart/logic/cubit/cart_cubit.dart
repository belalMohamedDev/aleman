import 'package:aleman/core/network/apiResult/api_reuslt.dart';
import 'package:aleman/feature/cart/data/model/add_to_cart_request_body.dart';
import 'package:aleman/feature/cart/data/model/cart_response_model.dart';
import 'package:aleman/feature/cart/data/model/update_cart_item_request_body.dart';
import 'package:aleman/feature/cart/data/repository/cart_repo.dart';
import 'package:aleman/feature/cart/logic/cubit/cart_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit(this._cartRepository) : super(const CartState());

  final CartRepository _cartRepository;

  /// Calculates the number of bags (quantity) based on ton/bag mode and package weight.
  /// 1 Ton = 1000 KG.
  /// If ton mode: quantity (tons) * (1000 / packageWeightKg).
  /// If bag mode: quantity (bags).
  int calculateQuantityBags({
    required double quantity,
    required bool isTonMode,
    required double packageWeightKg,
  }) {
    if (isTonMode) {
      final weight = packageWeightKg > 0 ? packageWeightKg : 50.0;
      final bagsPerTon = 1000.0 / weight;
      final bags = (quantity * bagsPerTon).round();
      return bags > 0 ? bags : 1;
    } else {
      final bags = quantity.toInt();
      return bags > 0 ? bags : 1;
    }
  }

  Future<bool> addToCart({
    required int productId,
    required int productPackageId,
    required double packageWeightKg,
    required double quantity,
    required bool isTonMode,
  }) async {
    final int calculatedQuantity = calculateQuantityBags(
      quantity: quantity,
      isTonMode: isTonMode,
      packageWeightKg: packageWeightKg,
    );

    emit(state.copyWith(status: CartStatus.loading, errorMessage: null));

    final requestBody = AddToCartRequestBody(
      productId: productId,
      productPackageId: productPackageId,
      packageWeightKg: packageWeightKg,
      quantity: calculatedQuantity,
    );

    final result = await _cartRepository.addToCart(requestBody);

    return result.when(
      success: (cartResponse) {
        emit(
          state.copyWith(
            status: CartStatus.success,
            cart: cartResponse,
            successMessage: 'تمت إضافة المنتج إلى السلة بنجاح 🌾',
          ),
        );
        // Fetch the accurate count from API
        getCartCount();
        return true;
      },
      failure: (errorHandler) {
        emit(
          state.copyWith(
            status: CartStatus.error,
            errorMessage: errorHandler.getMessage,
          ),
        );
        return false;
      },
    );
  }

  void resetStatus() {
    emit(
      state.copyWith(
        status: CartStatus.initial,
        errorMessage: null,
        successMessage: null,
      ),
    );
  }

  Future<void> getCartCount() async {
    final result = await _cartRepository.getCartCount();

    result.when(
      success: (cartCountResponse) {
        emit(state.copyWith(totalItemsCount: cartCountResponse.count));
      },
      failure: (errorHandler) {
        // Optionally handle error or fail silently
      },
    );
  }

  Future<void> getCart({bool isSilent = false}) async {
    if (!isSilent) {
      emit(state.copyWith(status: CartStatus.loading, errorMessage: null));
    }

    final result = await _cartRepository.getCart();

    result.when(
      success: (cartResponse) {
        emit(state.copyWith(status: CartStatus.success, cart: cartResponse));
        // Fetch count to stay in sync
        getCartCount();
      },
      failure: (errorHandler) {
        if (!isSilent) {
          emit(
            state.copyWith(
              status: CartStatus.error,
              errorMessage: errorHandler.getMessage,
            ),
          );
        }
      },
    );
  }

  Future<void> clearCart() async {
    emit(state.copyWith(isDeleting: true, errorMessage: null));

    final result = await _cartRepository.clearCart();

    result.when(
      success: (_) {
        // Clear the cart in the UI and reset the counter
        emit(
          state.copyWith(
            isDeleting: false,
            status: CartStatus.success,
            cart: const CartResponseModel(
              id: 0,
              items: [],
              totalItemsCount: 0,
              totalWeightKg: 0,
              totalWeightTons: 0,
              totalPrice: 0,
            ),
            totalItemsCount: 0,
          ),
        );
      },
      failure: (errorHandler) {
        emit(
          state.copyWith(
            isDeleting: false,
            status: CartStatus.error,
            errorMessage: errorHandler.getMessage,
          ),
        );
      },
    );
  }

  Future<void> updateCartItem(int itemId, int newQuantity) async {
    // Capture original order before the request
    final originalIds = state.cart?.items.map((e) => e.id).toList() ?? [];

    final result = await _cartRepository.updateCartItem(
      itemId,
      UpdateCartItemRequestBody(quantity: newQuantity),
    );

    result.when(
      success: (updatedCart) {
        // Restore the original order from API response
        final itemsMap = {for (final i in updatedCart.items) i.id: i};
        final sortedItems = [
          for (final id in originalIds)
            if (itemsMap.containsKey(id)) itemsMap[id]!,
          // In case API added new items not in original list
          for (final i in updatedCart.items)
            if (!originalIds.contains(i.id)) i,
        ];

        final reorderedCart = CartResponseModel(
          id: updatedCart.id,
          items: sortedItems,
          totalItemsCount: updatedCart.totalItemsCount,
          totalWeightKg: updatedCart.totalWeightKg,
          totalWeightTons: updatedCart.totalWeightTons,
          totalPrice: updatedCart.totalPrice,
        );

        emit(
          state.copyWith(
            status: CartStatus.success,
            cart: reorderedCart,
            totalItemsCount: reorderedCart.items.length,
          ),
        );
      },
      failure: (errorHandler) {
        emit(
          state.copyWith(
            status: CartStatus.error,
            errorMessage: errorHandler.getMessage,
          ),
        );
      },
    );
  }

  Future<void> deleteCartItem(int itemId) async {
    // Optimistically remove from state immediately for snappy UX and trigger loading overlay
    final currentItems = state.cart?.items ?? [];
    final updatedItems = currentItems.where((e) => e.id != itemId).toList();

    if (state.cart != null) {
      emit(
        state.copyWith(
          isDeleting: true,
          cart: CartResponseModel(
            id: state.cart!.id,
            items: updatedItems,
            totalItemsCount: updatedItems.length,
            totalWeightKg: state.cart!.totalWeightKg,
            totalWeightTons: state.cart!.totalWeightTons,
            totalPrice: state.cart!.totalPrice,
          ),
          totalItemsCount: updatedItems.length,
        ),
      );
    } else {
      emit(state.copyWith(isDeleting: true));
    }

    // Send request to API
    final result = await _cartRepository.deleteCartItem(itemId);

    await result.when(
      success: (_) async {
        // Refresh cart silently to sync totals without showing full-page shimmer
        await getCart(isSilent: true);
        emit(state.copyWith(isDeleting: false));
      },
      failure: (errorHandler) {
        // Restore original items on failure
        emit(
          state.copyWith(
            isDeleting: false,
            cart: state.cart != null
                ? CartResponseModel(
                    id: state.cart!.id,
                    items: currentItems,
                    totalItemsCount: currentItems.length,
                    totalWeightKg: state.cart!.totalWeightKg,
                    totalWeightTons: state.cart!.totalWeightTons,
                    totalPrice: state.cart!.totalPrice,
                  )
                : null,
            totalItemsCount: currentItems.length,
            status: CartStatus.error,
            errorMessage: errorHandler.getMessage,
          ),
        );
      },
    );
  }
}
