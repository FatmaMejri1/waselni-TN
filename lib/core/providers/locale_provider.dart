import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provides the application's current locale.
final localeProvider = NotifierProvider<LocaleNotifier, Locale>(
  LocaleNotifier.new,
);

class LocaleNotifier extends Notifier<Locale> {
  LocaleNotifier([this._initialLocale = const Locale('en')]);

  final Locale _initialLocale;

  static const String _languageKey = 'app_language';
  static const List<String> _supportedLanguages = ['en', 'fr', 'ar'];

  @override
  Locale build() {
    return _initialLocale;
  }

  /// Changes the application language and saves the selection.
  Future<void> setLocale(Locale newLocale) async {
    final languageCode = newLocale.languageCode;

    if (!_supportedLanguages.contains(languageCode)) {
      return;
    }

    state = Locale(languageCode);

    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_languageKey, languageCode);
  }
}
