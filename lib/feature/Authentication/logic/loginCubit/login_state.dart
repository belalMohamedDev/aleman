enum AuthMode { phone, email }

enum PhoneStep { input, otp }

enum LoginRequestStatus { initial, loading, success, error }

class LoginState {
  final LoginRequestStatus status;
  final AuthMode authMode;
  final PhoneStep phoneStep;
  final bool showPass;
  final bool isButtonValid;
  final int countdown;
  final String? error;
  final String? message;
  final String phoneNumber;
  final String otpCode;

  const LoginState({
    this.status = LoginRequestStatus.initial,
    this.authMode = AuthMode.phone,
    this.phoneStep = PhoneStep.input,
    this.showPass = true,
    this.isButtonValid = false,
    this.countdown = 60,
    this.error,
    this.message,
    this.phoneNumber = '',
    this.otpCode = '',
  });

  LoginState copyWith({
    LoginRequestStatus? status,
    AuthMode? authMode,
    PhoneStep? phoneStep,
    bool? showPass,
    bool? isButtonValid,
    int? countdown,
    String? error,
    String? message,
    String? phoneNumber,
    String? otpCode,
  }) {
    return LoginState(
      status: status ?? this.status,
      authMode: authMode ?? this.authMode,
      phoneStep: phoneStep ?? this.phoneStep,
      showPass: showPass ?? this.showPass,
      isButtonValid: isButtonValid ?? this.isButtonValid,
      countdown: countdown ?? this.countdown,
      error: error,
      message: message,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      otpCode: otpCode ?? this.otpCode,
    );
  }
}
