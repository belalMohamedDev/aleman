import 'package:aleman/core/network/apiResult/api_reuslt.dart';
import 'package:aleman/feature/home/data/mapper/banner_mapper.dart';
import 'package:aleman/feature/home/data/repository/home_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_cuibt_state.dart';
part 'home_cuibt_cubit.freezed.dart';

class HomeCuibtCubit extends Cubit<HomeCuibtState> {
  HomeCuibtCubit(this._homeRepository) : super(HomeCuibtState.initial());
  final HomeRepository _homeRepository;
  Future<void> fetchBanners() async {
    emit(const HomeCuibtState.getBannersLoading());

    final response = await _homeRepository.getBannerRepo();

    response.when(
      success: (banners) {
        final activeBanners = banners.where((b) => b.isActive).toList();
        emit(HomeCuibtState.getBannersSuccess(activeBanners));
      },
      failure: (error) {
        emit(
          HomeCuibtState.getBannersError(error.message ?? 'حدث خطأ غير معروف'),
        );
      },
    );
  }

  void changeBannerIndex(int index) {
    state.mapOrNull(
      getBannersSuccess: (successState) {
        emit(successState.copyWith(bannerIndex: index));
      },
    );
  }
}
