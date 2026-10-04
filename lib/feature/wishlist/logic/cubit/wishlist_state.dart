import 'package:aleman/feature/wishlist/data/mapper/wishlist_mapper.dart';

enum WishlistStatus { initial, loading, success, error }

class WishlistState {
  final WishlistStatus status;
  final List<WishlistItemEntity> items;
  final Set<int> wishlistProductIds;
  final int count;
  final String? errorMessage;
  final String? successMessage;
  final bool isToggling;

  const WishlistState({
    this.status = WishlistStatus.initial,
    this.items = const [],
    this.wishlistProductIds = const {},
    this.count = 0,
    this.errorMessage,
    this.successMessage,
    this.isToggling = false,
  });

  bool isProductWishlisted(int productId) =>
      wishlistProductIds.contains(productId);

  WishlistState copyWith({
    WishlistStatus? status,
    List<WishlistItemEntity>? items,
    Set<int>? wishlistProductIds,
    int? count,
    String? errorMessage,
    String? successMessage,
    bool? isToggling,
  }) {
    return WishlistState(
      status: status ?? this.status,
      items: items ?? this.items,
      wishlistProductIds: wishlistProductIds ?? this.wishlistProductIds,
      count: count ?? this.count,
      errorMessage: errorMessage,
      successMessage: successMessage,
      isToggling: isToggling ?? this.isToggling,
    );
  }
}
