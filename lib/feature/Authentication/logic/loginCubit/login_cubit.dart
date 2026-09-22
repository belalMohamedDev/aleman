import 'dart:async';

import 'package:aleman/core/application/di.dart';
import 'package:aleman/core/network/apiResult/api_reuslt.dart';
import 'package:aleman/core/services/app_storage_key.dart';
import 'package:aleman/core/services/notification_service.dart';
import 'package:aleman/core/services/shared_pref_helper.dart';
import 'package:aleman/core/services/user_role_helper.dart';
import 'package:aleman/core/utils/app_regex.dart';
import 'package:aleman/feature/Authentication/data/mapper/auth_mapper.dart';
import 'package:aleman/feature/Authentication/data/model/bodyRequest/login/login_body_request.dart';
import 'package:aleman/feature/Authentication/data/model/bodyRequest/login/send_login_otp_request_body.dart';
import 'package:aleman/feature/Authentication/data/model/bodyRequest/login/verify_login_otp_request_body.dart';
import 'package:aleman/feature/Authentication/data/repository/authentication_repository.dart';
import 'package:aleman/feature/Authentication/logic/loginCubit/login_state.dart';
import 'package:aleman/feature/cart/logic/cubit/cart_cubit.dart';
import 'package:aleman/feature/notification/logic/notification_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authenticationRepository) : super(const LoginState());

  final AuthenticationRepository _authenticationRepository;

  // Controllers
  final TextEditingController userLoginEmailAddress = TextEditingController();
  final TextEditingController userLoginPassword = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  // Keys
  final loginFormKey = GlobalKey<FormState>();
  final phoneFormKey = GlobalKey<FormState>();
  final otpFormKey = GlobalKey<FormState>();

  Timer? _countdownTimer;

  void changeAuthMode(AuthMode mode) {
    if (state.authMode == mode) return;
    emit(
      state.copyWith(
        authMode: mode,
        phoneStep: PhoneStep.input,
        status: LoginRequestStatus.initial,
        error: null,
      ),
    );
    validateFields();
  }

  void setPhoneStep(PhoneStep step) {
    emit(
      state.copyWith(
        phoneStep: step,
        status: LoginRequestStatus.initial,
        error: null,
      ),
    );
    validateFields();
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(showPass: !state.showPass));
  }

  void updatePhoneNumber(String phone) {
    emit(state.copyWith(phoneNumber: phone.trim()));
    validateFields();
  }

  void updateOtpCode(String code) {
    final cleanCode = code.trim().replaceAll(RegExp(r'\D'), '');
    emit(state.copyWith(otpCode: cleanCode));
    validateFields();
  }

  void validateFields() {
    bool isValid = false;

    if (state.authMode == AuthMode.phone) {
      if (state.phoneStep == PhoneStep.input) {
        final phone = phoneController.text.trim();
        isValid = AppRegex.isPhoneNumberValid(phone);
      } else {
        final otp = otpController.text.trim();
        isValid = otp.length == 6;
      }
    } else {
      final emailOrUser = userLoginEmailAddress.text.trim();
      final password = userLoginPassword.text;
      final bool isEmailValid = emailOrUser.contains('@')
          ? AppRegex.isEmailValid(emailOrUser)
          : emailOrUser.length >= 3;
      final bool isPasswordValid = password.isNotEmpty;
      isValid = isEmailValid && isPasswordValid;
    }

    emit(state.copyWith(isButtonValid: isValid));
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    emit(state.copyWith(countdown: 60));

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.countdown <= 1) {
        timer.cancel();
        emit(state.copyWith(countdown: 0));
      } else {
        emit(state.copyWith(countdown: state.countdown - 1));
      }
    });
  }

  Future<void> sendLoginOtp() async {
    final phone = phoneController.text.trim();
    if (phone.isEmpty) return;

    emit(
      state.copyWith(
        status: LoginRequestStatus.loading,
        error: null,
        phoneNumber: phone,
      ),
    );

    final result = await _authenticationRepository.sendLoginOtp(
      SendLoginOtpRequestBody(phoneNumber: phone),
    );

    result.when(
      success: (message) {
        otpController.clear();
        emit(
          state.copyWith(
            status: LoginRequestStatus.initial,
            phoneStep: PhoneStep.otp,
            message: message,
            otpCode: '',
          ),
        );
        _startCountdown();
        validateFields();
      },
      failure: (errorHandler) {
        emit(
          state.copyWith(
            status: LoginRequestStatus.error,
            error: errorHandler.getMessage,
          ),
        );
      },
    );
  }

  Future<void> resendLoginOtp() async {
    if (state.countdown > 0 || state.status == LoginRequestStatus.loading) {
      return;
    }
    await sendLoginOtp();
  }

  Future<void> verifyLoginOtp() async {
    final phone = state.phoneNumber.isNotEmpty
        ? state.phoneNumber
        : phoneController.text.trim();
    final otp = otpController.text.trim();

    if (phone.isEmpty || otp.length < 6) return;

    emit(state.copyWith(status: LoginRequestStatus.loading, error: null));

    final result = await _authenticationRepository.verifyLoginOtp(
      VerifyLoginOtpRequestBody(phoneNumber: phone, code: otp),
    );

    result.when(
      success: (authEntity) async {
        await _handleAuthSuccess(authEntity);
      },
      failure: (errorHandler) {
        emit(
          state.copyWith(
            status: LoginRequestStatus.error,
            error: errorHandler.getMessage,
          ),
        );
      },
    );
  }

  Future<void> login() async {
    final email = userLoginEmailAddress.text.trim();
    final password = userLoginPassword.text.trim();
    emit(state.copyWith(status: LoginRequestStatus.loading, error: null));

    final result = await _authenticationRepository.login(
      LoginRequestBody(email: email, password: password),
    );

    result.when(
      success: (authEntity) async {
        await _handleAuthSuccess(authEntity);
      },
      failure: (errorHandler) {
        emit(
          state.copyWith(
            status: LoginRequestStatus.error,
            error: errorHandler.getMessage,
          ),
        );
      },
    );
  }

  Future<void> _handleAuthSuccess(AuthEntity authEntity) async {
    _countdownTimer?.cancel();

    // Save tokens in secure storage
    await SharedPrefHelper.setSecuredString(
      PrefKeys.userAccessToken,
      authEntity.accessToken,
    );

    await SharedPrefHelper.setSecuredString(
      PrefKeys.userRefreshToken,
      authEntity.refreshToken,
    );

    // Cache user role directly from login response or token
    if (authEntity.role.isNotEmpty) {
      UserRoleHelper.setRole(authEntity.role);
    } else {
      await UserRoleHelper.getUserRole();
    }

    if (instance.isRegistered<NotificationService>()) {
      instance<NotificationService>().syncTokenWithBackend();
    }

    if (instance.isRegistered<CartCubit>()) {
      instance<CartCubit>().getCartCount();
    }

    if (instance.isRegistered<NotificationCubit>()) {
      instance<NotificationCubit>().getUnreadCount();
    }

    emit(state.copyWith(status: LoginRequestStatus.success));
  }

  @override
  Future<void> close() {
    _countdownTimer?.cancel();
    userLoginEmailAddress.dispose();
    userLoginPassword.dispose();
    phoneController.dispose();
    otpController.dispose();
    return super.close();
  }
}
