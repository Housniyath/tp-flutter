import 'package:flutter/material.dart';
import 'core/Theme/app_theme.dart';    // ✅ chemin corrigé
import 'routes/app_routes.dart';        // ✅ chemin corrigé

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:                      'HabitFlow',
      debugShowCheckedModeBanner: false,
      theme:                      AppTheme.lightTheme,
      routes:                     AppRoutes.routes,
    );
  }
}