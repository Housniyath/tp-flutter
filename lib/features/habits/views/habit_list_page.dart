import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../controllers/habit_controller.dart';
import 'add_habit_page.dart';
import '../../tracking/views/tracking_page.dart';

class HabitListPage extends StatefulWidget {
  const HabitListPage({super.key});

  @override
  State<HabitListPage> createState() => _HabitListPageState();
}

class _HabitListPageState extends State<HabitListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      context.read<HabitController>().ecouterHabitudes(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<HabitController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Habitudes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.track_changes),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TrackingPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
      body: controller.habits.isEmpty
          ? const Center(child: Text("Aucune habitude trouvée."))
          : ListView.builder(
              itemCount: controller.habits.length,
              itemBuilder: (context, index) {
                final habit = controller.habits[index];
                return ListTile(
                  title: Text(habit.name),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => controller.supprimerHabitude(habit.id),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddHabitPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}