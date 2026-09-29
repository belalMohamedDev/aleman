import 'dart:io';

import 'package:aleman/core/network/apiResult/api_reuslt.dart';
import 'package:aleman/core/services/user_role_helper.dart';
import 'package:aleman/feature/profile/data/repository/profile_repository.dart';
import 'package:aleman/feature/profile/logic/cubit/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _profileRepository;
  final ImagePicker _imagePicker;

  ProfileCubit(
    this._profileRepository, {
    ImagePicker? imagePicker,
  })  : _imagePicker = imagePicker ?? ImagePicker(),
        super(const ProfileState.initial());

  Future<void> fetchUserProfile() async {
    emit(const ProfileState.loading());
    final response = await _profileRepository.getUserProfile();

    response.when(
      success: (profileData) {
        UserRoleHelper.setRole(profileData.role);
        emit(ProfileState.success(profileData));
      },
      failure: (errorHandler) {
        emit(ProfileState.error(errorHandler));
      },
    );
  }

  Future<void> pickAndUploadImage(ImageSource source) async {
    final currentState = state;
    if (currentState is! ProfileSuccess) return;

    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile == null) return;

      emit(currentState.copyWith(
        isUploadingImage: true,
        imageUploadError: null,
        imageUploadSuccess: null,
      ));

      final response = await _profileRepository.updateProfileImage(
        File(pickedFile.path),
      );

      response.when(
        success: (result) {
          final updatedProfile = currentState.profile.copyWith(
            profileImageUrl: result.profileImageUrl,
          );
          emit(currentState.copyWith(
            profile: updatedProfile,
            isUploadingImage: false,
            imageUploadSuccess: result.message,
            imageUploadError: null,
          ));
        },
        failure: (error) {
          emit(currentState.copyWith(
            isUploadingImage: false,
            imageUploadError: error.message,
            imageUploadSuccess: null,
          ));
        },
      );
    } catch (e) {
      emit(currentState.copyWith(
        isUploadingImage: false,
        imageUploadError: 'حدث خطأ أثناء اختيار الصورة',
        imageUploadSuccess: null,
      ));
    }
  }

  Future<void> removeProfileImage() async {
    final currentState = state;
    if (currentState is! ProfileSuccess) return;

    emit(currentState.copyWith(
      isUploadingImage: true,
      imageUploadError: null,
      imageUploadSuccess: null,
    ));

    final response = await _profileRepository.removeProfileImage();

    response.when(
      success: (result) {
        final updatedProfile = currentState.profile.copyWith(
          profileImageUrl: null,
        );
        emit(currentState.copyWith(
          profile: updatedProfile,
          isUploadingImage: false,
          imageUploadSuccess: result.message,
          imageUploadError: null,
        ));
      },
      failure: (error) {
        emit(currentState.copyWith(
          isUploadingImage: false,
          imageUploadError: error.message,
          imageUploadSuccess: null,
        ));
      },
    );
  }
}
