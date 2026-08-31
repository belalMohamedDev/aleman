import 'package:aleman/core/services/app_storage_key.dart';
import 'package:aleman/core/services/shared_pref_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_logic_state.dart';
part 'app_logic_cubit.freezed.dart';

class AppLogicCubit extends Cubit<AppLogicState> {
  AppLogicCubit() : super(const AppLogicState.initial());

  String currentLangCode = 'ar';

  // Get Saved Language from Shared Preferences
  void getSavedLanguage() {
    final result = SharedPrefHelper.containPreference(PrefKeys.prefsLanguage)
        ? SharedPrefHelper.getString(PrefKeys.prefsLanguage)
        : 'ar';

    currentLangCode = result;

    emit(AppLogicState.languageChange(locale: Locale(currentLangCode)));
  }

  // Change Language and Update Preferences
  Future<void> _changeLang(String langCode) async {
    await SharedPrefHelper.setData(PrefKeys.prefsLanguage, langCode);
    currentLangCode = langCode;

    // Update the language
    emit(AppLogicState.languageChange(locale: Locale(currentLangCode)));
  }

  // Switch to Arabic
  void toArabic() => _changeLang('ar');

  // Switch to English
  void toEnglish() => _changeLang('en');
}
