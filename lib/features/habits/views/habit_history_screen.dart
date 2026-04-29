import 'package:flutter/material.dart';
import '../../../core/Theme/app_colors.dart';
import '../../../routes/app_routes.dart';

class HabitHistoryScreen extends StatelessWidget {
  const HabitHistoryScreen({super.key});

  // Fausses dates UTC — Membre 4 remplace par requête Firebase temps réel
  List<DateTime> _buildDays() {
    final now = DateTime.now().toUtc();
    return List.generate(30, (i) {
      final d = DateTime.utc(now.year, now.month, now.day)
          .subtract(Duration(days: 29 - i));
      return d;
    });
  }

  bool _isDone(DateTime day) {
    // Simule ~70% de jours cochés — Membre 4 remplace par vrai log Firebase
    return (day.day + day.month) % 3 != 0;
  }

  int _streak(List<DateTime> days) {
    int s = 0;
    for (final d in days.reversed) {
      if (_isDone(d)) s++; else break;
    }
    return s;
  }

  @override
  Widget build(BuildContext context) {
    final name  = ModalRoute.of(context)?.settings.arguments as String? ?? 'Habitude';
    final days  = _buildDays();
    final done  = days.where(_isDone).length;
    final total = days.length;
    final pct   = (done / total * 100).round();
    final streak = _streak(days);

    const months = ['Jan','Fév','Mar','Avr','Mai','Jun',
                    'Jul','Aoû','Sep','Oct','Nov','Déc'];
    const weekdays = ['L','M','M','J','V','S','D'];

    // Décale la grille pour commencer un lundi
    final firstDay   = days.first;
    final startOffset = (firstDay.weekday - 1) % 7; // 0=lundi

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation:       0,
        title: Text(name,
          style: const TextStyle(
            fontSize: 17, fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          )),
        leading: IconButton(
          icon:      const Icon(Icons.arrow_back_rounded),
          color:     AppColors.textPrimary,
          onPressed: () => AppRoutes.goBack(context),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── 3 stats ─────────────────────────────────────────
            Row(children: [
              _Stat(value: '$done', label: 'Jours réalisés',
                  icon: Icons.check_circle_outline_rounded,
                  color: AppColors.success),
              const SizedBox(width: 10),
              _Stat(value: '$streak', label: 'Série actuelle',
                  icon: Icons.local_fire_department_rounded,
                  color: const Color(0xFFFF6B35)),
              const SizedBox(width: 10),
              _Stat(value: '$pct%', label: 'Taux réussite',
                  icon: Icons.emoji_events_outlined,
                  color: AppColors.primary),
            ]),

            const SizedBox(height: 28),

            // ── Titre + mois ─────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Calendrier — 30 derniers jours',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color:        AppColors.primaryLighter,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    months[DateTime.now().month - 1],
                    style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // ── En-têtes L M M J V S D ───────────────────────────
            Row(
              children: weekdays.map((j) => Expanded(
                child: Center(
                  child: Text(j,
                    style: const TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w600,
                      color: AppColors.textHint,
                    )),
                ),
              )).toList(),
            ),
            const SizedBox(height: 6),

            // ── Grille calendrier ────────────────────────────────
            // TODO (Membre 4) : remplacer _isDone par données Firebase temps réel
            GridView.builder(
              shrinkWrap:  true,
              physics:     const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:   7,
                crossAxisSpacing: 5,
                mainAxisSpacing:  5,
                childAspectRatio: 1,
              ),
              itemCount:   startOffset + days.length,
              itemBuilder: (_, i) {
                // Cases vides avant le 1er jour
                if (i < startOffset) return const SizedBox.shrink();

                final day     = days[i - startOffset];
                final isDone  = _isDone(day);
                final isToday = day.day   == DateTime.now().day &&
                                day.month == DateTime.now().month &&
                                day.year  == DateTime.now().year;

                return Tooltip(
                  message: '${day.day}/${day.month} — '
                      '${isDone ? "Réalisé ✓" : "Non réalisé"}',
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: isDone
                          ? AppColors.success
                          : AppColors.successLighter,
                      borderRadius: BorderRadius.circular(7),
                      border: isToday
                          ? Border.all(color: AppColors.primary, width: 2)
                          : null,
                    ),
                    child: Center(
                      child: Text('${day.day}',
                        style: TextStyle(
                          fontSize:   10,
                          fontWeight: FontWeight.w700,
                          color: isDone
                              ? Colors.white
                              : AppColors.successLight,
                        )),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 14),

            // ── Légende ──────────────────────────────────────────
            Row(children: [
              _Legend(color: AppColors.success,        label: 'Réalisé'),
              const SizedBox(width: 16),
              _Legend(color: AppColors.successLighter,  label: 'Non réalisé',
                  border: AppColors.successLight),
              const SizedBox(width: 16),
              _Legend(color: Colors.white, label: 'Aujourd\'hui',
                  border: AppColors.primary),
            ]),

            const SizedBox(height: 28),

            // ── Jours cochés liste ────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Jours cochés',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
                Text('$done entrées',
                  style: const TextStyle(
                    fontSize: 12, color: AppColors.textHint)),
              ],
            ),
            const SizedBox(height: 10),

            // TODO (Membre 4) : StreamBuilder Firebase pour la liste
            ...days.where(_isDone).toList().reversed.take(5).map((day) {
              const jourNoms = ['Lun','Mar','Mer','Jeu','Ven','Sam','Dim'];
              const moisNoms = ['jan','fév','mar','avr','mai','jun',
                                'jul','aoû','sep','oct','nov','déc'];
              return Container(
                margin:  const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color:        Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: AppColors.successLight, width: 0.5),
                ),
                child: Row(children: [
                  Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      color:        AppColors.successLighter,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.check_rounded,
                        color: AppColors.success, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${jourNoms[day.weekday - 1]} ${day.day} '
                    '${moisNoms[day.month - 1]}',
                    style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    )),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color:        AppColors.successLighter,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text('Fait',
                      style: TextStyle(
                        fontSize: 11, fontWeight: FontWeight.w600,
                        color: AppColors.success,
                      )),
                  ),
                ]),
              );
            }),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity, height: 48,
              child: OutlinedButton.icon(
                onPressed: () => AppRoutes.goBack(context),
                icon:  const Icon(Icons.arrow_back_rounded),
                label: const Text('Retour aux habitudes'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side:  const BorderSide(color: AppColors.primaryLight),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Widgets helpers ────────────────────────────────────────────────────
class _Stat extends StatelessWidget {
  final String value, label;
  final IconData icon;
  final Color color;
  const _Stat({required this.value, required this.label,
      required this.icon, required this.color});

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding:     const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration:  BoxDecoration(
        color:        Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 6),
        Text(value, style: TextStyle(
          fontSize: 18, fontWeight: FontWeight.w800, color: color)),
        const SizedBox(height: 3),
        Text(label, textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 10, color: AppColors.textHint)),
      ]),
    ),
  );
}

class _Legend extends StatelessWidget {
  final Color color, border;
  final String label;
  const _Legend({required this.color, required this.label,
      this.border = Colors.transparent});

  @override
  Widget build(BuildContext context) => Row(children: [
    Container(
      width: 13, height: 13,
      decoration: BoxDecoration(
        color:        color,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: border, width: 1.5),
      ),
    ),
    const SizedBox(width: 5),
    Text(label, style: const TextStyle(
        fontSize: 11, color: AppColors.textSecondary)),
  ]);
}