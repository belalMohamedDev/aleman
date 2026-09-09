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
  static const String cartItems = '/api/Cart/items';
  static const String cartCount = '/api/Cart/count';
  static const String getCart = '/api/Cart';
  static const String userProfile = '/api/Users/me';
  static const String userAddresses = '/api/user-addresses';
  static const String orders = '/api/orders';
  static const String calculateShipping = '/api/orders/calculate-shipping';
  static const String smallMerchantsOrders = '/api/Orders/small-merchants';
  static const String registerToken = '/api/notifications/register-token';
  static const String removeToken = '/api/notifications/remove-token';
  static const String notifications = '/api/notifications';
  static const String notificationsUnreadCount = '/api/notifications/unread-count';
  static const String markAllNotificationsRead = '/api/notifications/mark-all-read';
  static const String sendTestNotification = '/api/notifications/send-test';

  static const int apiTimeOut = 120 * 1000;
}
