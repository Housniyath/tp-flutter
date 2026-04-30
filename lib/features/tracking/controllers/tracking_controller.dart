import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/tracking_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TrackingController {
  // on crée une référence vers la collection "logs" dans Firebase
  final CollectionReference _logsCollection = 
      FirebaseFirestore.instance.collection('logs');

  // la fonction pour recup toutes les habitudes créées par Noussi
  Future<List<Map<String, dynamic>>> getAllHabits() async {
    try {
     final userId = FirebaseAuth.instance.currentUser!.uid;
    print("userId connecté : $userId"); // debug
    
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('habits')
        .where('userId', isEqualTo: userId)
        .get();
    
    print("Nombre d'habitudes trouvées : ${query.docs.length}"); // debug
    
    return query.docs.map((doc) => {
      'id': doc.id,
      'nom': doc['name'] ?? 'Sans nom',
      'desc': (doc.data() as Map<String, dynamic>).containsKey('description') 
    ? doc['description'] 
    : '',
    }).toList();
  } catch (e) {
    print("Erreur : $e");
    return [];
    }
  }

  // la fonction pour enregist une habitude déjà réalisée pour le jour courant
  Future<void> markHabitAsDone(String habitId) async {
    try {
     final userId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('habit_logs').add({
      'habitId': habitId,
      'userId': userId,
      'completedAt': Timestamp.fromDate(DateTime.now().toUtc()),
      'date': DateTime.now().toUtc(),
    });
  } catch (e) {
    print("Erreur lors de l'enregistrement : $e");
  }
  }

  // la fonction pour recup les id des habitudes déjà faites 'aujourdhui'
 Future<List<String>> getTodayCompletedIds() async {
  List<String> completedIds = [];
  final userId = FirebaseAuth.instance.currentUser!.uid;
  DateTime now = DateTime.now();
  DateTime startOfDay = DateTime(now.year, now.month, now.day).toUtc();

  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('habit_logs')
        .where('userId', isEqualTo: userId)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .get();

    for (var doc in querySnapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      completedIds.add(data['habitId'] ?? '');
    }
  } catch (e) {
    print("Erreur de lecture : $e");
  }
  return completedIds;
}
}