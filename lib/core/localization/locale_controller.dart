import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleController {
  LocaleController._();

  static final ValueNotifier<Locale?> locale = ValueNotifier<Locale?>(
    const Locale('en'),
  );

  static const String _languageKey = 'app_language';

  static Future<void> loadSavedLocale() async {
    final preferences = await SharedPreferences.getInstance();
    final languageCode = preferences.getString(_languageKey);

    if (languageCode != null && ['en', 'fr', 'ar'].contains(languageCode)) {
      locale.value = Locale(languageCode);
    }
  }

  static Future<void> setLocale(Locale newLocale) async {
    if (!['en', 'fr', 'ar'].contains(newLocale.languageCode)) {
      return;
    }

    locale.value = newLocale;

    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_languageKey, newLocale.languageCode);
  }
}
