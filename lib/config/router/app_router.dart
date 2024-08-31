import 'package:go_router/go_router.dart';

import 'package:cinemapedia/ui/screens/screens.dart';
import 'package:cinemapedia/ui/views/views.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
        builder: (context, state, child) {
          return HomeScreen(childView: child);
        },
        routes: [
          GoRoute(
              path: '/',
              builder: (context, state) {
                return const HomeView();
              },
              routes: [
                GoRoute(
                  path: 'movie/:id',
                  name: MovieScreen.name,
                  builder: (context, state) {
                    final movideId = state.pathParameters['id'] ?? 'no-id';

                    return MovieScreen(
                      movieId: movideId,
                    );
                  },
                ),
              ]),
          GoRoute(
            path: '/favorites',
            builder: (context, state) {
              return const FavoritesView();
            },
          )
        ])

    // Rutas padre/hija
    // GoRoute(
    //     path: '/',
    //     name: HomeScreen.name,
    //     builder: (context, state) => const HomeScreen(
    //           childView: FavoritesView(),
    //         ),
    //     routes: [
    //       GoRoute(
    //         path: 'movie/:id',
    //         name: MovieScreen.name,
    //         builder: (context, state) {
    //           final movideId = state.pathParameters['id'] ?? 'no-id';

    //           return MovieScreen(
    //             movieId: movideId,
    //           );
    //         },
    //       ),
    //     ]),
  ],
);
