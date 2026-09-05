import 'package:freezed_annotation/freezed_annotation.dart';

part 'forgot_password_state.freezed.dart';

enum ForgotPasswordStatus {
  initial,
  loading,
  phoneSuccess,
  verifyCodeSuccess,
  resetPasswordSuccess,
  error,
}

@freezed
abstract class ForgotPasswordState with _$ForgotPasswordState {
  const factory ForgotPasswordState({
    @Default(ForgotPasswordStatus.initial) ForgotPasswordStatus status,
    @Default(false) bool isPhoneValid,
    @Default(false) bool isCodeValid,
    @Default(false) bool isNewPasswordValid,
    @Default(true) bool showNewPassword,
    @Default(true) bool showConfirmPassword,
    String? message,
    String? error,
  }) = _ForgotPasswordState;
}
