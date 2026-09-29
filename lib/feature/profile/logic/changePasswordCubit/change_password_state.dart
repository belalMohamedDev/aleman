enum ChangePasswordStatus { initial, loading, success, error }

class ChangePasswordState {
  final ChangePasswordStatus status;
  final bool showCurrentPassword;
  final bool showNewPassword;
  final bool showConfirmPassword;
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;
  final bool isFormValid;
  final String? errorMessage;
  final String? successMessage;

  const ChangePasswordState({
    this.status = ChangePasswordStatus.initial,
    this.showCurrentPassword = false,
    this.showNewPassword = false,
    this.showConfirmPassword = false,
    this.currentPassword = '',
    this.newPassword = '',
    this.confirmPassword = '',
    this.isFormValid = false,
    this.errorMessage,
    this.successMessage,
  });

  ChangePasswordState copyWith({
    ChangePasswordStatus? status,
    bool? showCurrentPassword,
    bool? showNewPassword,
    bool? showConfirmPassword,
    String? currentPassword,
    String? newPassword,
    String? confirmPassword,
    bool? isFormValid,
    String? errorMessage,
    String? successMessage,
  }) {
    return ChangePasswordState(
      status: status ?? this.status,
      showCurrentPassword: showCurrentPassword ?? this.showCurrentPassword,
      showNewPassword: showNewPassword ?? this.showNewPassword,
      showConfirmPassword: showConfirmPassword ?? this.showConfirmPassword,
      currentPassword: currentPassword ?? this.currentPassword,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isFormValid: isFormValid ?? this.isFormValid,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }
}
