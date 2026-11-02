import 'package:flutter/material.dart';

import '../../features/notifications/presentation/notifications_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/signup_screen.dart';
import '../../features/auth/presentation/forgot_password_screen.dart';
import '../../features/transport/domain/transport_type.dart';
import '../../features/transport/presentation/transport_lines_screen.dart';
import '../../features/transport/presentation/transport_stations_screen.dart';
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
        return _page(const ForgotPasswordScreen(), settings);

      case Routes.home:
        return _page(const HomeScreen(), settings);

      case Routes.notifications:
        return _page(const NotificationsScreen(), settings);

      case Routes.transportLines:
        final argument = settings.arguments;

        if (argument is! TransportType) {
          return _page(
            const PlaceholderScreen(title: 'Invalid transport type'),
            settings,
          );
        }

        return _page(TransportLinesScreen(transportType: argument), settings);

      case Routes.transportStations:
        return _page(const TransportStationsScreen(), settings);

      default:
        return _page(const PlaceholderScreen(title: 'Not found'), settings);
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
