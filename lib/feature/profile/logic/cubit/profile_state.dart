import 'package:aleman/core/network/failure/api_error_model.dart';
import 'package:aleman/feature/profile/data/model/user_profile_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_state.freezed.dart';

@freezed
class ProfileState with _$ProfileState {
  const factory ProfileState.initial() = _Initial;
  const factory ProfileState.loading() = _Loading;
  const factory ProfileState.success(UserProfileModel profile) = _Success;
  const factory ProfileState.error(ApiErrorModel error) = _Error;
}
