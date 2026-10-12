import 'dart:async';
import 'package:aleman/app.dart';
import 'package:aleman/core/application/di.dart';
import 'package:aleman/core/services/shared_pref_helper.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  DevicePreview.enable(enabled: kDebugMode);
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Parallelize critical core startup dependencies
  await Future.wait([
    SharedPrefHelper.getInstancePreferences(),
    initAppModule(),
  ]);

  runApp(const MyApp());
}
