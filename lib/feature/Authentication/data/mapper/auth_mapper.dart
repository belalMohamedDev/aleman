import 'package:aleman/feature/Authentication/data/model/authResponse/auth_response.dart';

class AuthEntity {
  final String accessToken;
  final String refreshToken;

  AuthEntity({
    required this.accessToken,
    required this.refreshToken,
  });
}

extension AuthModelMapper on AuthResponse? {
  AuthEntity toDomain() {
    return AuthEntity(
      accessToken: this?.accessToken ?? '',
      refreshToken: this?.refreshToken ?? '',
    );
  }
}
