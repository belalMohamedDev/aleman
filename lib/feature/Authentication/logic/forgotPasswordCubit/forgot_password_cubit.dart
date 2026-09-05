import 'package:aleman/core/network/apiResult/api_reuslt.dart';
import 'package:aleman/core/utils/app_regex.dart';
import 'package:aleman/feature/Authentication/data/model/bodyRequest/forgot_password/forgot_password_request_body.dart';
import 'package:aleman/feature/Authentication/data/model/bodyRequest/forgot_password/reset_password_request_body.dart';
import 'package:aleman/feature/Authentication/data/model/bodyRequest/forgot_password/verify_reset_code_request_body.dart';
import 'package:aleman/feature/Authentication/data/repository/authentication_repository.dart';
import 'package:aleman/feature/Authentication/logic/forgotPasswordCubit/forgot_password_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_auth/smart_auth.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit(this._authenticationRepository)
      : super(const ForgotPasswordState());

  final AuthenticationRepository _authenticationRepository;
  final SmartAuth _smartAuth = SmartAuth.instance;

  final TextEditingController userPhoneController = TextEditingController();
  final TextEditingController otpCodeController = TextEditingController();
  final TextEditingController userNewPasswordController =
      TextEditingController();
  final TextEditingController userConfirmPasswordController =
      TextEditingController();

  final phoneFormKey = GlobalKey<FormState>();
  final otpFormKey = GlobalKey<FormState>();
  final newPasswordFormKey = GlobalKey<FormState>();

  void toggleNewPasswordVisibility() {
    emit(state.copyWith(showNewPassword: !state.showNewPassword));
  }

  void toggleConfirmPasswordVisibility() {
    emit(state.copyWith(showConfirmPassword: !state.showConfirmPassword));
  }

  void validatePhone() {
    final phone = userPhoneController.text.trim();
    final isValid = AppRegex.isPhoneNumberValid(phone);
    emit(state.copyWith(isPhoneValid: isValid));
  }

  void setOtpCode(String code) {
    otpCodeController.text = code;
    otpCodeController.selection = TextSelection.fromPosition(
      TextPosition(offset: otpCodeController.text.length),
    );
    validateCode();
  }

  void validateCode() {
    final code = otpCodeController.text.trim();
    final isValid = code.length >= 4;
    emit(state.copyWith(isCodeValid: isValid));
  }

  void validateNewPassword() {
    final password = userNewPasswordController.text;
    final confirmPassword = userConfirmPasswordController.text;
    final isPassValid = AppRegex.isPasswordValid(password);
    final isMatch = password.isNotEmpty && password == confirmPassword;
    emit(state.copyWith(isNewPasswordValid: isPassValid && isMatch));
  }

  Future<void> sendForgotPasswordCode() async {
    final phone = userPhoneController.text.trim();
    emit(state.copyWith(status: ForgotPasswordStatus.loading, error: null));

    final result = await _authenticationRepository.forgotPassword(
      ForgotPasswordRequestBody(phoneNumber: phone),
    );

    result.when(
      success: (message) {
        startListeningForSms();
        emit(
          state.copyWith(
            status: ForgotPasswordStatus.phoneSuccess,
            message: message,
          ),
        );
      },
      failure: (errorHandler) {
        emit(
          state.copyWith(
            status: ForgotPasswordStatus.error,
            error: errorHandler.getMessage,
          ),
        );
      },
    );
  }

  Future<void> resendCode() async {
    final phone = userPhoneController.text.trim();
    emit(state.copyWith(status: ForgotPasswordStatus.loading, error: null));

    final result = await _authenticationRepository.forgotPassword(
      ForgotPasswordRequestBody(phoneNumber: phone),
    );

    result.when(
      success: (message) {
        startListeningForSms();
        emit(
          state.copyWith(
            status: ForgotPasswordStatus.phoneSuccess,
            message: message,
          ),
        );
      },
      failure: (errorHandler) {
        emit(
          state.copyWith(
            status: ForgotPasswordStatus.error,
            error: errorHandler.getMessage,
          ),
        );
      },
    );
  }

  void startListeningForSms() async {
    try {
      final res = await _smartAuth.getSmsWithUserConsentApi();
      if (res.hasData && res.data != null && res.data!.code != null) {
        setOtpCode(res.data!.code!);
      }
    } catch (_) {}
  }

  Future<void> verifyResetCode() async {
    final phone = userPhoneController.text.trim();
    final code = otpCodeController.text.trim();
    emit(state.copyWith(status: ForgotPasswordStatus.loading, error: null));

    final result = await _authenticationRepository.verifyResetCode(
      VerifyResetCodeRequestBody(phoneNumber: phone, code: code),
    );

    result.when(
      success: (message) {
        emit(
          state.copyWith(
            status: ForgotPasswordStatus.verifyCodeSuccess,
            message: message,
          ),
        );
      },
      failure: (errorHandler) {
        emit(
          state.copyWith(
            status: ForgotPasswordStatus.error,
            error: errorHandler.getMessage,
          ),
        );
      },
    );
  }

  Future<void> resetPassword() async {
    final phone = userPhoneController.text.trim();
    final code = otpCodeController.text.trim();
    final newPassword = userNewPasswordController.text;
    emit(state.copyWith(status: ForgotPasswordStatus.loading, error: null));

    final result = await _authenticationRepository.resetPassword(
      ResetPasswordRequestBody(
        phoneNumber: phone,
        code: code,
        newPassword: newPassword,
      ),
    );

    result.when(
      success: (message) {
        emit(
          state.copyWith(
            status: ForgotPasswordStatus.resetPasswordSuccess,
            message: message,
          ),
        );
      },
      failure: (errorHandler) {
        emit(
          state.copyWith(
            status: ForgotPasswordStatus.error,
            error: errorHandler.getMessage,
          ),
        );
      },
    );
  }

  void resetStatus() {
    emit(
      state.copyWith(
        status: ForgotPasswordStatus.initial,
        error: null,
      ),
    );
  }

  @override
  Future<void> close() {
    userPhoneController.dispose();
    otpCodeController.dispose();
    userNewPasswordController.dispose();
    userConfirmPasswordController.dispose();
    return super.close();
  }
}
