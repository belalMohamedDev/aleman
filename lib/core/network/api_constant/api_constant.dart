class ApiConstants {
  static const String baseUrl = 'http://10.0.2.239:5094';
  static const String banner = '/api/Banners';
  static const String category = '/api/Categories';
  static const String product = '/api/Products';
  static const String login = '/api/Auth/login';
  static const String forgotPassword = '/api/Auth/forgot-password';
  static const String verifyResetCode = '/api/Auth/verify-reset-code';
  static const String resetPassword = '/api/Auth/reset-password';
  static const String refreshToken = '/api/Auth/refresh';
  static const String logout = '/api/Auth/logout';

  static const int apiTimeOut = 120 * 1000;
}
