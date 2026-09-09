import 'dart:convert';

import 'package:aleman/core/application/di.dart';
import 'package:aleman/core/routing/routes.dart';
import 'package:aleman/core/services/app_logger.dart';
import 'package:aleman/feature/order/data/model/order_response_model.dart';
import 'package:aleman/feature/order/presentation/screen/my_orders_screen.dart';
import 'package:aleman/feature/order/presentation/screen/order_details_screen.dart';
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
    final String? orderId = (data['orderId'] ?? data['order_id'] ?? data['id'])?.toString();

    // 1. Order Navigation
    if (type == 'order' || type == 'order_status' || (orderId != null && orderId.isNotEmpty && type != 'product')) {
      if (orderId != null && orderId.isNotEmpty && orderId != '0') {
        navigator.push(
          MaterialPageRoute(
            builder: (_) => OrderDetailsScreen(
              order: OrderResponseModel.fromId(orderId),
            ),
          ),
        );
      } else {
        navigator.push(
          MaterialPageRoute(
            builder: (_) => const MyOrdersScreen(),
          ),
        );
      }
      return;
    }

    // 2. Cart Navigation
    if (type == 'cart') {
      navigator.pushNamed(Routes.cartRoute);
      return;
    }

    // 3. Profile Navigation
    if (type == 'profile') {
      navigator.pushNamed(Routes.profileRoute);
      return;
    }

    // 4. Default / General Announcements
    navigator.pushNamed(Routes.notificationsRoute);
  }
}
