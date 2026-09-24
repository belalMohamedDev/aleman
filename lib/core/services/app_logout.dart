import 'package:aleman/core/application/di.dart';
import 'package:aleman/core/routing/routes.dart';
import 'package:aleman/core/services/app_storage_key.dart';
import 'package:aleman/core/services/auth_event_bus.dart';
import 'package:aleman/core/services/shared_pref_helper.dart';
import 'package:aleman/core/utils/extensions.dart';
import 'package:aleman/feature/Authentication/data/model/bodyRequest/logout/logout_body_request.dart';
import 'package:aleman/feature/Authentication/data/repository/authentication_repository.dart';
import 'package:aleman/feature/notification/data/model/request/remove_token_request_body.dart';
import 'package:aleman/feature/notification/domain/usecase/remove_device_token_use_case.dart';
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
      } catch (_) {}
    }

    final String fcmToken = await SharedPrefHelper.getSecuredString(
      PrefKeys.fcmDeviceToken,
    );

    if (fcmToken.isNotEmpty &&
        instance.isRegistered<RemoveDeviceTokenUseCase>()) {
      try {
        await instance<RemoveDeviceTokenUseCase>().execute(
          RemoveTokenRequestBody(fcmToken: fcmToken),
        );
      } catch (_) {}
    }

    await SharedPrefHelper.clearAllSecuredData();
    await SharedPrefHelper.setData(PrefKeys.prefsKeyIsUserLoggedIn, false);
    AuthEventBus.notifyLoggedOut();
  }

  /// Clears authentication credentials and navigates to the login screen
  Future<void> logOutThenNavigateToLogin([BuildContext? context]) async {
    await logout();

    if (context != null && context.mounted) {
      context.pushNamedAndRemoveUntil(Routes.homeRoute);
    } else {
      instance<GlobalKey<NavigatorState>>().currentState
          ?.pushNamedAndRemoveUntil(
            Routes.homeRoute,
            (Route<dynamic> route) => false,
          );
    }
  }
}
