import 'package:aleman/core/network/apiResult/api_reuslt.dart';
import 'package:aleman/feature/profile/data/repository/profile_repository.dart';
import 'package:aleman/feature/profile/logic/cubit/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _profileRepository;

  ProfileCubit(this._profileRepository) : super(const ProfileState.initial());

  Future<void> fetchUserProfile() async {
    emit(const ProfileState.loading());
    final response = await _profileRepository.getUserProfile();

    response.when(
      success: (profileData) {
        emit(ProfileState.success(profileData));
      },
      failure: (errorHandler) {
        emit(ProfileState.error(errorHandler));
      },
    );
  }
}
