import 'dart:async';

import 'package:aleman/core/application/di.dart';
import 'package:aleman/core/network/api_constant/api_constant.dart';
import 'package:aleman/core/routing/routes.dart';
import 'package:aleman/core/services/app_logout.dart';
import 'package:aleman/core/services/app_storage_key.dart';
import 'package:aleman/core/services/shared_pref_helper.dart';
import 'package:aleman/core/sharedWidget/app_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class TokenInterceptor extends Interceptor {
  final Dio dio;

  TokenInterceptor(this.dio);

  static Completer<String?>? _refreshCompleter;
  static bool _isSessionExpiredHandling = false;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Obtain the access token
    final String accessToken = await SharedPrefHelper.getSecuredString(
      PrefKeys.userAccessToken,
    );

    final String language =
        SharedPrefHelper.getString(PrefKeys.prefsLanguage).isEmpty
        ? 'ar'
        : SharedPrefHelper.getString(PrefKeys.prefsLanguage);

    // Add headers
    options.headers['Accept'] = 'application/json';
    if (accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    options.headers['lang'] = language;

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final String requestPath = err.requestOptions.path;
    final bool isAuthRequest =
        requestPath.contains(ApiConstants.login) ||
        requestPath.contains(ApiConstants.refreshToken) ||
        requestPath.contains(ApiConstants.forgotPassword) ||
        requestPath.contains(ApiConstants.verifyResetCode) ||
        requestPath.contains(ApiConstants.resetPassword);

    if (err.response?.statusCode == 401 && !isAuthRequest) {
      // If another request is currently refreshing the token, wait for it
      if (_refreshCompleter != null && !_refreshCompleter!.isCompleted) {
        try {
          final String? newToken = await _refreshCompleter!.future;
          if (newToken != null && newToken.isNotEmpty) {
            err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
            if (err.requestOptions.data is FormData) {
              err.requestOptions.data = (err.requestOptions.data as FormData)
                  .clone();
            }
            final cloneReq = await dio.fetch(err.requestOptions);
            return handler.resolve(cloneReq);
          }
        } catch (_) {
          return handler.reject(err);
        }
      }

      // Start the refresh token process
      _refreshCompleter = Completer<String?>();

      final String oldAccessToken = await SharedPrefHelper.getSecuredString(
        PrefKeys.userAccessToken,
      );
      final String oldRefreshToken = await SharedPrefHelper.getSecuredString(
        PrefKeys.userRefreshToken,
      );

      if (oldRefreshToken.isEmpty) {
        _refreshCompleter?.complete(null);
        _refreshCompleter = null;
        _showSessionExpiredMessage();
        return handler.reject(err);
      }

      try {
        final refreshDio = Dio(
          BaseOptions(
            connectTimeout: const Duration(
              milliseconds: ApiConstants.apiTimeOut,
            ),
            receiveTimeout: const Duration(
              milliseconds: ApiConstants.apiTimeOut,
            ),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        );

        final response = await refreshDio.post(
          '${ApiConstants.baseUrl}${ApiConstants.refreshToken}',
          data: {
            'accessToken': oldAccessToken,
            'refreshToken': oldRefreshToken,
          },
        );

        if (response.statusCode == 200 && response.data != null) {
          final newAccessToken = response.data['accessToken'] as String?;
          final newRefreshToken = response.data['refreshToken'] as String?;

          if (newAccessToken != null &&
              newAccessToken.isNotEmpty &&
              newRefreshToken != null &&
              newRefreshToken.isNotEmpty) {
            // Save the updated tokens in secure storage
            await SharedPrefHelper.setSecuredString(
              PrefKeys.userAccessToken,
              newAccessToken,
            );
            await SharedPrefHelper.setSecuredString(
              PrefKeys.userRefreshToken,
              newRefreshToken,
            );

            _refreshCompleter?.complete(newAccessToken);
            _refreshCompleter = null;

            // Retry the original request with the new access token
            err.requestOptions.headers['Authorization'] =
                'Bearer $newAccessToken';
            if (err.requestOptions.data is FormData) {
              err.requestOptions.data = (err.requestOptions.data as FormData)
                  .clone();
            }

            final cloneReq = await dio.fetch(err.requestOptions);
            return handler.resolve(cloneReq);
          }
        }

        _refreshCompleter?.complete(null);
        _refreshCompleter = null;
        _showSessionExpiredMessage();
        return handler.reject(err);
      } catch (e) {
        _refreshCompleter?.complete(null);
        _refreshCompleter = null;
        _showSessionExpiredMessage();
        return handler.reject(err);
      }
    } else if (err.response?.statusCode == 500) {
      try {
        if (err.requestOptions.data is FormData) {
          err.requestOptions.data = (err.requestOptions.data as FormData)
              .clone();
        }
        final cloneReq = await dio.fetch(err.requestOptions);
        return handler.resolve(cloneReq);
      } catch (e) {
        return handler.reject(err);
      }
    }

    return handler.next(err);
  }

  void _showSessionExpiredMessage() async {
    if (_isSessionExpiredHandling) return;
    _isSessionExpiredHandling = true;

    try {
      await AppLogout.logout();

      AppToast.showError(
        null,
        message: 'انتهت صلاحية الجلسة، يرجى إعادة تسجيل الدخول',
      );

      instance<GlobalKey<NavigatorState>>().currentState
          ?.pushNamedAndRemoveUntil(
            Routes.loginRoute,
            (Route<dynamic> route) => false,
          );
    } finally {
      Future.delayed(const Duration(seconds: 3), () {
        _isSessionExpiredHandling = false;
      });
    }
  }
}
