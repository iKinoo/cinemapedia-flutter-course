import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/ui/delegates/search_movie_delegate.dart';
import 'package:cinemapedia/ui/providers/providers.dart';

class CustomAppbar extends ConsumerWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final colorTheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final searchQuery = ref.watch(searchQueryProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Icon(Icons.movie_outlined, color: colorTheme.primary),
              const SizedBox(width: 5),
              Text('Cinemapedia', style: textTheme.titleMedium),
              const Spacer(),
              IconButton(
                  onPressed: () async {
                    final movieRepository = ref.read(movieRepositoryProvider);

                    showSearch<Movie?>(
                      // query: searchQuery,
                      context: context,
                      delegate: SearchMovieDelegate(
                        searchMovies: movieRepository.searchMovies,
                      ),
                    ).then(
                      (movie) {
                        context.push('/movie/${movie?.id}');
                      },
                    );
                  },
                  icon: const Icon(Icons.search))
            ],
          ),
        ),
      ),
    );
  }
}
