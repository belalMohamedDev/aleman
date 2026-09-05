import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_state.freezed.dart';

enum LoginRequestStatus { initial, loading, success, error }

@freezed
abstract class LoginState with _$LoginState {
  const factory LoginState({
    @Default(LoginRequestStatus.initial) LoginRequestStatus status,
    @Default(true) bool showPass,
    @Default(false) bool isButtonValid,
    String? error,
  }) = _LoginState;
}
