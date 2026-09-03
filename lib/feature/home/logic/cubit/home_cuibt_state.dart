part of 'home_cuibt_cubit.dart';

@freezed
class HomeCuibtState with _$HomeCuibtState {
  const factory HomeCuibtState.initial() = _Initial;

  // Banners States
  const factory HomeCuibtState.getBannersLoading() = GetBannersLoading;
  const factory HomeCuibtState.getBannersSuccess(
    List<BannerEntity> banners, {
    @Default(0) int bannerIndex,
  }) = GetBannersSuccess;
  const factory HomeCuibtState.getBannersError(String error) = GetBannersError;
}
