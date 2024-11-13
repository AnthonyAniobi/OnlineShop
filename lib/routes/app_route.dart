import 'package:flutter/material.dart';
import 'package:online_shop/features/authentication/presentation/screens/login_screen.dart';
import 'package:online_shop/features/authentication/presentation/screens/signup_screen.dart';
import 'package:online_shop/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:online_shop/features/onboarding/presentation/screens/onboarding_screen.dart';

class AppRouter {
  static const String splash = '/splash_screen';
  static const String login = '/login_screen';
  static const String signup = '/signup_screen';
  static const String dashboard = '/dashboard_screen';

  /// current route name
  static String currentRoute = splash;

  static Route<dynamic>? onGenerateRouted(RouteSettings routeSettings) {
    currentRoute = routeSettings.name ?? '';

    switch (routeSettings.name) {
      case splash:
        return OnboardingScreen.route(routeSettings);
      case login:
        return LoginScreen.route(routeSettings);
      case signup:
        return SignupScreen.route(routeSettings);
      case dashboard:
        return DashboardScreen.route(routeSettings);
      default:
        return MaterialPageRoute(builder: (_) => const Scaffold());
    }
  }
}
