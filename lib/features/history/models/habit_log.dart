/// Modèle représentant un log de complétion d'une habitude pour un jour donné.
class HabitLog {
  final String id;
  final String habitId;
  final String userId;
  final DateTime completedAt; // stocké en UTC

  const HabitLog({
    required this.id,
    required this.habitId,
    required this.userId,
    required this.completedAt,
  });

  /// Date normalisée à minuit UTC (pour comparaisons journalières)
  DateTime get dayUtc => DateTime.utc(
        completedAt.year,
        completedAt.month,
        completedAt.day,
      );

  /// Depuis Firestore
  factory HabitLog.fromMap(Map<String, dynamic> map, String docId) {
    return HabitLog(
      id: docId,
      habitId: map['habitId'] as String,
      userId: map['userId'] as String,
      completedAt: DateTime.parse(map['completedAt'] as String).toUtc(),
    );
  }

  /// Vers Firestore
  Map<String, dynamic> toMap() {
    return {
      'habitId': habitId,
      'userId': userId,
      'completedAt': completedAt.toUtc().toIso8601String(),
    };
  }

  @override
  String toString() =>
      'HabitLog(id: $id, habitId: $habitId, day: ${dayUtc.toIso8601String()})';
}
