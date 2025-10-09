import 'package:go_router/go_router.dart';

import '../views/home/home_screen.dart';
import '../views/asincronia/asincrionia_screen.dart';
import '../views/timer/timer_screen.dart';
import '../views/isolate/isolate_screen.dart';
import '../views/onepiece/listado_view.dart';
import '../views/onepiece/detalle_view.dart';
import '../models/character.dart';

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
    // One Piece routes
    GoRoute(
      path: '/onepiece',
      name: 'onepiece_list',
      builder: (context, state) => const ListadoView(),
    ),
    GoRoute(
      path: '/onepiece/detail',
      name: 'onepiece_detail',
      builder: (context, state) {
        final extra = state.extra;
        if (extra is! Character) {
          // Fallback: pantalla simple de error si no se pasó el Character
          return const HomeScreen();
        }
        return DetalleView(character: extra);
      },
    ),
  ],
);
