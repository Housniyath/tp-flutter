import 'package:flutter/material.dart';
import '../models/habit.dart';
import 'history_calendar_strip.dart';

class HabitHistoryCard extends StatelessWidget {
  final Habit habit;
  final List<DateTime> completedDays;

  const HabitHistoryCard({
    super.key,
    required this.habit,
    required this.completedDays,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final total = completedDays.length;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
            color: scheme.outlineVariant.withValues(alpha: 0.4)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    habit.name,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                _BadgeCount(total: total),
              ],
            ),
            const SizedBox(height: 12),
            HistoryCalendarStrip(completedDays: completedDays, days: 14),
            const SizedBox(height: 8),
            Text(
              '$total jour${total > 1 ? 's' : ''} complété${total > 1 ? 's' : ''}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BadgeCount extends StatelessWidget {
  final int total;
  const _BadgeCount({required this.total});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '🔥 $total',
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: scheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}