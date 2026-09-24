import 'dart:async';

enum AuthEvent { loggedIn, loggedOut, tokenRefreshed }

/// A lightweight, app-wide event bus that notifies active cubits/screens
/// when authentication credentials change (e.g. login, logout, token refresh).
class AuthEventBus {
  static final StreamController<AuthEvent> _controller =
      StreamController<AuthEvent>.broadcast();

  /// Stream of authentication lifecycle events.
  static Stream<AuthEvent> get stream => _controller.stream;

  /// Notify that a user has successfully logged in.
  static void notifyLoggedIn() {
    _controller.add(AuthEvent.loggedIn);
  }

  /// Notify that a user has logged out.
  static void notifyLoggedOut() {
    _controller.add(AuthEvent.loggedOut);
  }

  /// Notify that the access token was refreshed.
  static void notifyTokenRefreshed() {
    _controller.add(AuthEvent.tokenRefreshed);
  }
}
