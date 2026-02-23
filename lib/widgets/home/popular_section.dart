import 'package:flutter/material.dart';
import '../../models/movie.dart';
import 'movie_poster_tile.dart';
import 'home_theme.dart';

class PopularSection extends StatelessWidget {
  final String title;
  final String actionText;
  final VoidCallback onAction;

  final List<Movie> movies;
  final bool Function(int id) isSaved;
  final bool Function(int id) isWatched;
  final ValueChanged<int> onTapMovie;

  const PopularSection({
    super.key,
    required this.title,
    required this.actionText,
    required this.onAction,
    required this.movies,
    required this.isSaved,
    required this.isWatched,
    required this.onTapMovie,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 270,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: movies.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemBuilder: (context, i) {
                    final m = movies[i];
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
            ),
            const SizedBox(width: 14),
            InkWell(
              onTap: onAction,
              borderRadius: BorderRadius.circular(14),
              child: Container(
                width: 60,
                height: 270,
                decoration: BoxDecoration(
                  color: HomeTheme.surface.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: HomeTheme.accent,
                        size: 28,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'See\nAll',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: HomeTheme.accent,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
