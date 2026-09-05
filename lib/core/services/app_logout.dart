import 'package:aleman/core/application/di.dart';
import 'package:aleman/core/routing/routes.dart';
import 'package:aleman/core/services/app_storage_key.dart';
import 'package:aleman/core/services/shared_pref_helper.dart';
import 'package:aleman/core/utils/extensions.dart';
import 'package:aleman/feature/Authentication/data/model/bodyRequest/logout/logout_body_request.dart';
import 'package:aleman/feature/Authentication/data/repository/authentication_repository.dart';
import 'package:flutter/material.dart';

class AppLogout {
  const AppLogout();

  /// Clears stored user authentication credentials and state, notifying the backend if possible
  static Future<void> logout() async {
    final String refreshToken = await SharedPrefHelper.getSecuredString(
      PrefKeys.userRefreshToken,
    );

    if (refreshToken.isNotEmpty) {
      try {
        if (instance.isRegistered<AuthenticationRepository>()) {
          await instance<AuthenticationRepository>().logout(
            LogoutRequestBody(refreshToken: refreshToken),
          );
        }
      } catch (_) {
        // Silently continue so local logout always succeeds even if offline or server returns an error
      }
    }

    await SharedPrefHelper.clearAllSecuredData();
    await SharedPrefHelper.setData(PrefKeys.prefsKeyIsUserLoggedIn, false);
  }

  /// Clears authentication credentials and navigates to the login screen
  Future<void> logOutThenNavigateToLogin([BuildContext? context]) async {
    await logout();

    if (context != null && context.mounted) {
      context.pushNamedAndRemoveUntil(Routes.loginRoute);
    } else {
      instance<GlobalKey<NavigatorState>>()
          .currentState
          ?.pushNamedAndRemoveUntil(
            Routes.loginRoute,
            (Route<dynamic> route) => false,
          );
    }
  }
}
