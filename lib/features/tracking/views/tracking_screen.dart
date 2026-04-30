import 'package:flutter/material.dart';
import '../../../core/Theme/app_colors.dart';
import '../../../routes/app_routes_helper.dart';

// Modèle local — Membre 3 remplacera par HabitLog + Firebase
class _HabitEntry {
  final String id;
  final String name;
  final String description;
  bool checkedToday;
  final DateTime? lastChecked;

  _HabitEntry({
    required this.id,
    required this.name,
    this.description = '',
    this.checkedToday = false,
    this.lastChecked,
  });
}

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});
  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  // Fausses données — Membre 3 branchera Firebase (StreamBuilder) ici
  final List<_HabitEntry> _entries = [
    _HabitEntry(id: '1', name: 'Sport',      description: '30 min de cardio',   checkedToday: true),
    _HabitEntry(id: '2', name: 'Lecture',    description: '20 pages par jour',   checkedToday: false),
    _HabitEntry(id: '3', name: 'Méditation', description: '10 min le matin',     checkedToday: false),
    _HabitEntry(id: '4', name: 'Hydratation',description: '2L d\'eau par jour',  checkedToday: true),
    _HabitEntry(id: '5', name: 'Journaling', description: 'Écrire 5 min',        checkedToday: false),
  ];

  String get _todayLabel {
    final now = DateTime.now();
    const jours = ['Lundi','Mardi','Mercredi','Jeudi','Vendredi','Samedi','Dimanche'];
    const mois  = ['jan','fév','mar','avr','mai','juin','juil','août','sep','oct','nov','déc'];
    return '${jours[now.weekday - 1]} ${now.day} ${mois[now.month - 1]}';
  }

  void _toggle(_HabitEntry entry) {
    // Règle : 1 seule validation par jour (Membre 3 gérera via Firebase + date UTC)
    if (entry.checkedToday) return; // déjà coché aujourd'hui → on ne peut pas décocher
    setState(() => entry.checkedToday = true);
    // TODO (Membre 3) : écrire HabitLog dans Firebase avec date UTC
    _showConfetti(entry.name);
  }

  void _showConfetti(String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white),
            const SizedBox(width: 10),
            Text('$name — Bravo ! Objectif du jour atteint 🎉'),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior:        SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final done  = _entries.where((e) => e.checkedToday).length;
    final total = _entries.length;
    final pct   = total == 0 ? 0.0 : done / total;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation:       0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Suivi quotidien',
              style: TextStyle(
                fontSize: 17, fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              _todayLabel,
              style: const TextStyle(
                fontSize: 12, color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon:      const Icon(Icons.arrow_back_rounded),
          color:     AppColors.textPrimary,
          onPressed: () => AppRoutes.goBack(context),
        ),
      ),

      body: Column(
        children: [

          // ── Carte résumé ─────────────────────────────────────────
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$done / $total complétées',
                          style: const TextStyle(
                            fontSize:   18,
                            fontWeight: FontWeight.w700,
                            color:      AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          done == total && total > 0
                              ? 'Parfait ! Toutes les habitudes cochées ✅'
                              : 'Continue comme ça !',
                          style: const TextStyle(
                            fontSize: 12,
                            color:    AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    // Cercle de progression
                    SizedBox(
                      width: 56, height: 56,
                      child: Stack(
                        children: [
                          CircularProgressIndicator(
                            value:           pct,
                            strokeWidth:     5,
                            backgroundColor: AppColors.border,
                            valueColor:      const AlwaysStoppedAnimation<Color>(
                                AppColors.success),
                          ),
                          Center(
                            child: Text(
                              '${(pct * 100).toInt()}%',
                              style: const TextStyle(
                                fontSize:   12,
                                fontWeight: FontWeight.w700,
                                color:      AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value:           pct,
                    backgroundColor: AppColors.border,
                    valueColor:      const AlwaysStoppedAnimation<Color>(
                        AppColors.success),
                    minHeight:       6,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // ── Info règle ───────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded,
                    size: 14, color: AppColors.textHint),
                const SizedBox(width: 6),
                const Expanded(
                  child: Text(
                    'Une habitude ne peut être validée qu\'une seule fois par jour.',
                    style: TextStyle(fontSize: 12, color: AppColors.textHint),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // ── Liste ────────────────────────────────────────────────
          // TODO (Membre 3) : remplacer par StreamBuilder Firebase
          Expanded(
            child: ListView.separated(
              padding:    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount:  _entries.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                final entry = _entries[i];
                final done  = entry.checkedToday;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  decoration: BoxDecoration(
                    color:        done
                        ? AppColors.successLighter
                        : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: done ? AppColors.successLight : AppColors.border,
                      width: done ? 1.5 : 0.5,
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    leading: GestureDetector(
                      onTap: () => _toggle(entry),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 32, height: 32,
                        decoration: BoxDecoration(
                          color: done
                              ? AppColors.success
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: done
                                ? AppColors.success
                                : AppColors.border,
                            width: 2,
                          ),
                        ),
                        child: done
                            ? const Icon(Icons.check_rounded,
                                color: Colors.white, size: 20)
                            : null,
                      ),
                    ),
                    title: Text(
                      entry.name,
                      style: TextStyle(
                        fontSize:   16,
                        fontWeight: FontWeight.w600,
                        color: done
                            ? AppColors.success
                            : AppColors.textPrimary,
                        decoration: done
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        decorationColor: AppColors.success,
                      ),
                    ),
                    subtitle: entry.description.isNotEmpty
                        ? Text(
                            entry.description,
                            style: const TextStyle(
                              fontSize: 13,
                              color:    AppColors.textHint,
                            ),
                          )
                        : null,
                    trailing: done
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color:        AppColors.success,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Fait ✓',
                              style: TextStyle(
                                fontSize:   11,
                                color:      Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () => _toggle(entry),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color:        AppColors.primaryLighter,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'Cocher',
                                style: TextStyle(
                                  fontSize:   11,
                                  color:      AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                    onTap: () => _toggle(entry),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}