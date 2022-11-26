import 'package:chatapp_firebase/pages/auth/login_page.dart';
import 'package:chatapp_firebase/pages/auth/register_page.dart';

import 'package:chatapp_firebase/pages/home_page.dart';
import 'package:flutter/material.dart';

class RouteName {
  static const String onboardingScreen = '/onboarding';
  static const String homeScreen = '/home';
  static const String welcomeScreen = '/welcome';
  static const String registerScreen = '/register';
  static const String loginScreen = '/login';
}

class RouteGenerator {
  static Future<dynamic> push(BuildContext context, Widget page) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: ((context) => page),
      ),
    );
  }

  static Future<dynamic> pushNamed(BuildContext context, String route,
      {Object? arguments}) {
    return Navigator.pushNamed(context, route, arguments: arguments);
  }

  static Future<dynamic> pushReplacementNamed(
      BuildContext context, String route,
      {Object? arguments, Object? result}) {
    return Navigator.pushReplacementNamed(
      context,
      route,
      arguments: arguments,
      result: result,
    );
  }

  static Future<dynamic> pushReplacementNamedUntil(
      BuildContext context, String route,
      {Object? arguments, required bool Function(Route<dynamic>) predicate}) {
    return Navigator.pushNamedAndRemoveUntil(
      context,
      route,
      predicate,
      arguments: arguments,
    );
  }

  static Route<dynamic>? onGenerateAppRoute(RouteSettings settings) {
    Widget? page;
    switch (settings.name) {
      case RouteName.registerScreen:
        page = const RegisterPage();
        break;
      case RouteName.loginScreen:
        page = const LoginPage();
        break;
      case RouteName.homeScreen:
        page = const HomePage();
        break;
    }

    return _getPageRoute(page, settings);
  }

  static PageRouteBuilder<dynamic>? _getPageRoute(
    Widget? page,
    RouteSettings settings,
  ) {
    if (page == null) {
      return null;
    }
    return PageRouteBuilder<dynamic>(
        pageBuilder: (_, __, ___) => page,
        settings: settings,
        transitionDuration: const Duration(milliseconds: 350),
        transitionsBuilder: (ctx, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        });
  }
}
