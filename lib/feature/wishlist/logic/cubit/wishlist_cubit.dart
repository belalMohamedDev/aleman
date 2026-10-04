import 'dart:async';

import 'package:aleman/core/network/apiResult/api_reuslt.dart';
import 'package:aleman/core/services/app_storage_key.dart';
import 'package:aleman/core/services/auth_event_bus.dart';
import 'package:aleman/core/services/shared_pref_helper.dart';
import 'package:aleman/feature/wishlist/data/mapper/wishlist_mapper.dart';
import 'package:aleman/feature/wishlist/data/repository/wishlist_repo.dart';
import 'package:aleman/feature/wishlist/logic/cubit/wishlist_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WishlistCubit extends Cubit<WishlistState> {
  final WishlistRepository _wishlistRepository;
  StreamSubscription<AuthEvent>? _authSubscription;

  WishlistCubit(this._wishlistRepository) : super(const WishlistState()) {
    _authSubscription = AuthEventBus.stream.listen((event) {
      if (!isClosed) {
        if (event == AuthEvent.loggedIn) {
          loadWishlistIds();
        } else if (event == AuthEvent.loggedOut) {
          emit(const WishlistState());
        }
      }
    });
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }

  /// Check if user has access token
  Future<bool> _isLoggedIn() async {
    final token = await SharedPrefHelper.getSecuredString(
      PrefKeys.userAccessToken,
    );
    return token.isNotEmpty;
  }

  /// Load only wishlist product IDs (very lightweight, perfect for coloring hearts across app)
  Future<void> loadWishlistIds() async {
    if (!await _isLoggedIn()) return;

    final result = await _wishlistRepository.getWishlistIds();
    result.when(
      success: (ids) {
        emit(
          state.copyWith(
            wishlistProductIds: ids.toSet(),
            count: ids.length,
          ),
        );
      },
      failure: (_) {},
    );
  }

  /// Load full wishlist items for WishlistScreen
  Future<void> getWishlist() async {
    if (!await _isLoggedIn()) {
      emit(
        state.copyWith(
          status: WishlistStatus.error,
          errorMessage: 'يرجى تسجيل الدخول لعرض المفضلة',
        ),
      );
      return;
    }

    emit(state.copyWith(status: WishlistStatus.loading, errorMessage: null));

    final result = await _wishlistRepository.getWishlist();
    result.when(
      success: (items) {
        final ids = items.map((e) => e.productId).toSet();
        emit(
          state.copyWith(
            status: WishlistStatus.success,
            items: items,
            wishlistProductIds: ids,
            count: items.length,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            status: WishlistStatus.error,
            errorMessage: error.message ?? 'فشل في تحميل قائمة المفضلة',
          ),
        );
      },
    );
  }

  /// Toggle item in wishlist (Optimistic UI update)
  Future<bool> toggleWishlist(
    int productId, {
    WishlistItemEntity? itemToAdd,
  }) async {
    if (!await _isLoggedIn()) {
      emit(
        state.copyWith(
          errorMessage: 'يرجى تسجيل الدخول أولاً لإضافة المنتج للمفضلة',
        ),
      );
      return false;
    }

    final isCurrentlyWishlisted = state.isProductWishlisted(productId);
    final previousIds = Set<int>.from(state.wishlistProductIds);
    final previousItems = List<WishlistItemEntity>.from(state.items);
    final previousCount = state.count;

    // Optimistic state
    final updatedIds = Set<int>.from(previousIds);
    final updatedItems = List<WishlistItemEntity>.from(previousItems);

    if (isCurrentlyWishlisted) {
      updatedIds.remove(productId);
      updatedItems.removeWhere((item) => item.productId == productId);
    } else {
      updatedIds.add(productId);
      if (itemToAdd != null) {
        updatedItems.insert(0, itemToAdd);
      }
    }

    emit(
      state.copyWith(
        wishlistProductIds: updatedIds,
        items: updatedItems,
        count: updatedIds.length,
        isToggling: true,
      ),
    );

    final result = await _wishlistRepository.toggleWishlist(productId);

    return result.when(
      success: (isWishlisted) {
        // Ensure server state matches
        final finalIds = Set<int>.from(state.wishlistProductIds);
        if (isWishlisted) {
          finalIds.add(productId);
        } else {
          finalIds.remove(productId);
        }
        emit(
          state.copyWith(
            wishlistProductIds: finalIds,
            count: finalIds.length,
            isToggling: false,
            successMessage: isWishlisted
                ? 'تمت إضافة المنتج إلى المفضلة'
                : 'تمت إزالة المنتج من المفضلة',
          ),
        );
        return isWishlisted;
      },
      failure: (error) {
        // Rollback optimistic state
        emit(
          state.copyWith(
            wishlistProductIds: previousIds,
            items: previousItems,
            count: previousCount,
            isToggling: false,
            errorMessage: error.message ?? 'تعذر تحديث المفضلة',
          ),
        );
        return isCurrentlyWishlisted;
      },
    );
  }

  /// Remove item explicitly
  Future<void> removeFromWishlist(int productId) async {
    final previousIds = Set<int>.from(state.wishlistProductIds);
    final previousItems = List<WishlistItemEntity>.from(state.items);

    final updatedIds = Set<int>.from(previousIds)..remove(productId);
    final updatedItems = List<WishlistItemEntity>.from(previousItems)
      ..removeWhere((item) => item.productId == productId);

    emit(
      state.copyWith(
        wishlistProductIds: updatedIds,
        items: updatedItems,
        count: updatedIds.length,
      ),
    );

    final result = await _wishlistRepository.removeFromWishlist(productId);
    result.when(
      success: (_) {
        emit(
          state.copyWith(
            successMessage: 'تم حذف المنتج من المفضلة',
          ),
        );
      },
      failure: (error) {
        // Rollback
        emit(
          state.copyWith(
            wishlistProductIds: previousIds,
            items: previousItems,
            count: previousIds.length,
            errorMessage: error.message ?? 'فشل في حذف المنتج',
          ),
        );
      },
    );
  }

  /// Clear entire wishlist
  Future<void> clearWishlist() async {
    final previousIds = Set<int>.from(state.wishlistProductIds);
    final previousItems = List<WishlistItemEntity>.from(state.items);

    emit(
      state.copyWith(
        wishlistProductIds: const {},
        items: const [],
        count: 0,
      ),
    );

    final result = await _wishlistRepository.clearWishlist();
    result.when(
      success: (_) {
        emit(
          state.copyWith(
            successMessage: 'تم تفريغ المفضلة بالكامل',
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            wishlistProductIds: previousIds,
            items: previousItems,
            count: previousIds.length,
            errorMessage: error.message ?? 'فشل في تفريغ المفضلة',
          ),
        );
      },
    );
  }
}
