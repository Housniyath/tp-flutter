import 'package:flutter/material.dart';
import '../../../core/Theme/app_colors.dart';
import '../../../routes/app_routes.dart';

class HabitLocal {
  final String id;
  String name;
  String description;
  bool doneToday;

  HabitLocal({
    required this.id,
    required this.name,
    this.description = '',
    this.doneToday = false,
  });
}

class HabitsScreen extends StatefulWidget {
  const HabitsScreen({super.key});
  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  final List<HabitLocal> _habits = [
    HabitLocal(id: '1', name: 'Sport',       description: '30 min de cardio'),
    HabitLocal(id: '2', name: 'Lecture',     description: '20 pages par jour'),
    HabitLocal(id: '3', name: 'Méditation',  description: '10 min le matin'),
  ];

  // Garde trace des coches non encore enregistrées
  bool get _hasUnsaved => _habits.any((h) => h.doneToday);

  void _openHabitForm({HabitLocal? existing}) {
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final descCtrl = TextEditingController(text: existing?.description ?? '');
    final isEdit   = existing != null;

    showModalBottomSheet(
      context:            context,
      isScrollControlled: true,
      backgroundColor:    Colors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          decoration: const BoxDecoration(
            color:        Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
          child: Column(
            mainAxisSize:      MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40, height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color:        AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                isEdit ? 'Modifier l\'habitude' : 'Nouvelle habitude',
                style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              _sheetField(nameCtrl, 'Nom', 'Ex: Faire du sport',
                  Icons.star_outline, autofocus: true),
              const SizedBox(height: 14),
              _sheetField(descCtrl, 'Description (optionnel)',
                  'Ex: 30 min de cardio chaque matin', Icons.notes_outlined),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity, height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    final name = nameCtrl.text.trim();
                    if (name.isEmpty) return;
                    setState(() {
                      if (isEdit) {
                        existing.name        = name;
                        existing.description  = descCtrl.text.trim();
                      } else {
                        _habits.add(HabitLocal(
                          id:          DateTime.now().millisecondsSinceEpoch.toString(),
                          name:        name,
                          description: descCtrl.text.trim(),
                        ));
                      }
                    });
                    Navigator.pop(context);
                  },
                  child: Text(
                    isEdit ? 'Enregistrer' : 'Ajouter l\'habitude',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sheetField(TextEditingController ctrl, String label, String hint,
      IconData icon, {bool autofocus = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(
          fontSize: 13, fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
        )),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          autofocus:  autofocus,
          decoration: InputDecoration(
            hintText:   hint,
            prefixIcon: Icon(icon),
            filled:     true,
            fillColor:  AppColors.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:   const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:   const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:   const BorderSide(
                  color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  void _deleteHabit(HabitLocal habit) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Supprimer',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        content: Text('Supprimer "${habit.name}" ?',
            style: const TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              setState(() => _habits.removeWhere((h) => h.id == habit.id));
              Navigator.pop(context);
            },
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  void _toggleDone(HabitLocal habit) {
    setState(() => habit.doneToday = !habit.doneToday);
  }

  // Bouton "Enregistrer le suivi" → va vers TrackingScreen
  void _saveTracking() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
            SizedBox(width: 10),
            Text('Suivi enregistré pour aujourd\'hui !'),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior:        SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
    // TODO (Membre 3) : persister les logs dans Firebase
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) AppRoutes.goTo(context, AppRoutes.tracking);
    });
  }

  @override
  Widget build(BuildContext context) {
    final done  = _habits.where((h) => h.doneToday).length;
    final total = _habits.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor:           Colors.white,
        elevation:                 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Container(
              width: 32, height: 32,
              decoration: BoxDecoration(
                color:        AppColors.primary,
                borderRadius: BorderRadius.circular(9),
              ),
              child: const Icon(Icons.track_changes_rounded,
                  color: Colors.white, size: 18),
            ),
            const SizedBox(width: 10),
            const Text(
              'Habit Tracker',
              style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w800,
                color: AppColors.primary, letterSpacing: -0.3,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon:    const Icon(Icons.today_rounded, color: AppColors.primary),
            tooltip: 'Suivi du jour',
            onPressed: () => AppRoutes.goTo(context, AppRoutes.tracking),
          ),
          IconButton(
            icon:      const Icon(Icons.logout_rounded,
                color: AppColors.textSecondary),
            onPressed: () =>
                AppRoutes.goToAndClearStack(context, AppRoutes.login),
          ),
        ],
      ),

      body: Column(
        children: [

          // ── Barre progression ───────────────────────────────────
          Container(
            color:   Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  total == 0
                      ? 'Aucune habitude'
                      : '$done / $total cochées aujourd\'hui',
                  style: const TextStyle(
                    fontSize: 13, color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                if (total > 0)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value:           total == 0 ? 0 : done / total,
                      backgroundColor: AppColors.border,
                      valueColor:      const AlwaysStoppedAnimation<Color>(
                          AppColors.success),
                      minHeight: 6,
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // ── Liste ────────────────────────────────────────────────
          Expanded(
            child: _habits.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.playlist_add_rounded,
                            size: 64, color: AppColors.border),
                        const SizedBox(height: 16),
                        const Text('Aucune habitude',
                          style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          )),
                        const SizedBox(height: 8),
                        const Text('Appuyez sur + pour commencer',
                          style: TextStyle(color: AppColors.textHint)),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    itemCount: _habits.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) {
                      final h = _habits[i];
                      return _HabitCard(
                        habit:     h,
                        onToggle:  () => _toggleDone(h),
                        onEdit:    () => _openHabitForm(existing: h),
                        onDelete:  () => _deleteHabit(h),
                        onHistory: () => AppRoutes.goTo(
                            context, AppRoutes.habitHistory, args: h.name),
                      );
                    },
                  ),
          ),

          // ── Bouton ENREGISTRER — apparaît quand au moins 1 cochée ──
          AnimatedSlide(
            offset: _hasUnsaved ? Offset.zero : const Offset(0, 1),
            duration: const Duration(milliseconds: 300),
            curve:    Curves.easeOutCubic,
            child: AnimatedOpacity(
              opacity:  _hasUnsaved ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 250),
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color:      Colors.black.withOpacity(0.06),
                      blurRadius: 12,
                      offset:     const Offset(0, -4),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: SizedBox(
                    width: double.infinity, height: 52,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                      onPressed: _saveTracking,
                      icon:  const Icon(Icons.save_rounded, size: 20),
                      label: Text(
                        'Enregistrer le suivi ($done cochée${done > 1 ? 's' : ''})',
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      floatingActionButton: _hasUnsaved
          ? null
          : FloatingActionButton.extended(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              onPressed:       () => _openHabitForm(),
              icon:            const Icon(Icons.add_rounded),
              label:           const Text('Ajouter',
                  style: TextStyle(fontWeight: FontWeight.w600)),
            ),
    );
  }
}

// ── Carte habitude ─────────────────────────────────────────────────────
class _HabitCard extends StatelessWidget {
  final HabitLocal  habit;
  final VoidCallback onToggle, onEdit, onDelete, onHistory;

  const _HabitCard({
    required this.habit,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
    required this.onHistory,
  });

  @override
  Widget build(BuildContext context) {
    final done = habit.doneToday;
    return GestureDetector(
      onTap: onHistory,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color:        done ? const Color(0xFFE1F5EE) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: done ? AppColors.successLight : AppColors.border,
            width: done ? 1.5 : 0.5,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            GestureDetector(
              onTap: onToggle,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 28, height: 28,
                decoration: BoxDecoration(
                  color:        done ? AppColors.success : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: done ? AppColors.success : AppColors.border,
                    width: 1.5,
                  ),
                ),
                child: done
                    ? const Icon(Icons.check_rounded,
                        color: Colors.white, size: 18)
                    : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(habit.name,
                    style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600,
                      color:      done
                          ? AppColors.textSecondary
                          : AppColors.textPrimary,
                      decoration: done
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    )),
                  if (habit.description.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(habit.description,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textHint)),
                  ],
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _Btn(icon: Icons.bar_chart_rounded,
                    color: AppColors.primary,    onTap: onHistory),
                const SizedBox(width: 4),
                _Btn(icon: Icons.edit_outlined,
                    color: AppColors.textSecondary, onTap: onEdit),
                const SizedBox(width: 4),
                _Btn(icon: Icons.delete_outline_rounded,
                    color: AppColors.danger,     onTap: onDelete),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Btn extends StatelessWidget {
  final IconData icon; final Color color; final VoidCallback onTap;
  const _Btn({required this.icon, required this.color, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 32, height: 32,
      decoration: BoxDecoration(
        color:        color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Icon(icon, size: 17, color: color),
    ),
  );
}