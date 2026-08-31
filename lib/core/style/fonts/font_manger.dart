import 'package:flutter/material.dart';

class FontConsistent {
  static const String fontFamilyCairo = 'Cairo';

  /// In-memory cache — set once at startup and updated on language change.
  /// This avoids hitting SharedPreferences on every widget build.
  static String _cachedLangCode = 'ar';

  /// Call this once at startup (from [AppLogicCubit.getSavedLanguage]) and
  /// again every time the language changes, to keep the cache current.
  static void setLanguage(String langCode) {
    _cachedLangCode = langCode;
  }

  /// Returns the correct font family from the in-memory cache.
  /// O(1) — no disk / SharedPreferences access.
  static String geLocalozedFontFamily() {
    if (_cachedLangCode == 'ar') {
      return fontFamilyCairo;
    } else {
      return 'Roboto';
    }
  }
}

class FontWeightManger {
  static const FontWeight light = FontWeight.w300;
  static const FontWeight extraLight = FontWeight.w200;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;
  static const FontWeight black = FontWeight.w900;
}
