import 'package:aleman/app.dart';
import 'package:aleman/core/application/di.dart';
import 'package:aleman/core/services/app_logger.dart';
import 'package:aleman/core/services/shared_pref_helper.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  DevicePreview.enable(enabled: kDebugMode);
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
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
}
