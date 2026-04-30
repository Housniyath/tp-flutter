import 'package:go_router/go_router.dart';
import '../features/history/screens/history_screen.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/history',
      builder: (context, state) => const HistoryScreen(useMock: true),
    ),
  ],
);