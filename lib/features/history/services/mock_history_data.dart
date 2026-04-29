import '../models/habit.dart';
import '../models/habit_log.dart';

/// Données fictives locales pour développer l'écran historique
/// sans dépendre du backend.
/// À retirer une fois Firebase branché.
class MockHistoryData {
  static final List<Habit> habits = [
    Habit(id: 'h1', name: 'Méditation', userId: 'user_demo'),
    Habit(id: 'h2', name: 'Sport', userId: 'user_demo'),
    Habit(id: 'h3', name: 'Lecture', userId: 'user_demo'),
    Habit(id: 'h4', name: 'Boire 2L d\'eau', userId: 'user_demo'),
  ];

  static final List<HabitLog> logs = _generateLogs();

  static List<HabitLog> _generateLogs() {
    final now = DateTime.now().toUtc();
    final result = <HabitLog>[];
    int idCounter = 0;

    // Méditation : cochée 12 jours sur les 14 derniers
    final meditationDays = [0, 1, 2, 4, 5, 6, 7, 8, 10, 11, 12, 13];
    for (final offset in meditationDays) {
      result.add(HabitLog(
        id: 'log_${idCounter++}',
        habitId: 'h1',
        userId: 'user_demo',
        completedAt: now.subtract(Duration(days: offset)),
      ));
    }

    // Sport : tous les 2 jours environ
    for (int i = 0; i < 14; i += 2) {
      result.add(HabitLog(
        id: 'log_${idCounter++}',
        habitId: 'h2',
        userId: 'user_demo',
        completedAt: now.subtract(Duration(days: i)),
      ));
    }

    // Lecture : irrégulière
    for (final offset in [0, 3, 5, 9, 13]) {
      result.add(HabitLog(
        id: 'log_${idCounter++}',
        habitId: 'h3',
        userId: 'user_demo',
        completedAt: now.subtract(Duration(days: offset)),
      ));
    }

    // Eau : seulement cette semaine
    for (int i = 0; i < 5; i++) {
      result.add(HabitLog(
        id: 'log_${idCounter++}',
        habitId: 'h4',
        userId: 'user_demo',
        completedAt: now.subtract(Duration(days: i)),
      ));
    }

    return result;
  }
}
