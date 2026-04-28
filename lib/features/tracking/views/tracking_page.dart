import 'package:flutter/material.dart';
import '../controllers/tracking_controller.dart';

class TrackingPage extends StatefulWidget {
  const TrackingPage({super.key});

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  final TrackingController _controller = TrackingController();
  
  List<Map<String, dynamic>> habits = [];
  List<String> completedHabitIds = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initialLoad();
  }

  void _initialLoad() async {
    try {
      final realHabits = await _controller.getAllHabits();
      final doneToday = await _controller.getTodayCompletedIds();

      if (mounted) {
        setState(() {
          habits = realHabits; // on recup les habitudes enregistrées (grâce au code de Noussi)
          completedHabitIds = doneToday;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void toggleHabit(String id) async {
    if (completedHabitIds.contains(id)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Habitude déjà validé pour aujourd'hui. A demain ! "),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      setState(() => completedHabitIds.add(id));
      await _controller.markHabitAsDone(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF), 
      body: isLoading 
        ? const Center(child: CircularProgressIndicator(color: Color(0xFF8E9EFF)))
        : CustomScrollView(
            slivers: [
              
              SliverAppBar(
                expandedHeight: 120.0,
                pinned: true,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: const Text("Suivi Quotidien", 
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    )),
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF8E9EFF), Color(0xFFA1C4FD)], 
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
              ),

              // on affiche les habitudes sinon on signale qu'il n'y a aucune habitude enregistrée
              habits.isEmpty 
                ? SliverFillRemaining(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.assignment_late_outlined, size: 80, color: Colors.blueGrey.withOpacity(0.3)),
                        const SizedBox(height: 16),
                        const Text(
                          "Aucune habitude enregistrée",
                          style: TextStyle(fontSize: 18, color: Colors.blueGrey, fontWeight: FontWeight.w500),
                        ),
                        const Text("Ajoutez-en pour commencer le suivi !", 
                          style: TextStyle(fontSize: 14, color: Colors.grey)),
                      ],
                    ),
                  )
                : SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final habit = habits[index];
                          final isDone = completedHabitIds.contains(habit['id']);

                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 400),
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: isDone 
                                    ? Colors.green.withOpacity(0.1) 
                                    : Colors.black.withOpacity(0.03),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(12),
                              leading: CircleAvatar(
                                backgroundColor: isDone ? Colors.green.withOpacity(0.1) : Color(0xFFF0F4FF),
                                child: Icon(
                                  isDone ? Icons.done_all : Icons.wb_sunny_outlined,
                                  color: isDone ? Colors.green : Color(0xFF8E9EFF),
                                ),
                              ),
                              title: Text(habit['nom'], 
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: isDone ? Colors.green.shade700 : Colors.black87,
                                  decoration: isDone ? TextDecoration.lineThrough : null,
                                )),
                              subtitle: Text(habit['desc'] ?? ''),
                              trailing: Checkbox(
                                value: isDone,
                                activeColor: Colors.green,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                onChanged: (_) => toggleHabit(habit['id']),
                              ),
                            ),
                          );
                        },
                        childCount: habits.length,
                      ),
                    ),
                  ),
            ],
          ),
    );
  }
}