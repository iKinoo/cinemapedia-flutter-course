// import 'package:cinemapedia/ui/providers/movies/movies_slideshow_provider.dart';
import 'package:cinemapedia/ui/providers/providers.dart';
import 'package:cinemapedia/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends StatelessWidget {
  static const name = 'home-screen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: _HomeView(),
      ),
      bottomNavigationBar: CustomBottomNavigationbar(),
    );
  }
}

class _HomeView extends ConsumerStatefulWidget {
  const _HomeView();

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<_HomeView> {
  @override
  void initState() {
    super.initState();

    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    ref.read(popularMoviesProvider.notifier).loadNextPage();
    ref.read(upcomingMoviesProvider.notifier).loadNextPage();
    ref.read(topRatedMoviesProvider.notifier).loadNextPage();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final initialLoading = ref.watch(initialLoadingProvider);

    if (initialLoading) return const FullScreenLoader();

    final slideShowMovies = ref.watch(moviesSlideShowProvider);
    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    final popularMovies = ref.watch(popularMoviesProvider);
    final upcomingMovies = ref.watch(upcomingMoviesProvider);
    final topRatedMovies = ref.watch(topRatedMoviesProvider);


    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          floating: true,
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            centerTitle: false,
            title: CustomAppbar(),
            // background: const Text('ahola'),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Column(
                children: [
                  MoviesSlideshow(movies: slideShowMovies),
                  MovieHorizontalListview(
                    movies: nowPlayingMovies,
                    title: 'En Cines',
                    subtitle: 'Lunes 20',
                    loadNextPage: () => ref
                        .read(nowPlayingMoviesProvider.notifier)
                        .loadNextPage(),
                  ),
                  MovieHorizontalListview(
                    movies: upcomingMovies,
                    title: 'Próximamente',
                    subtitle: 'En este mes',
                    loadNextPage: () => ref
                        .read(upcomingMoviesProvider.notifier)
                        .loadNextPage(),
                  ),
                  MovieHorizontalListview(
                    movies: popularMovies,
                    title: 'Populares',
                    // subtitle: '',
                    loadNextPage: () =>
                        ref.read(popularMoviesProvider.notifier).loadNextPage(),
                  ),
                  MovieHorizontalListview(
                    movies: topRatedMovies,
                    title: 'Mejor Calificadas',
                    subtitle: 'Desde siempre',
                    loadNextPage: () => ref
                        .read(topRatedMoviesProvider.notifier)
                        .loadNextPage(),
                  )
                ],
              );
            },
            childCount: 1,
          ),
        )
      ],
    );
  }
}
