import 'package:flutter/material.dart';

class HistoryCalendarStrip extends StatelessWidget {
  final List<DateTime> completedDays;
  final int days;

  const HistoryCalendarStrip({
    super.key,
    required this.completedDays,
    this.days = 14,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final today = _todayUtc();

    final checkedSet = completedDays
        .map((d) => DateTime.utc(d.year, d.month, d.day).toIso8601String())
        .toSet();

    return Row(
      children: List.generate(days, (i) {
        final date = today.subtract(Duration(days: days - 1 - i));
        final key = date.toIso8601String();
        final isChecked = checkedSet.contains(key);
        final isToday = i == days - 1;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: _DayCell(
              date: date,
              isChecked: isChecked,
              isToday: isToday,
              scheme: scheme,
            ),
          ),
        );
      }),
    );
  }

  static DateTime _todayUtc() {
    final now = DateTime.now().toUtc();
    return DateTime.utc(now.year, now.month, now.day);
  }
}

class _DayCell extends StatelessWidget {
  final DateTime date;
  final bool isChecked;
  final bool isToday;
  final ColorScheme scheme;

  const _DayCell({
    required this.date,
    required this.isChecked,
    required this.isToday,
    required this.scheme,
  });

  static const dayLabels = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];

  @override
  Widget build(BuildContext context) {
    final bgColor = isChecked
        ? scheme.primary
        : scheme.surfaceContainerHighest.withValues(alpha: 0.5);
    final fgColor = isChecked
        ? scheme.onPrimary
        : scheme.onSurfaceVariant.withValues(alpha: 0.5);

    return Tooltip(
      message: _formatDate(date),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(6),
          border: isToday
              ? Border.all(color: scheme.primary, width: 2)
              : null,
        ),
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              dayLabels[date.weekday - 1],
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: fgColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${date.day}',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: fgColor,
              ),
            ),
            const SizedBox(height: 2),
            Icon(
              isChecked ? Icons.check_circle : Icons.circle_outlined,
              size: 8,
              color: fgColor,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
}