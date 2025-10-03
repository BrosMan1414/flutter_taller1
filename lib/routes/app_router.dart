import 'package:go_router/go_router.dart';

import '../screens/home/home_screen.dart';
import '../screens/asincronia/asincrionia_screen.dart';
import '../screens/timer/timer_screen.dart';
import '../screens/isolate/isolate_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/asincronia',
      name: 'asincronia',
      builder: (context, state) => const FutureView(),
    ),
    GoRoute(
      path: '/timer',
      name: 'timer',
      builder: (context, state) => const TimerView(),
    ),
    GoRoute(
      path: '/isolate',
      name: 'isolate',
      builder: (context, state) => const IsolateView(),
    ),
  ],
);
