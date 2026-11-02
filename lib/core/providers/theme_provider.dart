import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provides the current application theme mode.
final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(
  ThemeNotifier.new,
);

class ThemeNotifier extends Notifier<ThemeMode> {
  ThemeNotifier([this._initialTheme = ThemeMode.system]);

  final ThemeMode _initialTheme;

  static const String _themeKey = 'app_theme_mode';

  @override
  ThemeMode build() {
    return _initialTheme;
  }

  /// Changes the theme and persists the selection.
  Future<void> setTheme(ThemeMode themeMode) async {
    state = themeMode;

    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_themeKey, themeMode.name);
  }
}
