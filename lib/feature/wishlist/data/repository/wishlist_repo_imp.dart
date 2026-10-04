import 'package:aleman/core/network/api/app_api.dart';
import 'package:aleman/core/network/apiResult/api_reuslt.dart';
import 'package:aleman/core/network/error_handler/api_error_handler.dart';
import 'package:aleman/feature/wishlist/data/mapper/wishlist_mapper.dart';
import 'package:aleman/feature/wishlist/data/model/wishlist_model.dart';
import 'package:aleman/feature/wishlist/data/repository/wishlist_repo.dart';

class WishlistRepositoryImplement implements WishlistRepository {
  final AppServiceClient _apiService;

  WishlistRepositoryImplement(this._apiService);

  @override
  Future<ApiResult<List<WishlistItemEntity>>> getWishlist() async {
    try {
      final response = await _apiService.getWishlistService();
      List<dynamic> itemsList = [];
      if (response is List) {
        itemsList = response;
      } else if (response is Map && response['items'] is List) {
        itemsList = response['items'] as List;
      }

      final items = itemsList
          .map((json) =>
              WishlistItemModel.fromJson(json as Map<String, dynamic>).toEntity())
          .toList();

      return ApiResult.success(items);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<bool>> toggleWishlist(int productId) async {
    try {
      final response = await _apiService.toggleWishlistService(productId);
      bool isWishlisted = false;
      if (response is Map) {
        isWishlisted = response['isWishlisted'] as bool? ??
            response['isAdded'] as bool? ??
            false;
      } else if (response is bool) {
        isWishlisted = response;
      }
      return ApiResult.success(isWishlisted);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<bool>> removeFromWishlist(int productId) async {
    try {
      await _apiService.removeFromWishlistService(productId);
      return ApiResult.success(true);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<List<int>>> getWishlistIds() async {
    try {
      final response = await _apiService.getWishlistIdsService();
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<int>> getWishlistCount() async {
    try {
      final response = await _apiService.getWishlistCountService();
      int count = 0;
      if (response is int) {
        count = response;
      } else if (response is Map && response['count'] is int) {
        count = response['count'] as int;
      }
      return ApiResult.success(count);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<bool>> clearWishlist() async {
    try {
      await _apiService.clearWishlistService();
      return ApiResult.success(true);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
