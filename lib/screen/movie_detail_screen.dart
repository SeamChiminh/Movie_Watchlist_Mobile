import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/catalog_viewmodel.dart';
import '../viewmodels/library_viewmodel.dart';
import '../widgets/home/movie_poster_tile.dart';

class MovieDetailScreen extends StatefulWidget {
  final int movieId;
  const MovieDetailScreen({super.key, required this.movieId});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {

  static const _bgTop = Color(0xFF1B1A2A);
  static const _bgBottom = Color(0xFF0B0B12);
  static const _surface = Color(0xFF2A2B3E);

  @override
  Widget build(BuildContext context) {
    final catalog = context.watch<CatalogViewModel>();
    final library = context.watch<LibraryViewModel>();
    final movie = catalog.byId(widget.movieId);

    if (movie == null) {
      return Scaffold(
        backgroundColor: _bgBottom,
        body: SafeArea(
          child: Center(
            child: Text(
              'Movie not found',
              style: TextStyle(color: Colors.white.withOpacity(0.85)),
            ),
          ),
        ),
      );
    }

    final saved = library.isInWatchlist(movie.id);
    final watched = library.isWatched(movie.id);

    return Scaffold(
      backgroundColor: _bgBottom,
      body: Stack(
        children: [
          // Background poster
          Positioned.fill(
            child: Image.asset(
              movie.posterAsset,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: _bgTop),
            ),
          ),

          // Blur layer
          Positioned.fill(
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: Container(
                  color: Colors.black.withOpacity(0.35),
                ),
              ),
            ),
          ),

          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x66000000),
                    Color(0xCC0B0B12),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Top bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                  child: Row(
                    children: [
                      _CircleIconButton(
                        icon: Icons.chevron_left_rounded,
                        iconColor: Colors.white,
                        bgColor: Colors.black.withOpacity(0.35),
                        onTap: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          movie.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      _CircleIconButton(
                        icon: Icons.favorite,
                        iconColor: saved ? const Color(0xFFFF3B30) : Colors.white70,
                        bgColor: Colors.black.withOpacity(0.35),
                        onTap: () => library.toggleWatchlist(movie.id),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                    children: [
                      // Poster card
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final screenHeight = MediaQuery.of(context).size.height;
                          final safeAreaTop = MediaQuery.of(context).padding.top;
                          const topBarHeight = 60.0;
                          final availableHeight = screenHeight - safeAreaTop - topBarHeight - 100;
                          final posterWidth = MediaQuery.of(context).size.width * 0.78;
                          
                          return Center(
                            child: Hero(
                              tag: 'poster_${movie.id}',
                              child: SizedBox(
                                width: posterWidth,
                                height: availableHeight,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(22),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.35),
                                        blurRadius: 30,
                                        offset: const Offset(0, 18),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(22),
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        Image.asset(
                                          movie.posterAsset,
                                          fit: BoxFit.contain,
                                          width: double.infinity,
                                          height: double.infinity,
                                          errorBuilder: (_, __, ___) => Container(
                                            width: double.infinity,
                                            height: double.infinity,
                                            color: _surface,
                                            alignment: Alignment.center,
                                            child: const Icon(
                                              Icons.broken_image_outlined,
                                              color: Colors.white54,
                                              size: 34,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 18),

                      // year | duration | genre + rating
                      _MetaRow(
                        year: movie.year,
                        durationMinutes: movie.duration,
                        genre: movie.category,
                        rating: movie.rating,
                      ),

                      const SizedBox(height: 22),

                      Row(
                        children: [
                          Expanded(
                            child: _PlayButton(
                              isWatched: watched,
                              onTap: () {
                                // Only mark as watched if not already watched
                                if (!watched) {
                                  library.toggleWatched(movie.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Playing movie...')),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('You have already watched this movie')),
                                  );
                                }
                              },
                            ),
                          ),
                          
                        ],
                      ),

                      const SizedBox(height: 28),

                      // Story Line section
                      const Text(
                        'Story Line',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 14),

                      _StoryLine(
                        text: movie.overview,
                      ),

                      const SizedBox(height: 28),

                      // Related Movies section
                      _RelatedMoviesSection(
                        currentMovieId: movie.id,
                        category: movie.category,
                        catalog: catalog,
                        onTapMovie: (id) => _openDetail(context, id),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openDetail(BuildContext context, int id) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => MovieDetailScreen(movieId: id)),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final int year;
  final int durationMinutes;
  final String genre;
  final double rating;

  const _MetaRow({
    required this.year,
    required this.durationMinutes,
    required this.genre,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    final muted = Colors.white.withOpacity(0.55);

    Widget divider() => Container(
          width: 1,
          height: 20,
          color: Colors.white.withOpacity(0.20),
        );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        //year, duration, genre
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _MetaItem(icon: Icons.calendar_month_rounded, text: '$year', color: muted),
            const SizedBox(width: 14),
            divider(),
            const SizedBox(width: 14),
            _MetaItem(
              icon: Icons.access_time_rounded,
              text: '$durationMinutes Minutes',
              color: muted,
            ),
            const SizedBox(width: 14),
            divider(),
            const SizedBox(width: 14),
            _MetaItem(icon: Icons.local_movies_rounded, text: genre, color: muted),
          ],
        ),
        const SizedBox(height: 12),
        //rating 
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.star_rounded, size: 22, color: Color(0xFFFFB100)),
            const SizedBox(width: 6),
            Text(
              rating.toStringAsFixed(1),
              style: const TextStyle(
                color: Color(0xFFFFB100),
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MetaItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _MetaItem({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _PlayButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isWatched;
  
  const _PlayButton({
    required this.onTap,
    this.isWatched = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        height: 58,
        decoration: BoxDecoration(
          color: isWatched ? Colors.green : const Color(0xFFFF9500),
          borderRadius: BorderRadius.circular(999),
          boxShadow: [
            BoxShadow(
              color: (isWatched ? Colors.green : const Color(0xFFFF9500)).withOpacity(0.25),
              blurRadius: 18,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isWatched ? Icons.check_circle_rounded : Icons.play_arrow_rounded,
              color: Colors.white,
              size: 28,
            ),
            const SizedBox(width: 10),
            Text(
              isWatched ? 'Already Watched' : 'Play',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final VoidCallback onTap;

  const _CircleIconButton({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        height: 56,
        width: 56,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Icon(icon, color: iconColor, size: 26),
      ),
    );
  }
}

class _StoryLine extends StatelessWidget {
  final String text;

  const _StoryLine({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final bodyStyle = TextStyle(
      color: Colors.white.withOpacity(0.70),
      fontSize: 14,
      height: 1.35,
      fontWeight: FontWeight.w400,
    );

    return Text(
      text,
      style: bodyStyle,
    );
  }
}

class _RelatedMoviesSection extends StatelessWidget {
  final int currentMovieId;
  final String category;
  final CatalogViewModel catalog;
  final ValueChanged<int> onTapMovie;

  const _RelatedMoviesSection({
    required this.currentMovieId,
    required this.category,
    required this.catalog,
    required this.onTapMovie,
  });

  @override
  Widget build(BuildContext context) {
    // Get related movies
    final relatedMovies = catalog.allMovies
        .where((m) => m.category == category && m.id != currentMovieId)
        .take(5)
        .toList();

    if (relatedMovies.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Related Movies',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 270,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: relatedMovies.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (context, i) {
              final m = relatedMovies[i];
              return MoviePosterTile(
                width: 170,
                height: 270,
                title: m.title,
                genreText: m.category,
                rating: m.rating,
                posterAsset: m.posterAsset,
                onTap: () => onTapMovie(m.id),
              );
            },
          ),
        ),
      ],
    );
  }
}
