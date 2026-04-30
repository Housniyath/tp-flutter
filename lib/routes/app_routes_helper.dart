import 'package:flutter/material.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String habits = '/habits';
  static const String tracking = '/tracking';
  static const String history = '/history';
  static const String habitHistory = '/habit-history';

  static void goTo(BuildContext context, String route ,{String? args}) {
    Navigator.pushNamed(context, route, arguments: args);
  }

  static void goBack(BuildContext context) {
    Navigator.pop(context);
  }

  static void goToAndClearStack(BuildContext context, String route) {
    Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
  }
}