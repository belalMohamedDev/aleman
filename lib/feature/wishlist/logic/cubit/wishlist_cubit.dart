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
    _authSubscription = AuthEventBus.stream.listen((event) async {
      if (!isClosed) {
        if (event == AuthEvent.loggedIn) {
          await syncLocalWishlistWithRemote();
        } else if (event == AuthEvent.loggedOut) {
          // When logged out, reload local wishlist for the guest
          await getWishlist();
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

  /// Sync local wishlist items with backend upon user login
  Future<void> syncLocalWishlistWithRemote() async {
    if (!await _isLoggedIn()) return;

    try {
      final localItems = await _wishlistRepository.getLocalWishlist();
      if (localItems.isNotEmpty) {
        // Fetch current remote IDs to avoid redundant add calls
        final remoteIdsResult = await _wishlistRepository.getWishlistIds();
        final Set<int> remoteIds = remoteIdsResult.when(
          success: (ids) => ids.toSet(),
          failure: (_) => <int>{},
        );

        // Upload items not yet in remote wishlist
        for (final item in localItems) {
          if (!remoteIds.contains(item.productId)) {
            final addResult =
                await _wishlistRepository.addToWishlist(item.productId);
            addResult.when(
              success: (_) {},
              failure: (_) async {
                // Fallback to toggleWishlist if addToWishlist returns error
                await _wishlistRepository.toggleWishlist(item.productId);
              },
            );
          }
        }

        // Clear local wishlist after successful synchronization
        await _wishlistRepository.clearLocalWishlist();
      }
    } catch (_) {
      // Sync errors shouldn't crash the cubit
    }

    // Load full wishlist from server
    await getWishlist();
  }

  /// Load only wishlist product IDs (for coloring heart icons across app)
  Future<void> loadWishlistIds() async {
    final loggedIn = await _isLoggedIn();

    if (!loggedIn) {
      // Load local IDs for guest
      final localIds = await _wishlistRepository.getLocalWishlistIds();
      emit(
        state.copyWith(
          wishlistProductIds: localIds.toSet(),
          count: localIds.length,
        ),
      );
      return;
    }

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
    final loggedIn = await _isLoggedIn();

    if (!loggedIn) {
      // Load local wishlist for guest user
      final localItems = await _wishlistRepository.getLocalWishlist();
      final ids = localItems.map((e) => e.productId).toSet();
      emit(
        state.copyWith(
          status: WishlistStatus.success,
          items: localItems,
          wishlistProductIds: ids,
          count: localItems.length,
          errorMessage: null,
        ),
      );
      return;
    }

    // Only set loading if items are empty to prevent screen flicker
    if (state.items.isEmpty) {
      emit(state.copyWith(status: WishlistStatus.loading, errorMessage: null));
    }

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
            errorMessage: null,
          ),
        );
      },
      failure: (error) {
        if (state.items.isEmpty) {
          emit(
            state.copyWith(
              status: WishlistStatus.error,
              errorMessage: error.message ?? 'فشل في تحميل قائمة المفضلة',
            ),
          );
        }
      },
    );
  }

  /// Toggle item in wishlist (immediate UI update, supports both guest & logged in)
  Future<bool> toggleWishlist(
    int productId, {
    WishlistItemEntity? itemToAdd,
  }) async {
    final loggedIn = await _isLoggedIn();
    final isCurrentlyWishlisted = state.isProductWishlisted(productId);

    if (!loggedIn) {
      // ----------------- GUEST USER (LOCAL STORAGE) -----------------
      final updatedIds = Set<int>.from(state.wishlistProductIds);
      final updatedItems = List<WishlistItemEntity>.from(state.items);

      if (isCurrentlyWishlisted) {
        await _wishlistRepository.removeFromLocalWishlist(productId);
        updatedIds.remove(productId);
        updatedItems.removeWhere((item) => item.productId == productId);

        emit(
          state.copyWith(
            wishlistProductIds: updatedIds,
            items: updatedItems,
            count: updatedIds.length,
            successMessage: 'تمت إزالة المنتج من المفضلة',
          ),
        );
        return false;
      } else {
        if (itemToAdd != null) {
          await _wishlistRepository.addToLocalWishlist(itemToAdd);
          updatedItems.removeWhere((item) => item.productId == productId);
          updatedItems.insert(0, itemToAdd);
        }
        updatedIds.add(productId);

        emit(
          state.copyWith(
            wishlistProductIds: updatedIds,
            items: updatedItems,
            count: updatedIds.length,
            successMessage: 'تمت إضافة المنتج إلى المفضلة',
          ),
        );
        return true;
      }
    }

    // ----------------- LOGGED IN USER (SERVER SYNC) -----------------
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
        updatedItems.removeWhere((item) => item.productId == productId);
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
        final finalIds = Set<int>.from(state.wishlistProductIds);
        final finalItems = List<WishlistItemEntity>.from(state.items);

        if (isWishlisted) {
          finalIds.add(productId);
          if (itemToAdd != null &&
              !finalItems.any((it) => it.productId == productId)) {
            finalItems.insert(0, itemToAdd);
          }
        } else {
          finalIds.remove(productId);
          finalItems.removeWhere((it) => it.productId == productId);
        }

        emit(
          state.copyWith(
            wishlistProductIds: finalIds,
            items: finalItems,
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
    final loggedIn = await _isLoggedIn();

    if (!loggedIn) {
      await _wishlistRepository.removeFromLocalWishlist(productId);
      final updatedIds = Set<int>.from(state.wishlistProductIds)..remove(productId);
      final updatedItems = List<WishlistItemEntity>.from(state.items)
        ..removeWhere((item) => item.productId == productId);

      emit(
        state.copyWith(
          wishlistProductIds: updatedIds,
          items: updatedItems,
          count: updatedIds.length,
          successMessage: 'تم حذف المنتج من المفضلة',
        ),
      );
      return;
    }

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
    final loggedIn = await _isLoggedIn();

    if (!loggedIn) {
      await _wishlistRepository.clearLocalWishlist();
      emit(
        state.copyWith(
          wishlistProductIds: const {},
          items: const [],
          count: 0,
          successMessage: 'تم تفريغ المفضلة بالكامل',
        ),
      );
      return;
    }

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
