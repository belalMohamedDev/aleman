import 'package:aleman/feature/Authentication/data/model/authResponse/auth_response.dart';

class AuthEntity {
  final String accessToken;
  final String refreshToken;
  final String role;

  AuthEntity({
    required this.accessToken,
    required this.refreshToken,
    this.role = '',
  });
}

extension AuthModelMapper on AuthResponse? {
  AuthEntity toDomain() {
    return AuthEntity(
      accessToken: this?.accessToken ?? '',
      refreshToken: this?.refreshToken ?? '',
      role: this?.role ?? '',
    );
  }
}
