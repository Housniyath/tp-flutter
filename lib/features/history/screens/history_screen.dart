import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/habit.dart';
import '../models/habit_log.dart';
import '../services/history_service.dart';
import '../services/mock_history_data.dart';
import '../widgets/habit_history_card.dart';

/// Écran principal de l'historique.
///
/// En développement (useMock: true) → données locales.
/// En production (useMock: false)   → Firebase temps réel.
class HistoryScreen extends StatefulWidget {
  /// Passer [useMock: true] en dev tant que Firebase n'est pas prêt.
  final bool useMock;

  const HistoryScreen({super.key, this.useMock = false});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final HistoryService _service = HistoryService();

  // ─── Mode MOCK (dev local) ───────────────────────────────────────────────────
  List<Habit> get _mockHabits => MockHistoryData.habits;
  List<HabitLog> get _mockLogs => MockHistoryData.logs;

  // ─── Build ───────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Historique'),
        centerTitle: true,
        elevation: 0,
      ),
      body: widget.useMock
          ? _buildBody(habits: _mockHabits, logs: _mockLogs)
          : _buildFirebaseBody(),
    );
  }

  // ─── Firebase (temps réel) ──────────────────────────────────────────────────
  Widget _buildFirebaseBody() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Center(child: Text('Non connecté'));
    }
    final userId = user.uid;

    return StreamBuilder<List<Habit>>(
      stream: _service.habitsStream(userId),
      builder: (context, habitSnap) {
        if (habitSnap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (habitSnap.hasError) {
          return Center(child: Text('Erreur : ${habitSnap.error}'));
        }
        final habits = habitSnap.data ?? [];

        return StreamBuilder<List<HabitLog>>(
          stream: _service.allLogsStream(userId),
          builder: (context, logSnap) {
            if (logSnap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (logSnap.hasError) {
              return Center(child: Text('Erreur : ${logSnap.error}'));
            }
            final logs = logSnap.data ?? [];
            return _buildBody(habits: habits, logs: logs);
          },
        );
      },
    );
  }

  // ─── Corps commun (mock + Firebase) ─────────────────────────────────────────
  Widget _buildBody({
    required List<Habit> habits,
    required List<HabitLog> logs,
  }) {
    if (habits.isEmpty) {
      return const _EmptyHistory();
    }

    final grouped = HistoryService.groupLogsByHabit(logs);

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      itemCount: habits.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final habit = habits[index];
        final days = grouped[habit.id] ?? [];
        return HabitHistoryCard(
          habit: habit,
          completedDays: days,
        );
      },
    );
  }
}

// ─── Widget vide ───────────────────────────────────────────────────────────────
class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history_outlined,
            size: 72,
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'Aucune habitude trouvée',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Créez vos premières habitudes\npour voir votre historique ici.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
          ),
        ],
      ),
    );
  }
}
