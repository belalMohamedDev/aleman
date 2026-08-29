import 'package:aleman/core/services/app_logger.dart';
import 'package:aleman/core/services/app_storage_key.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  factory SharedPrefHelper() {
    return preferences;
  }

  SharedPrefHelper._internal();

  static final SharedPrefHelper preferences = SharedPrefHelper._internal();

  static late SharedPreferences sharedPreferences;
  static late FlutterSecureStorage flutterSecureStorage;

  static Future<dynamic> getInstancePreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
    flutterSecureStorage = const FlutterSecureStorage(
      aOptions: AndroidOptions(),
    );
    await _handleFirstRun();
  }

  /// Handles the first run after an uninstall/reinstall or data wipe.
  /// If SharedPreferences is wiped, we clear SecureStorage to prevent stale data/crashes.
  static Future<void> _handleFirstRun() async {
    final bool isFirstRun =
        sharedPreferences.getBool(PrefKeys.prefsKeyFirstRun) ?? true;
    if (isFirstRun) {
      appLogger.info(
        'Fresh install detected, clearing Secure Storage and Hive',
      );
      await clearAllData();
      await clearAllSecuredData();
      await Hive.initFlutter();
      await Hive.deleteFromDisk();
      await setData(PrefKeys.prefsKeyFirstRun, false);
    }
  }

  /// Removes a value from SharedPreferences with the given [key].
  static Future<void> removeData(String key) async {
    appLogger.debug('SharedPrefHelper: Removing data with key: $key');
    await sharedPreferences.remove(key);
  }

  /// Removes all keys and values from SharedPreferences.
  static Future<void> clearAllData() async {
    appLogger.debug('SharedPrefHelper: Clearing all data');
    await sharedPreferences.clear();
  }

  /// Saves a [value] with a [key] in SharedPreferences.
  static Future<void> setData(String key, dynamic value) async {
    appLogger.debug(
      'SharedPrefHelper: Setting data with key: $key and value: $value',
    );
    if (value is String) {
      await sharedPreferences.setString(key, value);
    } else if (value is int) {
      await sharedPreferences.setInt(key, value);
    } else if (value is bool) {
      await sharedPreferences.setBool(key, value);
    } else if (value is double) {
      await sharedPreferences.setDouble(key, value);
    } else {
      throw ArgumentError('Unsupported value type');
    }
  }

  /// Gets a bool value from SharedPreferences with the given [key].
  static bool getBool(String key) {
    appLogger.debug('SharedPrefHelper: Getting bool with key: $key');

    return sharedPreferences.getBool(key) ?? false;
  }

  /// Gets a double value from SharedPreferences with the given [key].
  static double getDouble(String key) {
    appLogger.debug('SharedPrefHelper: Getting double with key: $key');

    return sharedPreferences.getDouble(key) ?? 0.0;
  }

  /// Gets an int value from SharedPreferences with the given [key].
  static int getInt(String key) {
    appLogger.debug('SharedPrefHelper: Getting int with key: $key');

    return sharedPreferences.getInt(key) ?? 0;
  }

  /// Gets a String value from SharedPreferences with the given [key].
  static String getString(String key) {
    appLogger.debug('SharedPrefHelper: Getting string with key: $key');

    return sharedPreferences.getString(key) ?? '';
  }

  /// Saves a [value] with a [key] in FlutterSecureStorage.
  static Future<void> setSecuredString(String key, String value) async {
    appLogger.debug(
      'FlutterSecureStorage: Setting secured string with key: $key and value: $value',
    );
    await flutterSecureStorage.write(key: key, value: value);
  }

  /// Gets a String value from FlutterSecureStorage with the given [key].
  static Future<String> getSecuredString(String key) async {
    appLogger.debug(
      'FlutterSecureStorage: Getting secured string with key: $key',
    );
    return await flutterSecureStorage.read(key: key) ?? '';
  }

  /// Removes all keys and values from FlutterSecureStorage.
  static Future<void> clearAllSecuredData() async {
    appLogger.debug('FlutterSecureStorage: Clearing all secured data');
    await flutterSecureStorage.deleteAll();
  }

  ///Below method is to check the availability of the received preference .
  static bool containPreference(String key) {
    if (sharedPreferences.get(key) == null) {
      return false;
    } else {
      return true;
    }
  }
}
