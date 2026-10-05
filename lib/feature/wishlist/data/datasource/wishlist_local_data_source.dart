import 'dart:convert';

import 'package:aleman/core/services/app_storage_key.dart';
import 'package:aleman/core/services/shared_pref_helper.dart';
import 'package:aleman/feature/wishlist/data/mapper/wishlist_mapper.dart';

abstract class WishlistLocalDataSource {
  Future<List<WishlistItemEntity>> getLocalWishlist();
  Future<void> saveLocalWishlist(List<WishlistItemEntity> items);
  Future<void> addToLocalWishlist(WishlistItemEntity item);
  Future<void> removeFromLocalWishlist(int productId);
  Future<void> clearLocalWishlist();
  Future<List<int>> getLocalWishlistIds();
  Future<bool> isLocalWishlisted(int productId);
}

class WishlistLocalDataSourceImpl implements WishlistLocalDataSource {
  @override
  Future<List<WishlistItemEntity>> getLocalWishlist() async {
    try {
      final jsonString = SharedPrefHelper.getString(PrefKeys.localWishlist);
      if (jsonString.isEmpty) return [];

      final decoded = jsonDecode(jsonString);
      if (decoded is List) {
        return decoded
            .map((item) =>
                WishlistItemEntity.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> saveLocalWishlist(List<WishlistItemEntity> items) async {
    try {
      final jsonList = items.map((item) => item.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      await SharedPrefHelper.setData(PrefKeys.localWishlist, jsonString);
    } catch (_) {}
  }

  @override
  Future<void> addToLocalWishlist(WishlistItemEntity item) async {
    final currentItems = await getLocalWishlist();
    currentItems.removeWhere((existing) => existing.productId == item.productId);
    currentItems.insert(0, item);
    await saveLocalWishlist(currentItems);
  }

  @override
  Future<void> removeFromLocalWishlist(int productId) async {
    final currentItems = await getLocalWishlist();
    currentItems.removeWhere((item) => item.productId == productId);
    await saveLocalWishlist(currentItems);
  }

  @override
  Future<void> clearLocalWishlist() async {
    await SharedPrefHelper.removeData(PrefKeys.localWishlist);
  }

  @override
  Future<List<int>> getLocalWishlistIds() async {
    final items = await getLocalWishlist();
    return items.map((item) => item.productId).toList();
  }

  @override
  Future<bool> isLocalWishlisted(int productId) async {
    final ids = await getLocalWishlistIds();
    return ids.contains(productId);
  }
}
