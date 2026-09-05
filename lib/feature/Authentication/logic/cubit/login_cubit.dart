import 'package:aleman/core/network/apiResult/api_reuslt.dart';
import 'package:aleman/core/utils/app_regex.dart';
import 'package:aleman/core/services/app_storage_key.dart';
import 'package:aleman/core/services/shared_pref_helper.dart';
import 'package:aleman/feature/Authentication/data/model/bodyRequest/login/login_body_request.dart';
import 'package:aleman/feature/Authentication/data/repository/authentication_repository.dart';
import 'package:aleman/feature/Authentication/logic/cubit/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authenticationRepository) : super(const LoginState());

  final AuthenticationRepository _authenticationRepository;
  final TextEditingController userLoginEmailAddress = TextEditingController();
  final TextEditingController userLoginPassword = TextEditingController();
  final loginFormKey = GlobalKey<FormState>();

  void togglePasswordVisibility() {
    emit(state.copyWith(showPass: !state.showPass));
  }

  void validateFields() {
    final bool isEmailValid = AppRegex.isEmailValid(userLoginEmailAddress.text.trim());
    final bool isPasswordValid = AppRegex.isPasswordValid(userLoginPassword.text);

    final isButtonValid = isEmailValid && isPasswordValid;

    // Trigger state change so the button gets enabled/disabled
    emit(state.copyWith(isButtonValid: isButtonValid));
  }

  Future<void> login() async {
    final email = userLoginEmailAddress.text.trim();
    final password = userLoginPassword.text.trim();
    emit(state.copyWith(status: LoginRequestStatus.loading));

    final result = await _authenticationRepository.login(
      LoginRequestBody(email: email, password: password),
    );

    result.when(
      success: (authEntity) async {
        // Save tokens in secure storage
        await SharedPrefHelper.setSecuredString(
          PrefKeys.userAccessToken,
          authEntity.accessToken,
        );
        await SharedPrefHelper.setSecuredString(
          PrefKeys.userRefreshToken,
          authEntity.refreshToken,
        );

        emit(state.copyWith(status: LoginRequestStatus.success));
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
}
