import 'package:aleman/core/network/apiResult/api_reuslt.dart';
import 'package:aleman/feature/home/data/mapper/banner_mapper.dart';
import 'package:aleman/feature/home/data/mapper/category_mapper.dart';
import 'package:aleman/feature/home/data/repository/home_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_cuibt_state.dart';
part 'home_cuibt_cubit.freezed.dart';

class HomeCuibtCubit extends Cubit<HomeCuibtState> {
  HomeCuibtCubit(this._homeRepository) : super(const HomeCuibtState());
  
  final HomeRepository _homeRepository;

  Future<void> fetchHomeData() async {
    await Future.wait([
      fetchBanners(),
      fetchCategories(),
    ]);
  }

  Future<void> fetchBanners() async {
    emit(state.copyWith(bannersStatus: RequestStatus.loading));

    final response = await _homeRepository.getBannerRepo();

    response.when(
      success: (banners) {
        final activeBanners = banners.where((b) => b.isActive).toList();
        emit(state.copyWith(
          bannersStatus: RequestStatus.success,
          banners: activeBanners,
        ));
      },
      failure: (error) {
        emit(state.copyWith(
          bannersStatus: RequestStatus.error,
          bannersError: error.message ?? 'حدث خطأ غير معروف',
        ));
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
        activeCategories.sort((a, b) => a.id.compareTo(b.id)); // Sort by ID ascending
        emit(state.copyWith(
          categoriesStatus: RequestStatus.success,
          categories: activeCategories,
        ));
      },
      failure: (error) {
        emit(state.copyWith(
          categoriesStatus: RequestStatus.error,
          categoriesError: error.message ?? 'حدث خطأ غير معروف',
        ));
      },
    );
  }

  void changeSelectedCategory(String categoryName) {
    emit(state.copyWith(selectedCategory: categoryName));
  }
}
