import 'package:cloud_firestore/cloud_firestore.dart';

class TrackingModel {
  final String habitId; 
  final DateTime date;  
  final bool isCompleted;

  TrackingModel({
    required this.habitId,
    required this.date,
    this.isCompleted = true,
  });

  // on convertit les données de Firebase 
  factory TrackingModel.fromFirestore(Map<String, dynamic> data) {
    return TrackingModel(
      habitId: data['habitId'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      isCompleted: data['isCompleted'] ?? true,
    );
  }

  //  on prépare les données pour les envoyer vers Firebase
  Map<String, dynamic> toFirestore() {
    return {
      'habitId': habitId,
      'date': Timestamp.fromDate(date),
      'isCompleted': isCompleted,
    };
  }
}