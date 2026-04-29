import 'package:flutter/material.dart';
import '../features/auth/views/login_page.dart';
import '../features/auth/views/register_screen.dart';
import '../features/habits/views/habits_screen.dart';
import '../features/habits/views/habit_history_screen.dart';
import '../features/tracking/views/tracking_screen.dart';

class AppRoutes {
  static const String login        = '/';
  static const String register     = '/register';
  static const String habits       = '/habits';
  static const String habitHistory = '/habit-history';
  static const String tracking     = '/tracking';

  static Map<String, WidgetBuilder> get routes => {
    login:        (_) => const LoginPage(),
    register:     (_) => const RegisterScreen(),
    habits:       (_) => const HabitsScreen(),
    habitHistory: (_) => const HabitHistoryScreen(),
    tracking:     (_) => const TrackingScreen(),
  };

  static void goTo(BuildContext context, String route, {Object? args}) {
    Navigator.pushNamed(context, route, arguments: args);
  }

  static void goToAndReplace(BuildContext context, String route) {
    Navigator.pushReplacementNamed(context, route);
  }

  static void goToAndClearStack(BuildContext context, String route) {
    Navigator.pushNamedAndRemoveUntil(context, route, (_) => false);
  }

  static void goBack(BuildContext context) {
    Navigator.pop(context);
  }
}