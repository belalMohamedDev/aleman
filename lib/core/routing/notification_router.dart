import 'dart:convert';

import 'package:aleman/core/application/di.dart';
import 'package:aleman/core/routing/routes.dart';
import 'package:aleman/core/services/app_logger.dart';
import 'package:flutter/material.dart';

class NotificationRouter {
  static Map<String, dynamic>? _pendingPayload;

  static void setPendingPayload(Map<String, dynamic>? data) {
    _pendingPayload = data;
  }

  static void checkAndNavigatePending() {
    if (_pendingPayload != null) {
      final payload = _pendingPayload!;
      _pendingPayload = null;
      handleNavigation(payload);
    }
  }

  static void handleNavigation(dynamic rawData) {
    if (rawData == null) return;

    Map<String, dynamic> data = {};
    if (rawData is Map) {
      data = Map<String, dynamic>.from(rawData);
    } else if (rawData is String && rawData.isNotEmpty) {
      try {
        final decoded = jsonDecode(rawData);
        if (decoded is Map) {
          data = Map<String, dynamic>.from(decoded);
        }
      } catch (_) {}
    }

    appLogger.info('NotificationRouter handling navigation with data: $data');

    final navigator = instance<GlobalKey<NavigatorState>>().currentState;
    if (navigator == null) {
      appLogger.warning('NavigatorState is null, caching payload for later navigation');
      _pendingPayload = data;
      return;
    }

    final String type = (data['type'] ?? '').toString().toLowerCase();

    switch (type) {
      case 'order_status':
      case 'order':
        // If order details screen exists or route to cart/notifications
        navigator.pushNamed(
          Routes.notificationsRoute,
          arguments: data,
        );
        break;

      case 'cart':
        navigator.pushNamed(Routes.cartRoute);
        break;

      case 'promotion':
      case 'notification':
      default:
        navigator.pushNamed(Routes.notificationsRoute);
        break;
    }
  }
}
