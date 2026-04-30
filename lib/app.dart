import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'features/habits/controllers/habit_controller.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/habits/views/habit_list_page.dart';


class HabitTrackerApp extends StatelessWidget  {
  const HabitTrackerApp({super.key});

  @override
   Widget build(BuildContext context)  {
    return ChangeNotifierProvider( 
      create:  (_)=> HabitController(),
      child: MaterialApp(
      title: 'Habit Tracker',
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Chargement
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          // Non connecté → Login
          if (snapshot.data == null) {
            return const LoginScreen();
          }
          // Connecté → page d'accueil (à remplacer après)
          return const HabitListPage();

          
        },
      ),
    ),
    );
  }
  }

