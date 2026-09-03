part of 'home_cuibt_cubit.dart';

enum RequestStatus { initial, loading, success, error }

@freezed
abstract class HomeCuibtState with _$HomeCuibtState {
  const factory HomeCuibtState({
    // Banners
    @Default(RequestStatus.initial) RequestStatus bannersStatus,
    @Default([]) List<BannerEntity> banners,
    @Default(0) int bannerIndex,
    String? bannersError,

    // Categories
    @Default(RequestStatus.initial) RequestStatus categoriesStatus,
    @Default([]) List<CategoryEntity> categories,
    @Default(1) int selectedCategoryId,
    String? categoriesError,

    // Products
    @Default(RequestStatus.initial) RequestStatus productsStatus,
    @Default([]) List<ProductEntity> products,
    String? productsError,

    // Product Details Bottom Sheet
    @Default(1) int quantity,
  }) = _HomeCuibtState;
}
