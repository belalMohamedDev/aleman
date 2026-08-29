import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

class AppLogger {
  const AppLogger();

  void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      developer.log(
        message,
        name: 'DEBUG',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  void info(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      developer.log(
        message,
        name: 'INFO',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      developer.log(
        message,
        name: 'WARNING',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  void error(String message, [dynamic error, StackTrace? stackTrace]) {
    developer.log(
      message,
      name: 'ERROR',
      error: error,
      stackTrace: stackTrace,
    );
  }
}

const appLogger = AppLogger();
