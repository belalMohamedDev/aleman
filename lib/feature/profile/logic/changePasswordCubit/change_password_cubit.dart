import 'package:aleman/core/network/apiResult/api_reuslt.dart';
import 'package:aleman/feature/profile/data/model/change_password_request_body.dart';
import 'package:aleman/feature/profile/data/repository/profile_repository.dart';
import 'package:aleman/feature/profile/logic/changePasswordCubit/change_password_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final ProfileRepository _profileRepository;

  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ChangePasswordCubit(this._profileRepository)
      : super(const ChangePasswordState());

  void toggleCurrentPasswordVisibility() {
    emit(state.copyWith(showCurrentPassword: !state.showCurrentPassword));
  }

  void toggleNewPasswordVisibility() {
    emit(state.copyWith(showNewPassword: !state.showNewPassword));
  }

  void toggleConfirmPasswordVisibility() {
    emit(state.copyWith(showConfirmPassword: !state.showConfirmPassword));
  }

  void validateFields() {
    final current = currentPasswordController.text;
    final newPass = newPasswordController.text;
    final confirm = confirmPasswordController.text;

    final bool isValid =
        current.isNotEmpty && newPass.length >= 6 && confirm == newPass;

    emit(
      state.copyWith(
        currentPassword: current,
        newPassword: newPass,
        confirmPassword: confirm,
        isFormValid: isValid,
      ),
    );
  }

  Future<void> changePassword() async {
    if (!state.isFormValid) return;

    emit(
      state.copyWith(
        status: ChangePasswordStatus.loading,
        errorMessage: null,
        successMessage: null,
      ),
    );

    final result = await _profileRepository.changePassword(
      ChangePasswordRequestBody(
        currentPassword: currentPasswordController.text,
        newPassword: newPasswordController.text,
        confirmPassword: confirmPasswordController.text,
      ),
    );

    result.when(
      success: (response) {
        emit(
          state.copyWith(
            status: ChangePasswordStatus.success,
            successMessage: response.message,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            status: ChangePasswordStatus.error,
            errorMessage: error.message,
          ),
        );
      },
    );
  }

  @override
  Future<void> close() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    return super.close();
  }
}
