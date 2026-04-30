import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/habit_model.dart';

class HabitController extends ChangeNotifier {
  final CollectionReference _habitsRef = 
      FirebaseFirestore.instance.collection('habits');

  // Ma liste d'habitudes locale
  List<HabitModel> habits = [];

  // Cette fonction va permettre la recuperation des habits
  void ecouterHabitudes(String userId) {
    _habitsRef
        .where('userId', isEqualTo: userId)
        .snapshots()
        .listen((snapshot) {
      habits = snapshot.docs.map((doc) {
        return HabitModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
      
      notifyListeners();
    });
  }

  // Ajout d'une habitude
  Future<void> ajouterHabitude(String nom, String userId) async {
    HabitModel nouvelleHabit = HabitModel(
      id: '', 
      userId: userId,
      name: nom,
      createdAt: DateTime.now(),
    );

    await _habitsRef.add(nouvelleHabit.toMap());
  }

  // Suppression d'une habitude
  Future<void> supprimerHabitude(String habitId) async {
    await _habitsRef.doc(habitId).delete();
  }
}