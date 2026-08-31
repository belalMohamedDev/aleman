import 'package:aleman/core/language/app_localizations.dart';
import 'package:flutter/material.dart';

extension ContextExt on BuildContext {
  String translate(String langKey) {
    final localizations = AppLocalizations.of(this);
    if (localizations != null) {
      return localizations.translate(langKey) ?? langKey;
    } else {
      return langKey;
    }
  }
}
