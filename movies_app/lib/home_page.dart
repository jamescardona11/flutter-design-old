import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:movies_app/details/movie_detail_page.dart';

import 'data/movies.json.dart';
import 'models/movie_entity.dart';
import 'widgets/cached_image.dart';
import 'widgets/rating_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<MovieEntity> movies = moviesJSON.map((e) => MovieEntity.fromJson(e)).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MoviesGridViewWidget(movies: movies),
    );
  }
}

class MoviesGridViewWidget extends StatelessWidget {
  final List<MovieEntity> movies;

  const MoviesGridViewWidget({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.count(
      crossAxisCount: 3,
      mainAxisSpacing: 5,
      crossAxisSpacing: 10,
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];

        final width = (index % 5 + 1) * 100;
        final height = (index ~/ 5 + 1) * 100;

        return SizedBox(
          width: width.toDouble(),
          height: height.toDouble().clamp(0, 250),
          child: _GridViewItem(
            movie: movie,
            fit: height > 250 ? BoxFit.fitHeight : BoxFit.fitWidth,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MovieDetailPage(id: index + 1)),
              );
            },
          ),
        );
      },
    );
  }
}

class _GridViewItem extends StatelessWidget {
  const _GridViewItem({
    super.key,
    required this.movie,
    this.fit = BoxFit.fitWidth,
    this.onTap,
  });

  final MovieEntity movie;
  final BoxFit fit;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap?.call();
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          Hero(
            tag: movie.id.toString(),
            transitionOnUserGestures: true,
            createRectTween: (begin, end) {
              return MaterialRectCenterArcTween(begin: begin, end: end);
            },
            flightShuttleBuilder: (
              BuildContext flightContext,
              Animation<double> animation,
              HeroFlightDirection flightDirection,
              BuildContext fromHeroContext,
              BuildContext toHeroContext,
            ) {
              return AnimatedBuilder(
                animation: CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOut,
                  reverseCurve: Curves.linear,
                ),
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1 + (0.2 * animation.value),
                    child: Transform.rotate(
                      angle: (1 - animation.value) * 0.1,
                      child: Opacity(
                        opacity: 0.8 + (0.2 * animation.value),
                        child: child,
                      ),
                    ),
                  );
                },
                child: CachedImage(
                  imageUrl: movie.imageUrl,
                  radius: 20,
                  fit: fit,
                ),
              );
            },
            child: CachedImage(
              imageUrl: movie.imageUrl,
              radius: 20,
              fit: fit,
            ),
          ),
          Positioned(
            right: 5,
            top: 5,
            child: RatingWidget(
              rating: movie.rating.toStringAsFixed(2),
            ),
          ),
          //
        ],
      ),
    );
  }
}
