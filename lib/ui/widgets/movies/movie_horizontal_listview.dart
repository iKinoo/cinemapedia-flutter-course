import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MovieHorizontalListview extends StatefulWidget {
  final List<Movie> movies;
  final String? title;
  final String? subtitle;
  final VoidCallback? loadNextPage;

  const MovieHorizontalListview({
    super.key,
    required this.movies,
    this.title,
    this.subtitle,
    this.loadNextPage,
  });

  @override
  State<MovieHorizontalListview> createState() =>
      _MovieHorizontalListviewState();
}

class _MovieHorizontalListviewState extends State<MovieHorizontalListview> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(
      () {
        // print(scrollController.position.pixels);

        if (widget.loadNextPage == null) return;

        if ((scrollController.position.pixels + 200) >=
            scrollController.position.maxScrollExtent) {
          widget.loadNextPage!();
        }
      },
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Column(
        children: [
          if (widget.title != null || widget.subtitle != null)
            _Title(
              title: widget.title,
              subtitle: widget.subtitle,
            ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: widget.movies.length,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return FadeInRight(child: _Slide(movie: widget.movies[index]));
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: unused_element
class _Slide extends StatelessWidget {
  final Movie movie;

  const _Slide({required this.movie});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return Container(
      width: 170,
      // height:10000

      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //* Poster
          _MoviePoster(movie: movie),
          const SizedBox(height: 5),
          // * Puntaje
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              children: [
                Icon(Icons.star_half_outlined, color: Colors.yellow.shade800),
                Text(
                  '${movie.voteAverage}',
                  style: textStyle.bodyMedium
                      ?.copyWith(color: Colors.yellow.shade800),
                ),
                const Spacer(),
                Text(HumanFormats.number(movie.popularity))
              ],
            ),
          ),
          //* Título
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              // width: 150,
              height: 50,
              child: Text(
                movie.title,
                style: textStyle.titleMedium,
                maxLines: 2,
                // textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MoviePoster extends StatelessWidget {
  const _MoviePoster({
    required this.movie,
  });

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.network(
          movie.posterPath,
          width: 150,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress != null) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 1),
                child: Center(child: CircularProgressIndicator(strokeWidth: 1)),
              );
            }
            return GestureDetector(
              onTap: () => context.push('/movie/${movie.id}'),
              child: FadeIn(child: child),
            );
          },
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final String? title;
  final String? subtitle;

  const _Title({this.subtitle, this.title});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.titleLarge;

    return Container(
      padding: const EdgeInsets.only(top: 10),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          if (title != null) Text(title!, style: textStyle),
          const Spacer(),
          if (subtitle != null)
            FilledButton.tonal(
              onPressed: () {},
              style: const ButtonStyle(visualDensity: VisualDensity.compact),
              child: Text(subtitle!),
            )
        ],
      ),
    );
  }
}
