import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/habit_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddHabitPage extends StatefulWidget {
  const AddHabitPage({super.key});

  @override
  State<AddHabitPage> createState() => _AddHabitPageState();
}

class _AddHabitPageState extends State<AddHabitPage> {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter une habitude')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Nom de l'habitude",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_nameController.text.isNotEmpty) {
                  final navigator = Navigator.of(context);
                  await context.read<HabitController>().ajouterHabitude(
                    _nameController.text, 
                    FirebaseAuth.instance.currentUser!.uid,
                  );

                  if (!mounted) return; 

                  navigator.pop();
                }
              },
              child: const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }
}