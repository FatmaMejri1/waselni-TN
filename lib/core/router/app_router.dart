
import 'package:flutter/material.dart';

import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/signup_screen.dart';
import '../../shared/widgets/placeholder_screen.dart';
import '../constants/routes.dart';

class AppRouter {
  AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.root:
      case Routes.login:
        return _page(const LoginScreen(), settings);

      case Routes.signup:
        return _page(const SignupScreen(), settings);

      case Routes.forgotPassword:
        return _page(
          const PlaceholderScreen(title: 'Forgot password'),
          settings,
        );

      case Routes.home:
        return _page(
          const PlaceholderScreen(title: 'Home'),
          settings,
        );

      default:
        return _page(
          const PlaceholderScreen(title: 'Not found'),
          settings,
        );
    }
  }

  static MaterialPageRoute<dynamic> _page(
    Widget child,
    RouteSettings settings,
  ) {
    return MaterialPageRoute<dynamic>(
      builder: (_) => child,
      settings: settings,
    );
  }
}
