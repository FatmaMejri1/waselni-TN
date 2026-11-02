import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/notifications/notification_service.dart';
import 'core/providers/locale_provider.dart';
import 'core/providers/theme_provider.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await NotificationService.initialize();

  final preferences = await SharedPreferences.getInstance();

  final savedLanguage = preferences.getString('app_language');
  final savedTheme = preferences.getString('app_theme_mode');

  final initialLocale = ['en', 'fr', 'ar'].contains(savedLanguage)
      ? Locale(savedLanguage!)
      : const Locale('en');

  final initialTheme = ThemeMode.values.firstWhere(
    (mode) => mode.name == savedTheme,
    orElse: () => ThemeMode.system,
  );

  final container = ProviderContainer(
    overrides: [
      localeProvider.overrideWith(() => LocaleNotifier(initialLocale)),
      themeProvider.overrideWith(() => ThemeNotifier(initialTheme)),
    ],
  );

  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      navigatorKey: NotificationService.navigatorKey,
      locale: locale,
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
