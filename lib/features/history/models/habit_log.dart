import 'package:cloud_firestore/cloud_firestore.dart';

class HabitLog {
  final String id;
  final String habitId;
  final String userId;
  final DateTime dayUtc;

  HabitLog({
    required this.id,
    required this.habitId,
    required this.userId,
    required this.dayUtc,
  });

  factory HabitLog.fromMap(Map<String, dynamic> map, String id) {
    // on essaie completedAt d'abord, sinon date
    DateTime day;
    if (map['completedAt'] is Timestamp) {
      day = (map['completedAt'] as Timestamp).toDate().toUtc();
    } else if (map['date'] is Timestamp) {
      day = (map['date'] as Timestamp).toDate().toUtc();
    } else {
      day = DateTime.now().toUtc();
    }

    return HabitLog(
      id: id,
      habitId: map['habitId'] ?? '',
      userId: map['userId'] ?? '',
      dayUtc: day,
    );
  }
}