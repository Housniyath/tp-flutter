import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/habit_log.dart';
import '../models/habit.dart';

/// Service Firebase pour l'historique des habitudes.
/// Fournit des Streams (temps réel) pour les logs et les habitudes.
class HistoryService {
  final FirebaseFirestore _db;

  HistoryService({FirebaseFirestore? db})
      : _db = db ?? FirebaseFirestore.instance;

  // ─── Habitudes ──────────────────────────────────────────────────────────────

  /// Stream temps réel de toutes les habitudes de l'utilisateur.
  Stream<List<Habit>> habitsStream(String userId) {
    return _db
        .collection('habits')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => Habit.fromMap(d.data(), d.id)).toList());
  }

  // ─── Logs ───────────────────────────────────────────────────────────────────

  /// Stream temps réel de tous les logs d'une habitude spécifique.
  Stream<List<HabitLog>> logsForHabitStream(String habitId) {
    return _db
        .collection('habit_logs')
        .where('habitId', isEqualTo: habitId)
        .orderBy('completedAt', descending: true)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => HabitLog.fromMap(d.data(), d.id)).toList());
  }

  /// Stream temps réel de tous les logs d'un utilisateur (tous les habitudes).
  Stream<List<HabitLog>> allLogsStream(String userId) {
    return _db
        .collection('habit_logs')
        .where('userId', isEqualTo: userId)
        .orderBy('completedAt', descending: true)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => HabitLog.fromMap(d.data(), d.id)).toList());
  }

  // ─── Helpers ────────────────────────────────────────────────────────────────

  /// Regroupe les logs par habitId → liste de jours cochés (UTC, sans heure).
  static Map<String, List<DateTime>> groupLogsByHabit(List<HabitLog> logs) {
    final map = <String, List<DateTime>>{};
    for (final log in logs) {
      map.putIfAbsent(log.habitId, () => []).add(log.dayUtc);
    }
    return map;
  }
}
