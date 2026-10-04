import 'dart:async';

import 'package:aleman/core/network/apiResult/api_reuslt.dart';
import 'package:aleman/core/services/app_storage_key.dart';
import 'package:aleman/core/services/auth_event_bus.dart';
import 'package:aleman/core/services/shared_pref_helper.dart';
import 'package:aleman/feature/home/data/mapper/banner_mapper.dart';
import 'package:aleman/feature/home/data/mapper/category_mapper.dart';
import 'package:aleman/feature/home/data/mapper/product_mapper.dart';
import 'package:aleman/feature/home/data/repository/home_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_cuibt_state.dart';
part 'home_cuibt_cubit.freezed.dart';

class HomeCuibtCubit extends Cubit<HomeCuibtState> {
  HomeCuibtCubit(this._homeRepository) : super(const HomeCuibtState()) {
    _authSubscription = AuthEventBus.stream.listen((event) {
      if (!isClosed) {
        fetchHomeData();
      }
    });
  }

  final HomeRepository _homeRepository;
  StreamSubscription<AuthEvent>? _authSubscription;

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }

  bool _isFetchingHomeData = false;

  Future<void> fetchHomeData() async {
    if (_isFetchingHomeData) return;
    _isFetchingHomeData = true;

    try {
      checkLoginStatus();

      emit(
        state.copyWith(
          bannersStatus: state.banners.isEmpty
              ? RequestStatus.loading
              : state.bannersStatus,
          categoriesStatus: state.categories.isEmpty
              ? RequestStatus.loading
              : state.categoriesStatus,
          productsStatus: state.products.isEmpty
              ? RequestStatus.loading
              : state.productsStatus,
        ),
      );

      final response = await _homeRepository.getHomeDataRepo();

      response.when(
        success: (homeData) {
          final activeBanners =
              homeData.banners.where((b) => b.isActive).toList();
          final activeCategories =
              homeData.categories.where((c) => c.isActive).toList();
          final activeFeatured =
              homeData.featuredProducts.where((p) => p.isActive).toList();
          final activeBestSellers =
              homeData.bestSellers.where((p) => p.isActive).toList();

          emit(
            state.copyWith(
              bannersStatus: RequestStatus.success,
              banners: activeBanners,
              bannersError: null,
              categoriesStatus: RequestStatus.success,
              categories: activeCategories,
              categoriesError: null,
              productsStatus: RequestStatus.success,
              featuredProducts: activeFeatured,
              bestSellers: activeBestSellers,
              products: activeBestSellers.isNotEmpty
                  ? activeBestSellers
                  : activeFeatured,
              productsError: null,
            ),
          );
        },
        failure: (error) {
          final errorMsg = error.message ?? 'حدث خطأ أثناء تحميل البيانات';
          emit(
            state.copyWith(
              bannersStatus: state.banners.isEmpty
                  ? RequestStatus.error
                  : state.bannersStatus,
              bannersError: errorMsg,
              categoriesStatus: state.categories.isEmpty
                  ? RequestStatus.error
                  : state.categoriesStatus,
              categoriesError: errorMsg,
              productsStatus: state.products.isEmpty
                  ? RequestStatus.error
                  : state.productsStatus,
              productsError: errorMsg,
            ),
          );
        },
      );
    } finally {
      _isFetchingHomeData = false;
    }
  }

  Future<void> checkLoginStatus() async {
    final token = await SharedPrefHelper.getSecuredString(
      PrefKeys.userAccessToken,
    );
    final isDismissed = SharedPrefHelper.getBool(
      PrefKeys.hasDismissedLoginPrompt,
    );
    emit(
      state.copyWith(
        isLoggedIn: token.isNotEmpty,
        showLoginPrompt: token.isEmpty && !isDismissed,
      ),
    );
  }

  Future<void> dismissLoginPrompt() async {
    emit(state.copyWith(showLoginPrompt: false));
    await SharedPrefHelper.setData(PrefKeys.hasDismissedLoginPrompt, true);
  }

  Future<void> fetchBanners() async {
    emit(state.copyWith(bannersStatus: RequestStatus.loading));

    final response = await _homeRepository.getBannerRepo();

    response.when(
      success: (banners) {
        final activeBanners = banners.where((b) => b.isActive).toList();
        emit(
          state.copyWith(
            bannersStatus: RequestStatus.success,
            banners: activeBanners,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            bannersStatus: RequestStatus.error,
            bannersError: error.message ?? 'ط­ط¯ط« ط®ط·ط£ ط؛ظٹط± ظ…ط¹ط±ظˆظپ',
          ),
        );
      },
    );
  }

  void changeBannerIndex(int index) {
    emit(state.copyWith(bannerIndex: index));
  }

  Future<void> fetchCategories() async {
    emit(state.copyWith(categoriesStatus: RequestStatus.loading));

    final response = await _homeRepository.getCategoryRepo();

    response.when(
      success: (categories) {
        final activeCategories = categories.where((c) => c.isActive).toList();
        emit(
          state.copyWith(
            categoriesStatus: RequestStatus.success,
            categories: activeCategories,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            categoriesStatus: RequestStatus.error,
            categoriesError: error.message ?? 'ط­ط¯ط« ط®ط·ط£ ط؛ظٹط± ظ…ط¹ط±ظˆظپ',
          ),
        );
      },
    );
  }

  void changeSelectedCategory(int categoryId) {
    emit(state.copyWith(selectedCategoryId: categoryId));
  }

  Future<void> fetchProducts() async {
    emit(state.copyWith(productsStatus: RequestStatus.loading));

    final response = await _homeRepository.getProductRepo();

    response.when(
      success: (products) {
        final activeProducts = products.where((p) => p.isActive).toList();
        emit(
          state.copyWith(
            productsStatus: RequestStatus.success,
            products: activeProducts,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            productsStatus: RequestStatus.error,
            productsError: error.message ?? 'ط­ط¯ط« ط®ط·ط£ ط؛ظٹط± ظ…ط¹ط±ظˆظپ',
          ),
        );
      },
    );
  }

  void incrementQuantity() {
    // In ton mode increment by 0.5, otherwise by 1
    final step = state.isTonMode ? 0.5 : 1.0;
    emit(state.copyWith(quantity: state.quantity + step));
  }

  void decrementQuantity() {
    final step = state.isTonMode ? 0.5 : 1.0;
    final minVal = state.isTonMode ? 0.5 : 1.0;
    if (state.quantity > minVal) {
      emit(state.copyWith(quantity: state.quantity - step));
    }
  }

  void resetQuantity() {
    emit(
      state.copyWith(quantity: 1, isTonMode: false, selectedPackageIndex: 0),
    );
  }

  void setQuantity(double val) {
    if (val > 0) {
      emit(state.copyWith(quantity: val));
    }
  }

  void toggleTonMode(bool isTon) {
    // Reset quantity to sensible default when switching modes
    emit(state.copyWith(isTonMode: isTon, quantity: isTon ? 1.0 : 1.0));
  }

  void selectPackage(int index) {
    emit(state.copyWith(selectedPackageIndex: index));
  }
}

