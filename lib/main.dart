import 'dart:async';
import 'package:aleman/app.dart';
import 'package:aleman/core/application/di.dart';
import 'package:aleman/core/services/app_logger.dart';
import 'package:aleman/core/services/shared_pref_helper.dart';
import 'package:aleman/core/services/user_role_helper.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:aleman/core/services/notification_service.dart';

void main() async {
  DevicePreview.enable(enabled: kDebugMode);
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  await SharedPrefHelper.getInstancePreferences();
  appLogger.info('Shared Preferences initialized');

  await initAppModule();
  appLogger.info('Dependency Injection initialized');

  runApp(const MyApp());

  // Run background services smoothly after the UI is rendered to avoid frame skipping
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Future.delayed(const Duration(milliseconds: 300), () {
      _initBackgroundServices();
    });
  });
}

Future<void> _initBackgroundServices() async {
  try {
    await UserRoleHelper.getUserRole();
  } catch (e) {
    appLogger.warning('UserRoleHelper background initialization error: $e');
  }

  try {
    await instance<NotificationService>().initialize();
  } catch (e) {
    appLogger.warning('NotificationService initialization skipped/failed: $e');
  }
}

