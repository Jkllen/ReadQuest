import 'package:flutter/material.dart';
import 'package:read_quest/screens/splash/view/login_screen.dart';
import '../screens/splash/view/splash_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    login: (context) => const LoginScreen(),
  };
}