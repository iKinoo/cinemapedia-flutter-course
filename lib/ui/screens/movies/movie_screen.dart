import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/ui/providers/providers.dart';

class MovieScreen extends ConsumerStatefulWidget {
  final String movieId;
  static const name = 'movie-screen';

  const MovieScreen({super.key, required this.movieId});

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {
  @override
  void initState() {
    super.initState();

    ref.read(movieInfoProvider.notifier).loadMovie(widget.movieId);
    ref.read(actorsByMovieProvider.notifier).loadActors(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    final Movie? movie = ref.watch(movieInfoProvider)[widget.movieId];

    if (movie == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          _CustomSliveAppBar(movie: movie),
          SliverList(
              delegate: SliverChildBuilderDelegate(
            childCount: 1,
            (context, index) => _MovieDetails(movie: movie),
          ))
        ],
      ),
    );
  }
}

class _MovieDetails extends StatelessWidget {
  final Movie movie;

  const _MovieDetails({required this.movie});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textStyles = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: const EdgeInsets.all(20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    movie.posterPath,
                    width: size.width * 0.3,
                  ),
                )),
            // const SizedBox(width: 10),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: SizedBox(
                width: size.width * 0.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   movie.title,
                    //   style: textStyles.titleLarge,
                    // ),
                    Text(
                      movie.releaseDate.toString(),
                      style: textStyles.bodySmall,
                    ),
                    Text(
                      movie.overview,
                      style: textStyles.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Wrap(
            children: [
              // DecoratedBox(decoration: BoxDecoration()),
              ...movie.genreIds.map((genre) => Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: Chip(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      label: Text(genre),
                      labelStyle: textStyles.bodySmall,
                    ),
                  ))
            ],
          ),
        ),
        _ActorsByMovie(movieId: movie.id),
        const SizedBox(height: 40),
      ],
    );
  }
}

class _CustomSliveAppBar extends StatelessWidget {
  final Movie movie;

  const _CustomSliveAppBar({required this.movie});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: size.height * 0.7,
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            SizedBox.expand(
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox.expand(
              child: DecoratedBox(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.transparent, Colors.black],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.7, 1]))),
            ),
            const SizedBox.expand(
              child: DecoratedBox(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Color.fromARGB(179, 0, 0, 0)
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          stops: [0.85, 1]))),
            )
          ],
        ),
        centerTitle: false,
        titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        title: Text(
          movie.title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class _ActorsByMovie extends ConsumerWidget {
  final int movieId;

  const _ActorsByMovie({required this.movieId});

  @override
  Widget build(BuildContext context, ref) {
    final List<Actor>? actors =
        ref.watch(actorsByMovieProvider)[movieId.toString()];

    if (actors == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return SizedBox(
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: actors.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      actors[index].profilePath,
                      width: 150,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Text(actors[index].name),
                SizedBox(
                  width: 150,  
                  child: Text(actors[index].character!,textAlign:TextAlign.center , softWrap: true,),
                ),
                const SizedBox(height: 10),
              ],
            ),
          );
        },
      ),
    );
  }
}
