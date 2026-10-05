import 'package:aleman/core/network/apiResult/api_reuslt.dart';
import 'package:aleman/feature/wishlist/data/mapper/wishlist_mapper.dart';

abstract class WishlistRepository {
  // Remote
  Future<ApiResult<List<WishlistItemEntity>>> getWishlist();
  Future<ApiResult<bool>> toggleWishlist(int productId);
  Future<ApiResult<bool>> addToWishlist(int productId);
  Future<ApiResult<bool>> removeFromWishlist(int productId);
  Future<ApiResult<List<int>>> getWishlistIds();
  Future<ApiResult<int>> getWishlistCount();
  Future<ApiResult<bool>> clearWishlist();

  // Local
  Future<List<WishlistItemEntity>> getLocalWishlist();
  Future<void> saveLocalWishlist(List<WishlistItemEntity> items);
  Future<void> addToLocalWishlist(WishlistItemEntity item);
  Future<void> removeFromLocalWishlist(int productId);
  Future<void> clearLocalWishlist();
  Future<List<int>> getLocalWishlistIds();
}
