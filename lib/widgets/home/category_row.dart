import 'package:flutter/material.dart';
import '../../models/movie.dart';
import 'home_theme.dart';
import 'movie_poster_tile.dart';

class CategoryRow extends StatelessWidget {
  final List<String> items;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final List<Movie> movies;
  final ValueChanged<int> onTapMovie;
  final VoidCallback? onSeeAll;

  const CategoryRow({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onChanged,
    required this.movies,
    required this.onTapMovie,
    this.onSeeAll,
  });

  List<Movie> _getFilteredMovies() {
    if (selectedIndex == 0) {
      // All category  movies
      return movies;
    }
    final selectedCategory = items[selectedIndex];
    return movies.where((movie) => 
      movie.category.toLowerCase() == selectedCategory.toLowerCase()
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredMovies = _getFilteredMovies();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category buttons
        SizedBox(
          height: 46,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (context, i) {
              final selected = i == selectedIndex;
              return InkWell(
                onTap: () => onChanged(i),
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                  decoration: BoxDecoration(
                    color: selected ? HomeTheme.surface : Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    items[i],
                    style: TextStyle(
                      color: selected ? HomeTheme.accent : Colors.white.withOpacity(0.85),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        // Movies See All
        if (filteredMovies.isNotEmpty) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 270,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: filteredMovies.length > 3 ? 3 : filteredMovies.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 14),
                    itemBuilder: (context, i) {
                      final m = filteredMovies[i];
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
              if (filteredMovies.length > 3 && onSeeAll != null) ...[
                const SizedBox(width: 14),
                InkWell(
                  onTap: onSeeAll,
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
            ],
          ),
        ] else if (selectedIndex > 0) ...[
          // Show empty state if no movies found 
          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Text(
                'No movies found in this category',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
